-- The Potato Processor - A simple processor for FPGAs
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief Wishbone SSD Module.
--!
--! The following registers are defined:
--! |---------|---------------------------------------------------------------|
--! | Address | Description                                                   |
--! |---------|---------------------------------------------------------------|
--! | 0x00    | Digit 0 input value    (read/write)                           |
--! | 0x04    | Digit 1 input value    (read/write)                           |
--! | 0x08    | Digit 2 input value    (read/write)                           |
--! | 0x0c    | Digit 3 input value    (read/write)                           |
--! |---------|---------------------------------------------------------------|
--!

entity pp_soc_ssd is
    
    -- CLK_DIVISOR:  Clock Divisor for SSD digits mux. Tune to provide about 1kHz
    generic (CLK_DIVISOR :  POSITIVE := 100000);

	port(
		clk : in std_logic;
		reset : in std_logic;

		-- Seven Segments Display interface:
		segments :  out std_logic_vector(6 downto 0);
		anodes   :  out std_logic_vector(6 downto 0);

		-- Wishbone interface:
		wb_adr_in  : in  std_logic_vector(11 downto 0);
		wb_dat_in  : in  std_logic_vector(31 downto 0);
		wb_dat_out : out std_logic_vector(31 downto 0);
		wb_cyc_in  : in  std_logic;
		wb_stb_in  : in  std_logic;
		wb_we_in   : in  std_logic;
		wb_ack_out : out std_logic
	);
end entity pp_soc_ssd;

architecture behaviour of pp_soc_ssd is

	signal ack : std_logic := '0';
	
	-- Clock divider
    signal clk_div_cnt    : unsigned (31 downto 0) := (others => '0');
    signal clk_div        : std_logic := '0';
    
    -- SSD index. Used to select currently decoded display
    signal ssd_idx        : unsigned (1 downto 0) := (others => '0');
    
    -- Holds current decoded digit
    signal digit          : STD_LOGIC_VECTOR (3 downto 0);
    
    -- Digits values
    signal digit0         : STD_LOGIC_VECTOR (3 downto 0);
    signal digit1         : STD_LOGIC_VECTOR (3 downto 0);
    signal digit2         : STD_LOGIC_VECTOR (3 downto 0);
    signal digit3         : STD_LOGIC_VECTOR (3 downto 0);
    
begin
	wb_ack_out <= ack and wb_cyc_in and wb_stb_in;

	wishbone: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
			    digit0 <= (others => '0');
			    digit1 <= (others => '0');
			    digit2 <= (others => '0');
			    digit3 <= (others => '0');

				wb_dat_out <= (others => '0');
				ack <= '0';
			else
				if wb_cyc_in = '1' and wb_stb_in = '1' and ack = '0' then
				    -- Write
					if wb_we_in = '1' then
						case wb_adr_in is
						    when x"000" =>
						      digit0 <= wb_dat_in(3 downto 0);
							when x"004" =>
							  digit1 <= wb_dat_in(3 downto 0);
							when x"008" =>
                              digit2 <= wb_dat_in(3 downto 0);
   							when x"00c" =>
                              digit3 <= wb_dat_in(3 downto 0);
							when others =>
						end case;
						ack <= '1';
					else
					--Read
						case wb_adr_in is
							when x"000" =>
							  wb_dat_out <= digit0;
							when x"004" =>
							  wb_dat_out <= digit1;
							when x"008" =>
							  wb_dat_out <= digit2;
							when x"00c"
							  wb_dat_out <= digit3;
							when others =>
						end case;
						ack <= '1';
					end if;
				elsif wb_stb_in = '0' then
					ack <= '0';
				end if;
			end if;
		end if;
	end process wishbone;


    ssd: process(clk)
    begin
	if(rising_edge(clk)) then
		if clk_div_cnt = (CLK_DIVISOR-1) then
			clk_div_cnt <= (others => '0');
			clk_div <= not clk_div;
		else
			clk_div_cnt <= clk_div_cnt + 1;
		end if;
	end if;
    end process ssd;


-- Update currently selected SSD display
process (clk_div)
begin
	if(rising_edge(clk_div)) then
		ssd_idx <= ssd_idx + 1;
	end if;
end process;

-- Demux digit 
with ssd_idx select
	digit <= digit0 when "00",
	         digit1 when "01",
	         digit2 when "10",
	         digit3 when "11";

-- Anode driving
with ssd_idx select
	anodes <= "1110" when "00",
	          "1101" when "01",
	          "1011" when "10",
	          "0111" when "11";

--SSD decoding
process (ssd_idx, digit)
begin
case digit is
	when "0000" => segments <="0000001";  -- '0'                              
	when "0001" => segments <="1001111";  -- '1'                              
	when "0010" => segments <="0010010";  -- '2'                              
	when "0011" => segments <="0000110";  -- '3'                              
	when "0100" => segments <="1001100";  -- '4'                              
	when "0101" => segments <="0100100";  -- '5'                              
	when "0110" => segments <="0100000";  -- '6'                              
	when "0111" => segments <="0001111";  -- '7'                              
	when "1000" => segments <="0000000";  -- '8'                              
	when "1001" => segments <="0000100";  -- '9'                              
	 --nothing is displayed when a number greater than 9 is given as input.     
	when others=> segments <="1111111";                                      
end case;
end process;

end architecture behaviour;

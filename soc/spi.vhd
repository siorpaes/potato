----------------------------------------------------------------------------------
-- Simple SPI master peripheral. Implements only CPOL = 0, CPHA = 0
-- david.siorpaes@gmail.com
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi is
    Port ( clk     : in STD_LOGIC;                        -- Clock
           reset   : in STD_LOGIC;                        -- Reset
           txdata  : in STD_LOGIC_VECTOR (7 downto 0);    -- MOSI data
           rxdata  : out STD_LOGIC_VECTOR (7 downto 0);   -- MISO data
           busy    : out STD_LOGIC;                       -- Peripheral working
           start   : in STD_LOGIC;                        -- Start SPI transaction when 1
           divisor : in STD_LOGIC_VECTOR (7 downto 0);    -- SPI clock divisor
           sclk    : out STD_LOGIC;                       -- SCLK signal
           mosi    : out STD_LOGIC;                       -- MOSI signal
           miso    : in STD_LOGIC);                       -- MISO signal
end spi;

architecture Behavioral of spi is

-- Clock divider
signal clk_div_cnt    : unsigned (31 downto 0) := (others => '0');
signal clk_div        : std_logic := '0';

-- Bit counter
signal bit_counter    : unsigned (3 downto 0) := x"0";

-- SPI is busy (data latch + data exchange)
signal spi_busy       : std_logic := '0';

-- Shifters
signal txshifter      : std_logic_vector (7 downto 0) := (others => '0');
signal rxshifter      : std_logic_vector (7 downto 0) := (others => '0');

begin

--- Clock divider for SPI clock
process(clk)
begin
	if(rising_edge(clk)) then
		if(reset = '1') then
			spi_busy <= '0';
		-- If start = '1', latch data, mark peripheral as busy and start transmission
		elsif(start = '1' and spi_busy = '0') then
			spi_busy <= '1';
			txshifter <= txdata;
			clk_div_cnt <= (others => '0');
			clk_div <= '0';
		end if;
	    
	    
		if(spi_busy = '1') then
		
		    -- Prepare first bit so it is ready when first SPI clock rising edge occurs
			if(bit_counter = 0) then
				mosi <= txshifter(0);
			end if;
		
			-- SPI clock generator
			if clk_div_cnt >= (to_integer(unsigned(divisor))-1) then
				clk_div_cnt <= (others => '0');
				clk_div <= not clk_div;        
					
				-- Transmit to MOSI and receive from MISO
				if(bit_counter < 8) then
					-- If switching from 0 to 1 sample MISO
					-- If switching from 1 to 0 emit MOSI
					if(clk_div = '0') then                        
						rxshifter(to_integer(bit_counter)) <= miso;
					else
						mosi <= txshifter(to_integer(bit_counter));
					end if;
				end if;
						
				-- Update bit counter at each SPI clock rising edge
				-- Last rising edge marks end of transmission
				if(clk_div = '0') then
					if(bit_counter = 8) then
						spi_busy <= '0';
						mosi <= '0';
						bit_counter <= x"0";
					else
						bit_counter <= bit_counter + 1;
					end if;
				end if;

			else
				clk_div_cnt <= clk_div_cnt + 1;
			end if;
		end if;
	end if;
end process;


-- Emit clock only when data is being shifted out
sclk <= clk_div and spi_busy;

busy <= spi_busy;
rxdata <= rxshifter;

end Behavioral;

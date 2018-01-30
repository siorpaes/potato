-- Wishbone wrapper for simple SPI peripheral
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief Wishbone SPI Module.
--!
--! The following registers are defined:
--! |---------|---------------------------------------------------------------|
--! | Address | Description                                                   |
--! |---------|---------------------------------------------------------------|
--! | 0x00    | TXDATA:  Data to be transmitted. Initiates tx (read/write)    |
--! | 0x04    | RXDATA:  Incoming data                        (read only)     |
--! | 0x08    | DIVISOR: SPI clock divisor                    (read/write)    |
--! | 0x0c    | BUSY:    Bit 0 indicates SPI busy             (read only)     |
--! |---------|---------------------------------------------------------------|
--!

entity pp_soc_spi_wrapper is
	port(
		clk : in std_logic;
		reset : in std_logic;

		-- SPI interface
		sclk     :  out std_logic;
		mosi     :  out std_logic;
		miso     :  in  std_logic;

		-- Wishbone interface:
		wb_adr_in  : in  std_logic_vector(11 downto 0);
		wb_dat_in  : in  std_logic_vector(31 downto 0);
		wb_dat_out : out std_logic_vector(31 downto 0);
		wb_cyc_in  : in  std_logic;
		wb_stb_in  : in  std_logic;
		wb_we_in   : in  std_logic;
		wb_ack_out : out std_logic
	);
end entity pp_soc_spi_wrapper;

architecture behaviour of pp_soc_spi_wrapper is

	signal ack : std_logic := '0';
    
    -- SPI peripheral signals
    signal  r_clk     : std_logic;                       -- Clock signal
    signal  r_reset   : std_logic;                       -- Reset signal    
    signal  r_txdata  : std_logic_vector (7 downto 0 );  -- MOSI data
    signal  r_rxdata  : std_logic_vector (7 downto 0);   -- MISO data
    signal  r_busy    : std_logic;                       -- Peripheral working
    signal  r_start   : std_logic;                       -- Start SPI transaction when 1
    signal  r_divisor : std_logic_vector (7 downto 0);   -- SPI clock divisor
    signal  r_sclk    : std_logic;                       -- SCLK signal
    signal  r_mosi    : std_logic;                       -- MOSI signal
    signal  r_miso    : std_logic;                       -- MISO signal
    
begin
	wb_ack_out <= ack and wb_cyc_in and wb_stb_in;

	wishbone: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				wb_dat_out <= (others => '0');
				ack <= '0';
			else
				if wb_cyc_in = '1' and wb_stb_in = '1' and ack = '0' then
				    -- Write
					if wb_we_in = '1' then
						case wb_adr_in is
						    when x"000" =>
						      r_txdata <= wb_dat_in(7 downto 0);
						      r_start <= '1';
							when x"008" =>
                              r_divisor <= wb_dat_in(7 downto 0);
							when others =>
						end case;
						ack <= '1';
					else
					-- Read
						case wb_adr_in is
							when x"000" =>
							  wb_dat_out <= x"000000" & r_txdata;
							when x"004" =>
							  wb_dat_out <= x"000000" & r_rxdata ;
							when x"008" =>
							  wb_dat_out <= x"000000" & r_divisor;
							when x"00c" =>
							  wb_dat_out <= "0000000000000000000000000000000" & r_busy;
							when others =>
						end case;
						ack <= '1';
					end if;
				elsif wb_stb_in = '0' then
					ack <= '0';
				end if;
			end if;
			
			-- Deassert start if transmission has started
			if (r_busy = '1') then
				r_start <= '0';
			end if;
		end if;
	end process wishbone;

	-- Instantiate SPI peripheral
	SPI: entity work.spi
	port map(
		clk => r_clk,
		reset => r_reset,
		txdata => r_txdata,
		rxdata => r_rxdata,
		busy => r_busy,
		start => r_start,
		divisor => r_divisor,
		sclk => r_sclk,
		mosi => r_mosi,
		miso => r_miso
	);

	-- Assign signals
	r_clk <= clk;
	r_reset <= reset;
	sclk <= r_sclk;
	mosi <= r_mosi;
	r_miso <= miso;
	
end architecture behaviour;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_generator is
port(
	clk         : in std_logic;
	resetn      : in std_logic;
	system_clk  : out std_logic;
	timer_clk   : out std_logic;
	locked      : out std_logic
);
end entity clock_generator;

architecture behaviour of clock_generator is
begin
	system_clk <= clk;
	timer_clk  <= clk;
	locked <= '1';
end architecture behaviour;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aee_rom is
port(
	addra : in  std_logic_vector(11 downto 0);
	douta : out std_logic_vector(31 downto 0);
	clka  : in  std_logic
);
end entity aee_rom;

architecture behaviour of aee_rom is
begin

process(clka)
begin
if rising_edge(clka) then
	--douta <= (31 downto 20 => addra(11 downto 0), others => '0');
	douta <= (others => '1');
end if;
end process;

end architecture behaviour;


library ieee;
use ieee.std_logic_1164.all;

entity tbChangeDetector is

end entity tbChangeDetector;

architecture behavior of tbChangeDetector is

component changeDetector is
port(
	CLK, DataIn: in std_logic;
	DataOut: out std_logic);
end component;

signal dI, dO, CLK: std_logic;

begin

dI <= '0', '1' after 65 ns, '0' after 95 ns;

CLK_GEN: process
begin
CLK <= '1';
wait for 10 ns;
CLK <= '0';
wait for 10 ns;
end process;

DUT: changeDetector port map (CLK => CLK, DataIn => dI, DataOut => dO);

end behavior;

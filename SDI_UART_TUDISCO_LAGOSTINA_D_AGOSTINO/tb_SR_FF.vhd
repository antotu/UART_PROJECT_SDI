library ieee;
use ieee.std_logic_1164.all;

entity tb_SR_FF is

end entity tb_SR_FF;

architecture behavioral of tb_SR_FF is

component SR_FF is
port(
	S,R,clk: in std_logic;
	Q: out std_logic);
end component;

signal clk, s, r, q: std_logic;

begin

clockGen: process
begin
	clk <= '0';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;

end process clockGen;

s <= '0', '1' after 60 ns, '0' after 80 ns;

r <= '0', '1' after 120 ns, '0' after 140 ns;

DUT: SR_FF port map (S => s, R => r, clk => clk, Q => q);

end behavioral;

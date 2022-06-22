library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RX_recognize_start is
end tb_RX_recognize_start;


architecture beh of tb_RX_recognize_start is

component RX_recognize_start is
port(
	DATA_INPUT : in STD_LOGIC_VECTOR(7 downto 0);
	START : out STD_LOGIC
);
end component;

signal DATA_INPUT : STD_LOGIC_VECTOR(7 downto 0);
signal START : STD_LOGIC;


begin

UUT: RX_recognize_start port map (
	DATA_INPUT => DATA_INPUT,
	START => START
);

GEN_SIGNAL: process
begin
for i in 0 to (2 ** 7 - 1) loop
	DATA_INPUT <= std_logic_vector(to_unsigned(i, 8));
	wait for 10 ns;
end loop;
wait;
end process;

end beh;
	
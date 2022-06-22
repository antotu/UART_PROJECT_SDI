library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RX_mux2to1 is
end tb_RX_mux2to1;


architecture beh of tb_RX_mux2to1 is
component RX_mux2to1
port (
	DATA1 : in STD_LOGIC;
	DATA2 : in STD_LOGIC;
	SEL : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end component;

signal DATA1 : STD_LOGIC;
signal DATA2 : STD_LOGIC;
signal SEL : STD_LOGIC;
signal DATA_OUT : STD_LOGIC;



begin

UUT: RX_mux2to1 port map (
	DATA1 => DATA1,
	DATA2 => DATA2,
	SEL => SEL,
	DATA_OUT => DATA_OUT
);

GEN_SIGNAL: process
variable INPUT_DATA : UNSIGNED(2 downto 0);
begin
for i in 0 to (2 ** 3 - 1) loop
INPUT_DATA := to_unsigned(i, 3);
DATA1 <= INPUT_DATA(2);
DATA2 <= INPUT_DATA(1);
SEL <= INPUT_DATA(0);
wait for 10 ns;
end loop;
wait;
end process;
end beh;

 

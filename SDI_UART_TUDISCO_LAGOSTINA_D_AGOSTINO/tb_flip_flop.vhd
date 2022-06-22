library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity tb_flip_flop is
end tb_flip_flop;

architecture beh of tb_flip_flop is

signal CLK : STD_LOGIC;
signal D_IN : STD_LOGIC;
signal D_OUT : STD_LOGIC;
signal LD : STD_LOGIC;
signal CLEAR : STD_LOGIC;

component flip_flop is
port(
	D_IN : in STD_LOGIC;
	D_OUT : out STD_LOGIC;
	CLK: in STD_LOGIC;
	CLEAR: in STD_LOGIC;
	LD: in STD_LOGIC
);
end component;

begin

DUT: flip_flop port map(
	CLK => CLK,
	D_IN => D_IN,
	D_OUT => D_OUT,
	CLEAR => CLEAR,
	LD => LD
);

CLOCK_GEN: process
begin
CLK <= '0';
wait for 10 ns;
CLK <= '1';
wait for 10 ns;
end process;


SIGNAL_GEN: process

begin

CLEAR <= '1';
D_IN <='1';
LD <= '1';
wait for 20 ns;
CLEAR <= '0';
wait for 20 ns;
D_IN <= '0';
wait for 20 ns;
D_IN <= '1';
LD <= '0';
wait;
end process;
end beh;

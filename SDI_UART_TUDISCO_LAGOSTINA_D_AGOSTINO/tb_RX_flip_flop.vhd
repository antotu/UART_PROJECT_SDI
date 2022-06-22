library ieee;
use ieee.std_logic_1164.all;

entity tb_RX_flip_flop is
end tb_RX_flip_flop;

architecture beh of tb_RX_flip_flop is
signal CLK : STD_LOGIC;
signal CLEAR : STD_LOGIC;
signal DATA_IN : STD_LOGIC;
signal DATA_OUT : STD_LOGIC;
signal LD : STD_LOGIC;


component RX_flip_flop is
port(
	DATA_IN : in STD_LOGIC;
	CLK : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	LD : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end component;

begin

UUT: RX_flip_flop port map(
	DATA_IN => DATA_IN,
	CLK => CLK,
	CLEAR => CLEAR,
	LD => LD, 
	DATA_OUT => DATA_OUT
);


CLOCK_GEN: process
begin
CLK <= '0';
wait for 10 ns;
CLK <= '1';
wait for 10 ns;
end process;

SIGNAL_GEN:process
begin
CLEAR <= '1';
DATA_IN <= '1';
LD <= '1';
wait for 20 ns;
CLEAR <= '0';
wait for 20 ns;
DATA_IN <= '0';
wait for 20 ns;
DATA_IN <= '1';
LD <= '0';
wait;
end process;
end beh;

library ieee;
use ieee.std_logic_1164.all;

entity tb_RX_counter_with_tc is
end tb_RX_counter_with_tc;


architecture beh of tb_RX_counter_with_tc is
SIGNAL CLK : STD_LOGIC;
SIGNAL EN_CNT : STD_LOGIC;
SIGNAL TC :STD_LOGIC;
SIGNAL CLEAR : STD_LOGIC;
constant N : positive := 4;
constant VALUE_MAX : positive := 11;

component RX_counter_with_tc is
generic (N: positive;
	VALUE_MAX : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC : out STD_LOGIC
);
end component;


begin


UUT: RX_counter_with_tc generic map ( N => N,
	VALUE_MAX => VALUE_MAX) port map (
	EN_CNT => EN_CNT,
	CLEAR => CLEAR,
	CLK => CLK,
	TC => TC
);

CLK_GEN : process
begin
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
end process;

SIGNAL_GEN: process
begin
	EN_CNT <= '1';
	CLEAR <= '1';
	wait for 30 ns;
	CLEAR <= '0';
	wait for 320 ns;
	EN_CNT <= '0';
	wait for 80 ns;
	EN_CNT <= '1';
	wait;
end process;
end beh;



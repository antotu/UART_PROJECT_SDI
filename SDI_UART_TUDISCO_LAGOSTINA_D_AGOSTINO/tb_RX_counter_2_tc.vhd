
library ieee;
use ieee.std_logic_1164.all;

entity tb_RX_counter_2_tc is
end tb_RX_counter_2_tc;


architecture beh of tb_RX_counter_2_tc is
SIGNAL CLK : STD_LOGIC;
SIGNAL EN_CNT : STD_LOGIC;
SIGNAL TC1 :STD_LOGIC;
SIGNAL TC2 : STD_LOGIC;
SIGNAL CLEAR : STD_LOGIC;
constant N : positive := 3;
constant VALUE_MAX1 : positive := 3;
constant VALUE_MAX2 : positive := 7;

component RX_counter_2_tc is
generic (N: positive;
	VALUE_MAX_1 : positive;
	VALUE_MAX_2 : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC1 : out STD_LOGIC;
	TC2 : out STD_LOGIC
);
end component;


begin


UUT: RX_counter_2_tc generic map ( N => N,
	VALUE_MAX_1 => VALUE_MAX1,
	VALUE_MAX_2 => VALUE_MAX2) port map (
	EN_CNT => EN_CNT,
	CLEAR => CLEAR,
	CLK => CLK,
	TC1 => TC1,
	TC2 => TC2
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


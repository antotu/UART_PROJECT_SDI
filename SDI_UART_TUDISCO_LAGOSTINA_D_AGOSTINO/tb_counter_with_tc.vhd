library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter_with_tc is
end tb_counter_with_tc;

architecture beh of tb_counter_with_tc is

constant N : positive := 3;
constant VAL_MAX :positive :=7;

component counter_with_tc is
generic (N: positive;
	VALUE_MAX : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC : out STD_LOGIC
);
end component;

signal EN_CNT : STD_LOGIC;
signal CLEAR : STD_LOGIC;
signal CLK : STD_LOGIC;
signal TC : STD_LOGIC;

begin

DUT: counter_with_tc
generic map (N=>N,
VALUE_MAX => VAL_MAX)
port map (
EN_CNT => EN_CNT,
CLEAR  => CLEAR,
CLK  => CLK,
TC  => TC
);

CLOCK_GEN: process
begin
CLK <= '0';
wait for 10 ns;
CLK <= '1';
wait for 10 ns;
end process;

GEN_SIGNAL : process
begin
	CLEAR <= '1';
	EN_CNT <= '1';
	wait for 20 ns;

	CLEAR <= '0';
	EN_CNT <= '1';
	wait for 10000 ns;

	EN_CNT <= '0';
	wait;
end process;
end beh;

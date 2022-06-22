library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter_2_tc is
end tb_counter_2_tc;

architecture beh of tb_counter_2_tc is

constant N : positive := 8;
constant VAL_MAX_1 :positive :=137;
constant VAL_MAX_2 :positive :=134;

component counter_2_tc is
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

signal EN_CNT : STD_LOGIC;
signal CLEAR : STD_LOGIC;
signal CLK : STD_LOGIC;
signal TC1 : STD_LOGIC;
signal TC2 : STD_LOGIC;

begin

DUT: counter_2_tc
generic map (N=>N,
VALUE_MAX_1 => VAL_MAX_1,
VALUE_MAX_2 => VAL_MAX_2)
port map (
EN_CNT => EN_CNT,
CLEAR  => CLEAR,
CLK  => CLK,
TC1  => TC1,
TC2 => TC2
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
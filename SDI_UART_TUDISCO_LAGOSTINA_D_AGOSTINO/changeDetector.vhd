library ieee;
use ieee.std_logic_1164.all;

entity changeDetector is
port(
	CLK, DataIn, Reset: in std_logic;
	DataOut: out std_logic);
end entity changeDetector;

architecture behavioral of changeDetector is

component FF is
port (
	data_in: in std_logic;
	CLK, reset, enable: in std_logic;
	data_out: out std_logic);
end component;

signal prevVal: std_logic;

begin

REG: FF port map(data_in => DataIn, CLK => CLK, reset => Reset, enable => '1', data_out => prevVal);

DataOut <= DataIn and (prevVal xor DataIn);
end behavioral;
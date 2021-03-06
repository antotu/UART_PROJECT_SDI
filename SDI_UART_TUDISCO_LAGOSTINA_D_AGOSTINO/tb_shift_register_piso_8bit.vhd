library ieee;
use ieee.STD_LOGIC_1164.all;

entity tb_shift_register_piso_8bit is
end tb_shift_register_piso_8bit;

architecture beh of tb_shift_register_piso_8bit is

signal CLK : STD_LOGIC;
signal P_IN : STD_LOGIC_VECTOR (7 downto 0);
signal LOAD : STD_LOGIC;
signal clear_piso : STD_LOGIC;
signal SHIFT : STD_LOGIC;
signal S_OUT : STD_LOGIC;
signal VAL_REG : STD_LOGIC_VECTOR(7 downto 0);

component shift_register_piso_8bit is
port ( 
	S_OUT : out STD_LOGIC;
	clear_piso : in std_logic;
	SHIFT : in STD_LOGIC;
	LOAD : in STD_LOGIC;
	CLK : in STD_LOGIC;
	P_IN : in STD_LOGIC_VECTOR (7 downto 0)
);
end component;

begin

 
DUT: shift_register_piso_8bit port map(
	P_IN => P_IN,
	CLK => CLK,
	LOAD => LOAD,
	SHIFT => SHIFT,
	clear_piso => clear_piso,
	S_OUT => S_OUT
--	VAL_REG => VAL_REG
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
P_IN <= "11110001";
LOAD <= '1';
SHIFT <= '0';
wait for 20 ns;
LOAD <= '0';
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '1';
wait;
end process;
end beh;


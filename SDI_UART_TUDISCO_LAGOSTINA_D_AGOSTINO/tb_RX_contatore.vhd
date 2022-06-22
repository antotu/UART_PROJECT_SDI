library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
entity tb_RX_contatore is
end tb_RX_contatore;

architecture beh of tb_RX_contatore is
constant N : positive := 4;

 component RX_contatore is
	generic (N : natural);
	port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	DOUT : buffer UNSIGNED(N-1 downto 0)
	);
end component;

signal EN_CNT : STD_LOGIC;
signal CLEAR : STD_LOGIC;
signal CLK : STD_LOGIC;
signal DOUT : UNSIGNED(N-1 downto 0);

begin

UUT: RX_contatore generic map ( N => N)
	port map(
		EN_CNT => EN_CNT,
		CLEAR => CLEAR,
		CLK => CLK,
		DOUT => DOUT
	);

CLK_GEN: process
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
	wait for 340 ns;

	EN_CNT <= '0';
	wait;
end process;

end beh;
	
	

library ieee;
use ieee.std_logic_1164.all;

entity tb_blocco_txd is
end tb_blocco_txd;

architecture beh of tb_blocco_txd is

signal P_IN : STD_LOGIC_VECTOR (7 downto 0);
signal LOAD : STD_LOGIC;
signal SHIFT : STD_LOGIC;
signal CLK : STD_LOGIC;
signal F_0 : STD_LOGIC;
signal clear_piso : std_logic;
signal F_1 : STD_LOGIC;
signal TXD : STD_LOGIC;

component blocco_txd is
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit in ingresso
	LOAD : in STD_LOGIC;	-- segnale di load
	SHIFT : in STD_LOGIC;	-- segnale di shift
	clear_piso : in std_logic;
	F_0 : in STD_LOGIC;	
	F_1 : in STD_LOGIC;

	CLK : in STD_LOGIC; 	-- segnale di clock

	TXD : out STD_LOGIC	-- uscita dello shift register
);
end component;

begin


DUT: blocco_txd port map(
	P_IN => P_IN,
	CLK => CLK,
	LOAD => LOAD,
	SHIFT => SHIFT,
	TXD => TXD,
	clear_piso => clear_piso,
	F_0 => F_0,
	F_1 => F_1
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
P_IN <= "10110100";
LOAD <= '1';
SHIFT <= '0';
F_0 <= '0';
F_1 <= '1';
wait for 20 ns;
LOAD <= '0';
SHIFT <= '0';
F_0 <= '1';
F_1 <= '0';
wait for 20 ns;
F_0 <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
SHIFT <= '1';
wait for 20 ns;
SHIFT <= '0';
wait for 20 ns;
F_1 <= '1';
wait;
end process;


end beh;

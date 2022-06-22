library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_tx_dp_cu is
end tb_tx_dp_cu;

architecture beh of tb_tx_dp_cu is

signal P_IN : STD_LOGIC_VECTOR (7 downto 0);
signal CLK : STD_LOGIC;
signal TXD : STD_LOGIC;
signal ENABLE : STD_LOGIC;
signal START : STD_LOGIC;
signal DONE : STD_LOGIC;

component tx_dp_cu is
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit ingresso
	START:  in std_logic;				--segnale dalla CU da ricevere per avviare una nuova trasmissione
	ENABLE: in std_logic;				--abilitazione del blocco tx
	CLK: in std_logic;				--segnale di clock

	TXD: out std_logic; 				--segnale trasmesso in uscita
	DONE: out std_logic				--senale da mandare a fine trasmissione di un frame

);
end component;

begin

DUT: tx_dp_cu port map(
	P_IN => P_IN,
	CLK => CLK,
	START => START,
	DONE => DONE,
	TXD => TXD,
	ENABLE => ENABLE
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
ENABLE <= '0';
P_IN <= "01110001", "00011101" after 275000 ns;
wait for 20 ns;
ENABLE <='1';
wait for 60 ns;
START <= '1';
--wait for 200000 ns;
--ENABLE <= '0';
wait;
end process;

end beh;

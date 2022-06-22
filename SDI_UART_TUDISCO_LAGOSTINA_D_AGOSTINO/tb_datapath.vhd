library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_datapath is
end tb_datapath;

architecture beh of tb_datapath is

signal P_IN : STD_LOGIC_VECTOR (7 downto 0);
signal CLK : STD_LOGIC;
signal TXD : STD_LOGIC;
signal ENABLE : STD_LOGIC;
signal START : STD_LOGIC;
signal DONE : STD_LOGIC;

component datapath is
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

DUT: datapath port map(
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
P_IN <= "11110001";
wait for 20 ns;
ENABLE <='1';
wait for 200 ns;
START <= '1';
wait;
end process;

end beh;

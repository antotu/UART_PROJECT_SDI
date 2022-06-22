library ieee;
use ieee.std_logic_1164.all;


entity tb_rx_unit is
end tb_rx_unit;


architecture beh of tb_rx_unit is

component rx_unit is
port ( 
	RXD : in std_logic;
	CLK : IN STD_LOGIC;
	EN_RX : IN STD_LOGIC;
	DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	ERROR : OUT STD_LOGIC;
	BUSY : OUT STD_LOGIC;
	DONE : OUT STD_LOGIC
);
END component;

signal RXD : std_logic;
signal CLK : STD_LOGIC;
signal EN_RX : STD_LOGIC;
signal DATA_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ERROR : STD_LOGIC;
signal BUSY : STD_LOGIC;
signal DONE : STD_LOGIC;

begin

UUT: rx_unit port map( 
	RXD => RXD,
	CLK => CLK,
	EN_RX => EN_RX,
	DATA_OUT => DATA_OUT,
	ERROR => ERROR,
	BUSY => BUSY,
	DONE => DONE
);

CLK_GEN: process
begin
CLK <= '1';
wait for 10 ns;
CLK <= '0';
wait for 10 ns;
end process;


SIGNAL_GEN: process
begin
EN_RX <= '0';
RXD <= '0';
wait for 30 ns;
EN_RX <= '1';
wait for 1360 ns;
RXD <= '1';
wait for 2720 ns;
RXD <= '0';
wait for 2720 ns;
RXD <= '1';
wait;
end process;


end beh;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  tx_dp_cu is
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit ingresso
	START:  in std_logic;				--segnale dalla CU da ricevere per avviare una nuova trasmissione
	ENABLE: in std_logic;				--abilitazione del blocco tx
	CLK: in std_logic;				--segnale di clock

	TXD: out std_logic; 				--segnale trasmesso in uscita
	DONE: out std_logic				--senale da mandare a fine trasmissione di un frame

);

end tx_dp_cu;

architecture beh of tx_dp_cu is

component blocco_txd is
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit in ingresso
	LOAD : in STD_LOGIC;	-- segnale di load
	SHIFT : in STD_LOGIC;	-- segnale di shift
	clear_piso : in STD_LOGIC;
	F_0 : in STD_LOGIC;	
	F_1 : in STD_LOGIC;

	CLK : in STD_LOGIC; 	-- segnale di clock

	TXD : out STD_LOGIC	-- uscita dello shift register
);
end component;

component SR_FF is
port(
	S,R,clk: in std_logic;
	Q: out std_logic);
end component;

--component flip_flop is
--port(
--	D_IN : in STD_LOGIC; 		--inglesso del ff
--	D_OUT : out STD_LOGIC;		--uscita del ff
--	CLK: in STD_LOGIC;		--clock
--	CLEAR: in STD_LOGIC;		--segnale di clear del registro
--	LD: in STD_LOGIC		--segnale di load (abilita la scrittura nel registro)
--);
--end component;

component counter_2_tc is
generic (N: positive;			--numero di bit del contatore (8)
	VALUE_MAX_1 : positive;		--primo valore d'uscita (137)
	VALUE_MAX_2 : positive);	--secondo valore di uscita (134)
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC1 : out STD_LOGIC;		--terminal count uno
	TC2 : out STD_LOGIC		-- terminal count due
);
end component;

component counter_with_tc is
generic (N: positive;			--numero di bit del contatore (8)
	VALUE_MAX : positive);		--valore di uscita (0...7 ==> D_6)
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC : out STD_LOGIC
);end component;


	signal LOAD, SHIFT, clear_piso, F_0, F_1, CLR_TICK, EN_TICK, CLR_TOT, EN_TOT, LD_REG, CLR_REG, TC_137, TC_134, D_6: std_logic;
	
	type stateType is (TX_RESET, TX_IDLE, TX_START, TX_ZERO, TX_START_BIT, TX_D0, TX_SHIFT_UP, TX_SHIFT_DOWN, TX_D7, TX_STOP, TX_SR_LOAD, TX_DONE); 
	signal currentState: stateType;
begin

blocco_tx: blocco_txd port map(
CLK=>CLK,
clear_piso => clear_piso,
P_IN =>P_IN,
LOAD => LOAD,
SHIFT =>SHIFT,
F_0 => F_0,
F_1 => F_1,
TXD => TXD
);

FF: SR_FF port map(
S => LD_REG,
Q =>DONE,
CLK =>CLK,
R => CLR_REG
);

--FF: flip_flop port map(
--D_IN => '1',
--D_OUT =>DONE, 
--LD => LD_REG,
--CLK =>CLK,
--CLEAR => CLR_REG
--);

COUNTER2TC: counter_2_tc generic map(
N => 8,
VALUE_MAX_1 =>137,
VALUE_MAX_2 => 134
)
port map(
EN_CNT =>EN_TICK,
CLEAR => CLR_TICK,
CLK => CLK,
TC1 => TC_137,
TC2 => TC_134
);


COUNTER1TC: counter_with_tc generic map(
N => 4,
VALUE_MAX => 8
)
port map(
EN_CNT => EN_TOT,
CLEAR => CLR_TOT,
CLK=> CLK,
TC => D_6
);

--end beh;



----------------------------------------------------------------------------------

--CU

--processo che regola l'evoluzione degli stati

trans: process (CLK) 
begin
if (CLK'event and CLK ='1') then
	if (ENABLE ='0') then
		currentState <= TX_RESET;
	else
		case currentState is
			when TX_RESET =>
				currentState <= TX_IDLE;
			when TX_IDLE =>
				if START = '1' then
				currentState <= TX_START;
				else
				currentState <= TX_IDLE;
				end if;
			when TX_START =>
				currentState <= TX_ZERO;
			when TX_ZERO =>
				if TC_137 = '1' then
				currentState <= TX_START_BIT;
				else
				currentState <= TX_ZERO;
				end if;
			when TX_START_BIT =>
				currentState <= TX_D0;
			when TX_D0 =>
				if TC_137 ='1' then
				currentState <= TX_SHIFT_UP;
				else
				currentState <= TX_D0;
				end if;
			when TX_SHIFT_UP =>
				currentState <= TX_SHIFT_DOWN;
			when TX_SHIFT_DOWN =>
				if TC_137 = '1' then
					if D_6 = '1' then
					currentState <= TX_D7;
					else
					currentState <= TX_SHIFT_UP;
					end if;
				else 
				currentState <= TX_SHIFT_DOWN;
				end if;
			when TX_D7 =>
				currentState <= TX_STOP;
			when TX_STOP =>
				if TC_134 ='1' then
				currentState <= TX_SR_LOAD;
				else
				currentState <= TX_STOP;
				end if;
			when TX_SR_LOAD =>
				currentState <= TX_DONE;
			when TX_DONE =>
				currentState <= TX_IDLE;
			when others => 
				currentState <= TX_IDLE;
		end case;
	end if;
end if;


end process trans;



---comandi di ogni stato


commands: process(currentState)
begin

LOAD <= '0'; SHIFT <= '0'; clear_piso <= '0'; F_0 <= '0'; F_1 <= '0'; EN_TICK <= '0'; CLR_TICK <= '0'; EN_TOT <= '0'; CLR_TOT <='0'; LD_REG <='0'; CLR_REG<='0'; 

case currentState is
	when TX_RESET =>
			CLR_TICK <='1';
			CLR_TOT <= '1';
			CLR_REG <= '1';
			F_1 <= '1';
			clear_piso <= '1';
	--		DONE <= '1';
	--		LD_REG <='1';
	when TX_IDLE =>
			LOAD <= '1';
			F_1 <= '1';
	--		DONE <= '1';
			LD_REG <='1';
	when TX_START =>
			CLR_REG <='1';
			LOAD <='0';
			F_1 <='1';
	when TX_ZERO =>
			F_0 <='1';
			F_1 <='0';
			EN_TICK <= '1';
	--		DONE <='0';
			CLR_REG <='0';
	when TX_START_BIT =>
			EN_TICK <='0';
			CLR_TICK <='1';
			EN_TOT <='1';
	when TX_D0 =>
			F_0 <='0';
			CLR_TICK <='0';
			EN_TOT <= '0';
			EN_TICK <='1';
	when TX_SHIFT_UP =>
			SHIFT <='1';
			EN_TICK <='0';
			CLR_TICK <='1';
			EN_TOT <='1';
	when TX_SHIFT_DOWN =>
			SHIFT <='0';
			EN_TICK <='1';
			CLR_TICK <='0';
			EN_TOT <='0';
	when TX_D7 =>
			EN_TICK <='0';
			CLR_TICK <='1';
			CLR_TOT <='1';
	when TX_STOP =>
			F_1 <='1';
			EN_TICK <='1';
			CLR_TICK <='0';
			CLR_TOT <= '0';
	when TX_SR_LOAD =>
			EN_TICK <='0';
			CLR_TICK <='1';
			LD_REG <='1';
			F_1 <='1';
	when TX_DONE =>
			CLR_TICK <='0';
			F_1 <='1';
	--		DONE <='1';
	--		LD_REG <='0';
	
end case;

end process commands;


end beh;


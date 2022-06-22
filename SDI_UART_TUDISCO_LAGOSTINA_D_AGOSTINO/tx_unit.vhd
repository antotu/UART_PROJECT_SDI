library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  tx_unit is
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit ingresso
	START:  in std_logic;				--segnale dalla CU da ricevere per avviare una nuova trasmissione
	ENABLE: in std_logic;				--abilitazione del blocco tx
	CLK: in std_logic;				--segnale di clock

	TXD: out std_logic; 				--segnale trasmesso in uscita
	DONE: out std_logic				--senale da mandare a fine trasmissione di un frame

);

end tx_unit;

architecture beh of tx_unit is

component blocco_txd is
port (

	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit in ingresso
	LOAD : in STD_LOGIC;				-- segnale di load
	SHIFT : in STD_LOGIC;				-- segnale di shift
	F_0 : in STD_LOGIC;	--segnale per imporre 0 in uscita (bit di start)
	F_1 : in STD_LOGIC;	--segnale per imporre 1 in uscita (bit di stop)

	CLK : in STD_LOGIC; 	-- segnale di clock

	TXD : out STD_LOGIC	-- uscita dello shift register
);
end component;

component flip_flop is
port(
	D_IN : in STD_LOGIC; 		--inglesso del ff
	D_OUT : out STD_LOGIC;		--uscita del ff
	CLK: in STD_LOGIC;		--clock
	CLEAR: in STD_LOGIC;		--segnale di clear del registro
	LD: in STD_LOGIC		--segnale di load (abilita la scrittura nel registro)
);
end component;

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


	signal LOAD, SHIFT, F_0, F_1, CLR_TICK, EN_TICK, CLR_TOT, EN_TOT, LD_REG, CLR_REG, TC_137, TC_134, D_6: std_logic;
	
	type stateType is (TX_RESET, TX_IDLE, TX_START, STATE1, STATE2, STATE3, STATE4, STATE5, STATE6, STATE7, STATE8, STATE9); 
	signal currentState: stateType;
begin

blocco_tx: blocco_txd port map(
CLK=>CLK,
P_IN =>P_IN,
LOAD => LOAD,
SHIFT =>SHIFT,
F_0 => F_0,
F_1 => F_1,
TXD => TXD
);

FF: flip_flop port map(
D_IN => '1',
D_OUT =>DONE,
LD => LD_REG,
CLK =>CLK,
CLEAR => CLR_REG
);

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
				currentState <= STATE1;
			when STATE1 =>
				if TC_137 = '1' then
				currentState <= STATE2;
				else
				currentState <= STATE1;
				end if;
			when STATE2 =>
				currentState <= STATE3;
			when STATE3 =>
				if TC_137 ='1' then
				currentState <= STATE4;
				else
				currentState <= STATE3;
				end if;
			when STATE4 =>
				currentState <= STATE5;
			when STATE5 =>
				if TC_137 = '1' then
					if D_6 = '1' then
					currentState <= STATE6;
					else
					currentState <= STATE4;
					end if;
				else 
				currentState <= STATE5;
				end if;
			when STATE6 =>
				currentState <= STATE7;
			when STATE7 =>
				if TC_134 ='1' then
				currentState <= STATE8;
				else
				currentState <= STATE7;
				end if;
			when STATE8 =>
				currentState <= STATE9;
			when STATE9 =>
				currentState <= TX_IDLE;
			--when STATE10 =>
				--if START ='1' then
				--currentState <= TX_START;
				--else
				--currentState <=STATE10;
				--end if;

			when others => 
				currentState <= TX_IDLE;
		end case;
	end if;
end if;


end process trans;



---comandi di ogni stato


commands: process(currentState)
begin

LOAD <= '0'; SHIFT <= '0'; F_0 <= '0'; F_1 <= '0'; EN_TICK <= '0'; CLR_TICK <= '0'; EN_TOT <= '0'; CLR_TOT <='0'; LD_REG <='0'; CLR_REG<='0'; 

case currentState is
	when TX_RESET =>
			CLR_TICK <='1';
			CLR_TOT <= '1';
			CLR_REG <= '1';
			F_1 <= '1';
			--DONE <= '1';
			LD_REG <= '1';
	when TX_IDLE =>
			LOAD <= '1';
			F_1 <= '1';
			--DONE <= '1';
			LD_REG <= '1';
	when TX_START =>
			CLR_REG <='1';
			LOAD <='0';
	when STATE1 =>
			F_0 <='1';
			F_1 <='0';
			EN_TICK <= '1';
			--DONE <='0';
			CLR_REG <='0';
	when STATE2 =>
			EN_TICK <='0';
			CLR_TICK <='1';
			EN_TOT <='1';
	when STATE3 =>
			F_0 <='0';
			CLR_TICK <='0';
			EN_TOT <= '0';
			EN_TICK <='1';
	when STATE4 =>
			SHIFT <='1';
			EN_TICK <='0';
			CLR_TICK <='1';
			EN_TOT <='1';
	when STATE5 =>
			SHIFT <='0';
			EN_TICK <='1';
			CLR_TICK <='0';
			EN_TOT <='0';
	when STATE6 =>
			EN_TICK <='0';
			CLR_TICK <='1';
			CLR_TOT <='1';
	when STATE7 =>
			F_1 <='1';
			EN_TICK <='1';
			CLR_TICK <='0';
			CLR_TOT <= '0';
	when STATE8 =>
			EN_TICK <='0';
			CLR_TICK <='1';
			LD_REG <='1';
	when STATE9 =>
			CLR_TICK <='0';
			--DONE <='1';
			--LD_REG <='0';
	--when STATE10 =>
			--LOAD <='1';
end case;

end process commands;


end beh;


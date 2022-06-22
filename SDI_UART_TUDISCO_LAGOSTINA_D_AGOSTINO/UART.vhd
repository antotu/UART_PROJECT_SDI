library ieee;
use ieee.std_logic_1164.all;

entity UART is
  port(
    RESETn, RxD, ATNACK, R_Wn, CS, clock: in std_logic;
    TxD, ATN: out std_logic;
    DIN: in std_logic_vector(7 downto 0);
    DOUT: out std_logic_vector (7 downto 0);
    ADD: in std_logic_vector(2 downto 0));
end entity UART;


architecture behavior of UART is
  
  component tx_dp_cu is
    port (
	   P_IN : in STD_LOGIC_VECTOR (7 downto 0);	 
	   START:  in std_logic;				  
	   ENABLE: in std_logic;				  
	   CLK: in std_logic;	  

	   TXD: out std_logic; 
	   DONE: out std_logic
  );
  end component;
  
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
  end component;
  
  component BusInterface is
    port(
      resetn: in std_logic;
      --segnali scambiati con l'esterno della UART
      CLK: in std_logic;
      CS: in std_logic;
      A: in std_logic_vector(2 downto 0);
      DIN: in std_logic_vector(7 downto 0);
      DOUT: out std_logic_vector(7 downto 0);
      R_Wn, ATNACK: in std_logic;
      ATN: out std_logic;
      --segnali scambiati con RX e TX
      PRX: in std_logic_vector(7 downto 0);             
      RX_DONE, RX_BUSY, RX_ERR, TX_DONE: in std_logic;  
      PTX: out std_logic_vector(7 downto 0);            
      TX_EN, RX_EN, START_TX: out std_logic);
  end component;
  
  signal TX_EN, RX_EN, START_TX, RX_DONE, RX_BUSY, RX_ERR, TX_DONE: std_logic;
  signal PRX, PTX: std_logic_vector(7 downto 0);
  
begin
  
  TX: tx_dp_cu port map (P_IN => PTX, 
                        START => START_TX, 
                        ENABLE => TX_EN, 
                        CLK => clock, 
                        TXD => TxD, 
                        DONE => TX_DONE);
  
  RX: rx_unit port map (RXD => RxD,
                        CLK => clock,
                        EN_RX => RX_EN,
                        DATA_OUT => PRX,
                        ERROR => RX_ERR,
                        BUSY => RX_BUSY,
                        DONE => RX_DONE);
                        
  BI: BusInterface port map(resetn => RESETn,
                            CLK => clock,
                            CS => CS,
                            A => ADD,
                            DIN => DIN,
                            DOUT => DOUT,
                            R_Wn => R_Wn,
                            ATNACK => ATNACK,
                            ATN => ATN,
                            PRX => PRX,
                            RX_DONE => RX_DONE,
                            RX_BUSY => RX_BUSY,
                            RX_ERR => RX_ERR,
                            TX_DONE => TX_DONE,
                            PTX => PTX,
                            TX_EN => TX_EN,
                            RX_EN => RX_EN,
                            START_TX => START_TX);
                        
  
  
end behavior;

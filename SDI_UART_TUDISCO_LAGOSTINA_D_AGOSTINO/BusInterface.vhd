library ieee;
use ieee.std_logic_1164.all;

entity BusInterface is
  
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
    PRX: in std_logic_vector(7 downto 0);             --dato ottenuto da RX
    RX_DONE, RX_BUSY, RX_ERR, TX_DONE: in std_logic;  --segnali di stato
    PTX: out std_logic_vector(7 downto 0);            --dato da inviare tramite TX
    TX_EN, RX_EN, START_TX: out std_logic);
end entity BusInterface;

architecture behavioral of BusInterface is
  
  component gen_mux_2_1 is
    generic(n: positive); 
    port(xs,ys: in std_logic_vector(n-1 downto 0);  
      sl: in std_logic;   
      ms: out std_logic_vector(n-1 downto 0));  
  end component;
  
  component n_bit_register is
    generic (n_bit: integer);
	  port (data_in: in std_logic_vector(n_bit - 1 downto 0);
		  CLK, reset, enable: in std_logic;
		  data_out: out std_logic_vector(n_bit - 1 downto 0));
  end component;
  
  component FF is
    port (data_in: in std_logic;
		  CLK, reset, enable: in std_logic;
		  data_out: out std_logic);
	end component;
  
  component Dec3to8 is
    port(
    in_data: in std_logic_vector(2 downto 0);
    out_data: out std_logic_vector(7 downto 0));
  end component;

  component changeDetector is
	port(
	CLK, DataIn, Reset: in std_logic;
	DataOut: out std_logic);
  end component;

  component SR_FF is
  port(
	S,R,clk: in std_logic;
	Q: out std_logic);
  end component;
 
signal OUT_MUX, ATN_STATE, ATN_RX, RST_ATN_RX, ATN_TX, RST_ATN_TX, SET_ATN, RST_ATN, RST_CLR_ATN, ATN_CLR, RX_FULL, LD_CTRL, RST_CTRL, CLR_ATN, RST_B_C: std_logic;

signal CTRL_BUFF: std_logic_vector(2 downto 0);
signal CTRL_2_BIT: std_logic_vector(1 downto 0);
signal ADD_8_BIT, STAT_8_BIT: std_logic_vector(7 downto 0);
 
type stateType is (ResetState, ReadStatus, ReadRX, NOPState, WriteCTRL, SendATNRX, SendATNTX, RemoveATN, idle);
signal currentState: stateType;
 
begin
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--datapath


--selezione del registro da leggere

RX_FULL <= RX_DONE and (not RX_BUSY);-- and (not RX_ERR);
STAT_8_BIT <= "00000" & RX_ERR & TX_DONE & RX_FULL;

MUX: gen_mux_2_1 generic map (n => 8)
                 port map(xs => PRX, ys => STAT_8_BIT, sl => OUT_MUX, ms => DOUT);

--attivazione ATN


RX_DET: changeDetector port map (CLK => CLK, DataIn => RX_FULL, Reset => RST_ATN_RX, DataOut => ATN_RX);
TX_DET: changeDetector port map (CLK => CLK, DataIn => TX_DONE, Reset => RST_ATN_TX, DataOut => ATN_TX);

RST_ATN <= not(ATN_CLR);

ATN_REG: SR_FF port map (S => SET_ATN, R => RST_ATN, clk => CLK, Q => ATN);

--ATN_REG: FF port map (data_in => '1', CLK => CLK, reset => RST_ATN, enable => LD_ATN, data_out => ATN_STATE);
--ATN <= ATN_STATE;
--scrittura nel registro di controllo ed invio a TX

BUFFER_CTRL: n_bit_register generic map (n_bit => 3)
                        port map (data_in => DIN(2 downto 0), CLK => CLK, reset => RST_B_C, enable => '1', data_out => CTRL_BUFF);

CTRL_REG_2: n_bit_register generic map (n_bit => 2)
                        port map (data_in => CTRL_BUFF(1 downto 0), CLK => CLK, reset => RST_CTRL , enable => LD_CTRL, data_out => CTRL_2_BIT);

CLR_ATN_FF: FF port map(data_in => CTRL_BUFF(2), CLK => CLK, reset => RST_CLR_ATN, enable => LD_CTRL, data_out => CLR_ATN);

TX_EN <= CTRL_2_BIT(1);
RX_EN <= CTRL_2_BIT(0);

PTX <= DIN;

--realizzazione del segnale di start del TX

DEC: Dec3to8 port map (in_data => A, out_data => ADD_8_BIT);

START_TX <= ADD_8_BIT(0) and (not (R_Wn)) and CS;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--control unit

--transiozioni degli stati

transitions: process(CLK)
begin
    
if CLK'event and CLK = '1' then
    
  if resetn = '0' then
      
    currentState <= resetState;
    
  else
    
    if currentState = NOPState then
        
      currentState <= WriteCTRL;
        
    else 
        
      if CS = '1' then
          
        if R_Wn = '1' then
            
          if ADD_8_BIT(2) = '1' then
              
            currentState <= ReadStatus;
              
          elsif ADD_8_BIT(2) = '0' then
            
            if ADD_8_BIT(1) = '1' then
              
              currentState <=  ReadRX;
            
            else 
              
              currentState <= idle;
            
            end if;
            
          else
          
            currentState <= idle;
           
          end if;
        
        elsif R_Wn = '0' then
          
          if ADD_8_BIT(3) = '1' then
            
            currentState <= NOPState;
          
          else 
            
            currentState <= idle;
          
          end if;
          
        end if;
          
      elsif CS = '0' then
        
          if ATN_RX = '1' then
          
            currentState <= SendATNRX;
          
	  elsif ATN_TX = '1' then

	    currentState <= SendATNTX;
  
          elsif ATN_STATE = '1' then
          
            if ATNACK = '1' or CLR_ATN = '1' then
            
              CurrentState <= RemoveATN;
              
            else 
              
              CurrentState <= idle;
              
            end if;
            
          else 
            
            CurrentState <= idle;
            
          end if;
          
      else 
        
        currentState <= idle;
          
      end if;
           
    end if;
  end if;
end if;
end process transitions;  


--comandi associati agli stati

commands: process(currentState)
begin
  
  ATN_CLR <= '0'; RST_B_C <= '1'; RST_CTRL <= '1'; OUT_MUX <= '0'; LD_CTRL <= '0'; SET_ATN <= '0'; RST_CLR_ATN <= '1';
  RST_ATN_RX <= '1'; RST_ATN_TX <= '1';
  case currentState is 
                when resetState => 
                                  ATN_CLR <= '1';
                                  RST_B_C <= '0';
                                  RST_CTRL <= '0';
				  RST_ATN_RX <= '0';
				  RST_ATN_TX <= '0';
                when ReadSTATUS => 
                                  OUT_MUX <= '1';
                when ReadRX => 
                                  OUT_MUX <= '0';   
                when WriteCTRL => 
                                  LD_CTRL  <= '1';
                when SendATNRX => 
                                  SET_ATN <= '1';
                when SendATNTX => 
                                  SET_ATN <= '1';
  
                when RemoveATN =>
                                  ATN_CLR <= '1';
                                  RST_CLR_ATN <= '0';
                                  
                when NOPState =>
                when idle => 
  end case;
  
end process commands;





end behavioral;
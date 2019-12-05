library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Sawtooth_Gen is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
			  switch : in STD_LOGIC;
			  switch2 : in STD_LOGIC;
			  switch3 : in STD_LOGIC;
			  buttona : in STD_LOGIC;
			  buttonb : in STD_LOGIC;
           PWM_OUT : out STD_LOGIC
          );
end Sawtooth_Gen;

architecture Behavioral of Sawtooth_Gen is

	signal duty_cycle_i1, duty_cycle_i2, duty_cycle_i3, duty_cycle_out, duty_cycle_final : STD_LOGIC_VECTOR(8 downto 0);
	signal index_i : STD_LOGIC_VECTOR(8 downto 0);
	signal slow_clk, slow_clk2 : STD_LOGIC;
	signal switcher, switcher2, switcher3 : STD_LOGIC;
	signal button_a_deb : STD_LOGIC;
	signal button_b_deb : STD_LOGIC;
	signal button_a : STD_LOGIC;
	signal button_b : STD_LOGIC;
	signal divisor_i, divisor_i2 : natural;
	signal button_a_f : STD_LOGIC;
	signal button_b_f : STD_LOGIC;
	signal button_a_A : STD_LOGIC;
	signal button_b_A : STD_LOGIC;
	signal Square_Max : STD_LOGIC_VECTOr(8 downto 0);
 
    component PWM_DAC is
        Generic ( width : integer := 9);
        Port (    reset : in STD_LOGIC;
                  clk : in STD_LOGIC;
                  duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                  pwm_out : out STD_LOGIC
              );
     end component;
	
	  Component Up_Counter is
			Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           EN :  in STD_LOGIC;
           index_out : out STD_LOGIC_VECTOR(8 downto 0)
          );
		end Component;
		
		Component downcounter is      
			PORT ( clk    : in  STD_LOGIC; -- clock to be divided
				reset  : in  STD_LOGIC; -- active-high reset
				enable : in  STD_LOGIC; -- active-high enable
				period : in natural;
				zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
         );
		end Component;
		
		COMPONENT Sawtooth_Lookup IS
			PORT(
				clk            :  IN    STD_LOGIC;                                
				reset          :  IN    STD_LOGIC;                                
				index      		:  IN    STD_LOGIC_VECTOR(8 DOWNTO 0);                           
				duty_cycle     :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
				);
		END COMPONENT;
		
		COMPONENT Triangle_Lookup IS
			PORT(
				clk            :  IN    STD_LOGIC;                                
				reset          :  IN    STD_LOGIC;                                
				index      	 	:  IN    STD_LOGIC_VECTOR(8 DOWNTO 0);                           
				duty_cycle     :  OUT   STD_LOGIC_VECTOR(8 DOWNTO 0)
				);
		END COMPONENT;
		
		COMPONENT MUX2TO1_9 is
			Port ( W0 : in  STD_LOGIC_VECTOR(8 downto 0);
					W1 : in  STD_LOGIC_VECTOR(8 downto 0);
					S  : in  STD_LOGIC;
					F  : out STD_LOGIC_VECTOR(8 downto 0)
          );
		end COMPONENT;
		
		COMPONENT Frequency_Select is
			Port ( reset : in STD_LOGIC;
					clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
					button_a : in STD_LOGIC;
					button_b : in STD_LOGIC;
					divisor : out natural
          );
		end COMPONENT;
		
		COMPONENT Frequency_SS is
			Port ( reset : in STD_LOGIC;
					clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
					button_a : in STD_LOGIC;
					button_b : in STD_LOGIC;
					divisor : out natural
			);
		end COMPONENT;
		
		COMPONENT Debouncer1 is
			Port (D_IN : in std_logic;
					S1, SP : out std_logic;
					clk, reset : in std_logic
			);
		end COMPONENT;
		
		COMPONENT Alternator is
			Port ( reset : in STD_LOGIC;
					clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
					EN :  in STD_LOGIC;
					Max : in STD_LOGIC_VECTOR(8 downto 0);
					Duty_Cycle_out : out STD_LOGIC_VECTOR(8 downto 0)
					);
		end COMPONENT;
		
		COMPONENT Blocker is
		Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           EN :  in STD_LOGIC;
			  Input1 : in STD_LOGIC;
			  Input2 : in STD_LOGIC;
           Output1 : out STD_LOGIC;
			  Output2 : out STD_LOGIC
          );
		end COMPONENT;
	
		COMPONENT Amplitude_Select is
		Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           button_a : in STD_LOGIC;
			  button_b : in STD_LOGIC;
           Max_out : out STD_LOGIC_VECTOR(8 downto 0)
          );
		end COMPONENT;
		
		
BEGIN
	switcher <= switch;
	switcher2 <= switch2;
	switcher3 <= NOT switch3;
	button_a <= buttona;
	button_b <= buttonb;


Freq_Blocker : Blocker
	port map( reset => reset, clk => clk, EN => switcher3, Input1 => button_a_deb, Input2 => button_b_deb,
					Output1 => button_a_f, Output2 => button_b_f); 
Amp_Blocker : Blocker
	port map( reset => reset, clk => clk, EN => switch3, Input1 => button_a_deb, Input2 => button_b_deb,
					Output1 => button_a_A, Output2 => button_b_A); 
	
Amp_Select : Amplitude_Select
	port map( clk => clk, reset=> reset, button_a => button_a_A, button_b => button_b_A, Max_out => Square_Max);  
					
modulator: PWM_DAC
	generic map(width => 9)
	port map(reset => reset, clk => clk, duty_cycle => duty_cycle_final, pwm_out => PWM_OUT);
	
Countup: Up_Counter
	port map(reset => reset, clk => clk, EN => slow_clk, index_out => index_i);
	
Countdwn: downcounter
	port map(clk => clk, reset => reset, enable => '1', period => divisor_i, zero => slow_clk);

SqrCountdwn: downcounter
	port map(clk => clk, reset => reset, enable => '1', period => divisor_i2, zero => slow_clk2);
	
Table: Sawtooth_Lookup
	port map(clk => clk, reset => reset, index => index_i, duty_cycle => duty_cycle_i1);

Table2: Triangle_Lookup
	port map(clk => clk, reset => reset, index => index_i, duty_cycle => duty_cycle_i2);
	
Mux9: MUX2TO1_9
	port map(W0 => duty_cycle_i1, W1 => duty_cycle_i2, S => switch, F => duty_cycle_out);
	
Mux9b: MUX2TO1_9
	port map(W0 => duty_cycle_out, W1 => duty_cycle_i3, S => switch2, F => duty_cycle_final);
	
Freqer: Frequency_Select
	port map(reset => reset, clk => clk, button_a => button_a_f, button_b => button_b_f, divisor => divisor_i);
	
Freqersqr: Frequency_SS
	port map(reset => reset, clk => clk, button_a => button_a_f, button_b => button_b_f, divisor => divisor_i2);
	
Debounce1: Debouncer1
	port map(D_IN => button_a, SP => button_a_deb, clk => clk, reset => reset);
	
Debounce2: Debouncer1
	port map(D_IN => button_b, SP => button_b_deb, clk => clk, reset => reset);
	
Alter: Alternator
	port map(reset => reset, clk => clk, EN => slow_clk2, Max => Square_Max, Duty_Cycle_out => duty_cycle_i3);
	
END Behavioral;
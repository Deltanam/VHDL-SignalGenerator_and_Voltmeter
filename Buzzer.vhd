library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Buzzer is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
			  switch : in STD_LOGIC;
			  PWM_OUT2 : out STD_LOGIC;
			  LEDR : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
end Buzzer;

architecture Behavioral of Buzzer is

	SIGNAL duty_cycle_i3, amplitude_i : STD_LOGIC_VECTOR(11 downto 0);
	SIGNAL slow_clk2 : STD_LOGIC;
	SIGNAL divisor_i2 : natural;
	SIGNAL index_i, index_amp, index_freq : integer;
	SIGNAL switcher : STD_LOGIC;

	Component Voltmeter is
			Port ( clk                          : in  STD_LOGIC;
					reset                         : in  STD_LOGIC;
					LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
					HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
					distance							  : out STD_LOGIC_VECTOR (12 downto 0);
					index								  : out integer
					);
           
	end Component;
	
   component PWM_DAC is
        Generic ( width : integer := 9);
        Port (    reset : in STD_LOGIC;
                  clk : in STD_LOGIC;
                  duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                  pwm_out : out STD_LOGIC
              );
   end component;
	
	COMPONENT Alternator_12 is
			Port ( reset : in STD_LOGIC;
					clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
					EN :  in STD_LOGIC;
					Max : in STD_LOGIC_VECTOR(11 downto 0);
					Duty_Cycle_out : out STD_LOGIC_VECTOR(11 downto 0)
					);
	end COMPONENT;

	Component downcounter is      
			PORT ( clk    : in  STD_LOGIC; -- clock to be divided
					reset  : in  STD_LOGIC; -- active-high reset
					enable : in  STD_LOGIC; -- active-high enable
					period : in natural;
					zero   : out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
					);
	end Component;
	
	Component BuzzFreq_Lookup IS
			PORT	( clk       :  IN    STD_LOGIC;                                
					reset       :  IN    STD_LOGIC;                                
					index      	:  IN    integer;                           
					Divisor     :  OUT   natural
					);
	END Component;
	
	Component BuzzAmp_Lookup IS
   PORT(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      index      	 	:  IN    integer;                           
      Amplitude      :  OUT   STD_LOGIC_VECTOR(11 DOWNTO 0)
		);
	END Component;
	
	Component RegisterInt is
	port (SI: in integer;
			Q: out integer;
			clk, EN, reset: in std_logic);
	END Component;
	
	
BEGIN
	switcher <= NOT switch;	

Voltron: Voltmeter
	port map(clk => clk, reset => reset, LEDR => LEDR,
				 HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5,
				 index => index_i
				 );
				 
Alter: Alternator_12
	port map(reset => reset, clk => clk, EN => slow_clk2, Max => amplitude_i, Duty_Cycle_out => duty_cycle_i3);	

modulator: PWM_DAC
	generic map(width => 12)
	port map(reset => reset, clk => clk, duty_cycle => duty_cycle_i3, pwm_out => PWM_OUT2);			
				 
SqrCountdwn: downcounter
	port map(clk => clk, reset => reset, enable => '1', period => divisor_i2, zero => slow_clk2);	
	
FreqLUT: BuzzFreq_Lookup
	port map(clk => clk, reset => reset, index => index_freq, Divisor => divisor_i2);

AmpLUT: BuzzAmp_Lookup
	port map(clk => clk, reset => reset, index => index_amp, amplitude => amplitude_i);

IndexRegAmp: RegisterInt
	port map(SI => index_i, Q => index_amp, clk => clk, EN => switch, reset => reset);
	
IndexRegFreq: RegisterInt
	port map(SI => index_i, Q => index_freq, clk => clk, EN => switcher, reset => reset);

END Behavioral;
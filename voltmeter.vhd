library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity Voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  distance							  : out STD_LOGIC_VECTOR (12 downto 0);
			  index								  : out integer
          );
           
end Voltmeter;

architecture Behavioral of Voltmeter is

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 :   STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in:   STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data,q_outputs_1,q_outputs_2 : STD_LOGIC_VECTOR (11 downto 0);
Signal voltage: STD_LOGIC_VECTOR (12 downto 0);
Signal busy: STD_LOGIC;
signal response_valid_out_i1,response_valid_out_i2,response_valid_out_i3 : STD_LOGIC_VECTOR(0 downto 0);
Signal bcd: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp1 : std_logic_vector(11 downto 0);
Signal index_i : integer := 0;
Signal Q_temp3 : std_logic_vector(12 downto 0);
Signal switchshort : std_logic;

Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component test_DE10_Lite is
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component registers is
   generic(bits : integer);
   port
     ( 
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(bits-1 downto 0);
      q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;

Component gen_averager is		-- MOD
  generic(N : integer);		-- MOD
  port(
    clk, reset : in std_logic;
    Din : in  std_logic_vector(11 downto 0);
    EN  : in  std_logic; -- response_valid_out
    Q   : out std_logic_vector(11 downto 0)
    );
  end Component;
  
Component voltage2distance is
   port(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
		index				:  OUT   integer;
		switchshort		:  IN		STD_LOGIC
		);  
  end Component;
  

begin
--   Num_Hex0 <= bcd(3  downto  0); 
--   Num_Hex1 <= bcd(7  downto  4);
--   Num_Hex2 <= bcd(11 downto  8);
--   Num_Hex3 <= bcd(15 downto 12);
--   Num_Hex4 <= "1111";  -- blank this display
--   Num_Hex5 <= "1111";  -- blank this display   
	DP_in    <= "000100";-- position of the decimal point in the display
	switchshort <= '0';
	
	Num_Hex3 <= "1111" when (bcd(15 downto 12) = "0000") else bcd(15 downto 12);
	
	Num_Hex5 <= "0011" when (bcd(15 downto 0) = "0000000000000000") else "1111";
	Num_Hex4 <= "0010" when (bcd(15 downto 0) = "0000000000000000") else "1111";
	Num_Hex2 <= "0010" when (bcd(15 downto 0) = "0000000000000000") else bcd(11 downto 8);
	Num_Hex1 <= "0000" when (bcd(15 downto 0) = "0000000000000000") else bcd(7 downto 4);
	Num_Hex0 <= "0010" when (bcd(15 downto 0) = "0000000000000000") else bcd(3 downto 0);
	

v2d: voltage2distance
			port map(
						clk		=> clk,
						reset    => reset,
						voltage  => voltage,
						distance => Q_temp3,
						index => index_i,
						switchshort => switchshort
		);  
						
ave :    gen_averager		-- MOD
			generic map(N => 7)		-- MOD
         port map(
                  clk       => clk,
                  reset     => reset,
                  Din       => q_outputs_2,
                  EN        => response_valid_out_i3(0),
                  Q         => Q_temp1
                  );
   
sync1 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => ADC_read,
                 q_outputs => q_outputs_1
                );

sync2 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => q_outputs_1,
                 q_outputs => q_outputs_2
                );
                
sync3 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i1,
                 q_outputs => response_valid_out_i2
                );

sync4 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i2,
                 q_outputs => response_valid_out_i3
                );                
                
SevenSegment_ins: SevenSegment  
                  PORT MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in    => DP_in
                          );
                                     
ADC_Conversion_ins:  test_DE10_Lite  PORT MAP(      
                                     MAX10_CLK1_50       => clk,
                                     response_valid_out  => response_valid_out_i1(0),
                                     ADC_out             => ADC_read);
 
LEDR(9 downto 0) <=Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
voltage <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers

binary_bcd_ins: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset    => reset,                                 
      ena      => '1',                           
      binary   => Q_temp3,    
      busy     => busy,                         
      bcd      => bcd         
      );

index <= index_i;
		
end Behavioral;

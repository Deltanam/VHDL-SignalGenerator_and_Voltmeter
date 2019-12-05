library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity tb_lab4 is
end tb_lab4;

ARCHITECTURE behaviour OF tb_lab4 IS
	constant clk_period: time:=10ns; -- 50 MHz

Component WaveGen_Buzzer
    Port ( 	  reset : in STD_LOGIC;
			  clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
			  switch : in STD_LOGIC;
			  switch2: in STD_LOGIC;
			  switch3: in STD_LOGIC;
			  switch4: in STD_LOGIC;
			  buttona: in STD_LOGIC;
			  buttonb: in STD_LOGIC;
			  PWM_OUT: out STD_LOGIC;
			  PWM_OUT2 : out STD_LOGIC;
			  LEDR : out STD_LOGIC_VECTOR (9 downto 0);
			  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
           
end Component;


--Inputs
	signal clk : std_logic;
	signal reset : std_logic;
	signal switch : STD_LOGIC := '0';
	signal switch2 : STD_LOGIC := '0';
	signal switch3 : STD_LOGIC := '0';
	signal switch4 : STD_LOGIC := '0';
	signal buttona : STD_LOGIC := '1';
	signal buttonb : STD_LOGIC := '1';
--Outputs
	signal PWM_OUT : STD_LOGIC;
	signal PWM_OUT2 : STD_LOGIC;
	signal LEDR : STD_LOGIC_VECTOR (9 downto 0);
    signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : STD_LOGIC_VECTOR (7 downto 0);


	BEGIN
	WaveGen_Buzzer_ins: WaveGen_Buzzer PORT MAP (
		clk => clk,
		reset => reset,
		buttona => buttona,
		buttonb => buttonb,
		switch => switch,
		switch2 => switch2,
		switch3 => switch3,
		switch4 => switch4,
		PWM_OUT => PWM_OUT,
		PWM_OUT2 => PWM_OUT2,
		LEDR => LEDR,
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		HEX3 => HEX3,
		HEX4 => HEX4,
		HEX5 => HEX5
		);
		
	clk_process : process
		begin
			clk<='0';
			wait for clk_period/2;
			clk<='1';
			wait for clk_period/2;
	end process;
	 
	rst_process: process
	begin
		reset<='1';
		wait for 50 ns;
		reset<='1';
		wait for 50 ns;
		reset<='0';
		wait;
	end process;
	
	button_a : process
	begin
		buttona <= '1';
		wait for 50 ns;
		buttona <= '0';
		wait for 50 ns;
	end process;
	
	button_b : process 
	begin
		buttonb <= '1';
		wait for 225 ns;
		buttonb <= '0';
		wait for 225 ns;
	end process;
	
	switches : process
	begin
		wait for 3000 ns;
		switch <= '1';
		switch4 <= '1';
		wait for 3000ns;
		switch2 <= '1';
		switch4 <= '0';
		switch <= '0';
		wait for 3000ns;
		switch3 <= '1';
		wait for 3000 ns;
		switch4 <= '1';
		wait;
	end process;
	
END;

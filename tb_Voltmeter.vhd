library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_Voltmeter is
end tb_Voltmeter;

ARCHITECTURE behaviour OF tb_Voltmeter IS
	constant clk_period: time:=10ns; -- 50 MHz

Component Voltmeter
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
	   switches			 : in  STD_LOGIC;
	   switches2			 : in  STD_LOGIC;
	   switches3			 : in STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
           
end Component;


--Inputs
	signal clk : std_logic;
	signal reset : std_logic;
	signal switch : STD_LOGIC;
	signal switch2 : STD_LOGIC;
	signal switch3 : STD_LOGIC :='0';
--Outputs
	signal LEDR : STD_LOGIC_VECTOR (9 downto 0);
    	signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : STD_LOGIC_VECTOR (7 downto 0);


	BEGIN
	Voltmeter_ins: voltmeter PORT MAP (
		clk => clk,
		reset => reset,
		switches => switch,
		switches2 => switch2,
		switches3 => switch3,
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
		reset<='0';
		wait for 50 ns;
		reset<='1';
		wait for 50 ns;
		reset<='0';
		wait;
	end process;
	
	S_process: process
	begin
		  switch<='0';
		  wait for clk_period*50;
		  switch<='1';
		  wait for clk_period*50;
	end process; 
	
	Mux2_Process: process
	begin
		switch2 <= '0';
		wait for clk_period*100;
		switch2 <= '1';
		wait for clk_period*100;
	end process;
	
END;

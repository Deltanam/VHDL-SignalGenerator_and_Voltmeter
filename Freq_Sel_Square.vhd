library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Frequency_SS is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           button_a : in STD_LOGIC;
			  button_b : in STD_LOGIC;
           divisor : out natural
          );
end Frequency_SS;

architecture Behavioral of Frequency_SS is

	signal index : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	
type array_1d is array (0 to 15) of natural;

constant divisors : array_1d := (				
(	25000000	)	,
(	12500000	)	,
(	5000000	)	,
(	2500000	)	,
(	1000000	)	,
(	500000	)	,
(	250000	)	,
(	125000	)	,
(	100000	)	,
(	62500	)	,
(	50000	)	,
(	41750	)	,
(	35750	)	,
(	31250	)	,
(	27750	)	,
(	25000	)
);
	
BEGIN
	
	selection: process(reset, clk, button_a, button_b) 
	BEGIN
		if (rising_edge(clk)) then
			if (reset = '1') then
				index <= "0000";
			elsif (button_a = '0') then
				index <= index + "0001";
			elsif (button_b = '0') then
				index <= index - "0001";
			end if;
		end if;
	END PROCESS;
	
	divisor <= divisors(to_integer(unsigned(index)));

END Behavioral;
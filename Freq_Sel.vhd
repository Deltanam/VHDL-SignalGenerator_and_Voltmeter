library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Frequency_Select is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           button_a : in STD_LOGIC;
			  button_b : in STD_LOGIC;
           divisor : out natural
          );
end Frequency_Select;

architecture Behavioral of Frequency_Select is

	signal index : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	
type array_1d is array (0 to 15) of natural;

constant divisors : array_1d := (				
(	100000	)	,
(	50000	)	,
(	20000	)	,
(	10000	)	,
(	4000	)	,
(	2000	)	,
(	1000	)	,
(	500	)	,
(	400	)	,
(	250	)	,
(	200	)	,
(	167	)	,
(	143	)	,
(	125	)	,
(	111	)	,
(	100	)
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
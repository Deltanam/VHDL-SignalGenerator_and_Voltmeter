library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Amplitude_Select is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           button_a : in STD_LOGIC;
			  button_b : in STD_LOGIC;
           Max_out : out STD_LOGIC_VECTOR(8 downto 0)
          );
end Amplitude_Select;

architecture Behavioral of Amplitude_Select is

	signal index : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	
type array_1d is array (0 to 15) of STD_LOGIC_VECTOR(8 downto 0);

constant maxes : array_1d := (				
(	"000000100"	)	,
(	"000101000"	)	,
(	"001001000"	)	,
(	"001101000"	)	,
(	"010001000"	)	,
(	"010101000"	)	,
(	"011001000"	)	,
(	"011101000"	)	,
(	"100001000"	)	,
(	"100101000"	)	,
(	"101001000"	)	,
(	"101101000"	)	,
(	"110001000"	)	,
(	"110101000"	)	,
(	"111101000"	)	,
(	"111111111"	)
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
	
	Max_out <= maxes(to_integer(unsigned(index)));

END Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX2TO1_9 is
    Port ( W0 : in  STD_LOGIC_VECTOR(8 downto 0);
           W1 : in  STD_LOGIC_VECTOR(8 downto 0);
		     S  : in  STD_LOGIC;
           F  : out STD_LOGIC_VECTOR(8 downto 0)
          );
end Mux2TO1_9;

architecture yeet200 of MUX2TO1_9 is
	begin
	F 	<= 	 W0 when S = '0'
		else W1 when S = '1';
		  
end yeet200;

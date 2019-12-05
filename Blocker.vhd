library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Blocker is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           EN :  in STD_LOGIC;
			  Input1 : in STD_LOGIC;
			  Input2 : in STD_LOGIc;
           Output1 : out STD_LOGIC;
			  Output2 : out STD_LOGIC
          );
end Blocker;

architecture Behavioral of Blocker is
	signal altbit : STD_LOGIC_VECTOR(0 downto 0) := "0";	
	
BEGIN

	with altbit select Output1 <=
		'1' when "0",
		Input1 when "1",
		'1' when others;
		
   with altbit select Output2 <=
		'1' when "0",
		Input2 when "1",		
		'1' when others;		

	count : process(clk, reset)
       begin
            if (rising_edge(clk)) then
					 
					 if(reset = '1') then
								altbit <= "0";
						
                elsif (EN = '1') then
                        altbit <= "1";
								
					 elsif (EN = '0') then
								altbit <= "0";
                end if;
            end if;
    end process;
	
END Behavioral;
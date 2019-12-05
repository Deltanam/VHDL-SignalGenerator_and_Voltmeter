library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Up_Counter is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           EN :  in STD_LOGIC;
           index_out : out STD_LOGIC_VECTOR(8 downto 0)
          );
end Up_Counter;

architecture Behavioral of Up_Counter is

	constant zeros : STD_LOGIC_VECTOR(8 downto 0) := "000000000";
	signal index : STD_LOGIC_VECTOR(8 downto 0) := "000000000";
	
BEGIN
	count : process(clk, reset)
       begin
            if(reset = '1') then
                index <= zeros;
            elsif (rising_edge(clk)) then 
                if (EN = '1') then
                        index <= index + '1';                                        
                end if;
            end if;
        end process;
		  
	index_out <= index;

END Behavioral;
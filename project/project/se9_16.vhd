library ieee;
use ieee.std_logic_1164.all;

entity extend_9_16 is
	port(input: in std_logic_vector(8 downto 0);
		  output: out std_logic_vector(15 downto 0));
end entity;

architecture design of extend_9_16 is

begin
	extend_7: process(input)
	
	variable sel : std_logic;
	
	begin
		
		sel := input(8);
		
		output(8 downto 0) <= input;
		
		case sel is
			when '0' =>
			 output(15 downto 9) <= "0000000";
			when others =>
			 output(15 downto 9) <= "1111111";
		end case;
	end process;
		
		
end design;
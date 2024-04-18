library ieee;
use ieee.std_logic_1164.all;

entity extend_6_16 is
	port(input: in std_logic_vector(5 downto 0);
	     output: out std_logic_vector(15 downto 0));
end entity;

architecture design of extend_6_16 is

begin
	extend_10: process(input)
	
	variable sel : std_logic;
	
	begin
		
		sel := input(5);
		
		output(5 downto 0) <= input;
		
		case sel is
			when '0' =>
			 output(15 downto 6) <= "0000000000";
			when others =>
			 output(15 downto 6) <= "1111111111";
		end case;
	end process;
		
		
end design;
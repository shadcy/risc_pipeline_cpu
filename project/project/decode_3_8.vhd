library ieee;
use ieee.std_logic_1164.all;

entity decoder is
	port(input: in std_logic_vector(2 downto 0);
		  output: out std_logic_vector(8 downto 0));
end entity;

architecture design of decoder is

begin
	
	decode: process(input)
	
	variable sel: std_logic_vector(2 downto 0);
	
	begin
		
		sel := input(2 downto 0);
		
		case sel is
			when "000" =>
				output <= "000000001";
			when "001" =>
				output <= "000000010";
			when "010" =>
				output <= "000000100";
			when "011" =>
				output <= "000001000";
			when "100" =>
				output <= "000010000";
			when "101" =>
				output <= "000100000";
			when "110" =>
				output <= "001000000";
			when "111" =>
				output <= "010000000";
			when others =>
				output <= "000000000";
		end case;
	end process;
end design;

			
				
	


	
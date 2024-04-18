library ieee;
use ieee.std_logic_1164.all;

entity zeroextender is
	port(input: in std_logic_vector(8 downto 0);
		  output: out std_logic_vector(15 downto 0));
end entity;

architecture zeroarch of zeroextender is

begin
	extend_7: process(input)
	
	
	begin
		output(8 downto 0) <= input;
		output(15 downto 9) <= "0000000";

	end process;
		
		
end zeroarch;
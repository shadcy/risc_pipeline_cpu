library ieee;
use ieee.std_logic_1164.all;

entity seq_ex is
	port(input: in std_logic_vector(8 downto 0);
		  output: out std_logic_vector(15 downto 0));
end entity;

architecture design of seq_ex is

begin
	
	output(15 downto 7) <= input;
	output(6 downto 0) <= "0000000";
	
end design;
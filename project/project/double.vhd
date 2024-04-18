library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity double is
	port(
			A: in std_logic_vector(15 downto 0);
			B: out std_logic_vector(15 downto 0)
		);
end entity;

architecture doublearch of double is
	signal tempreg: std_logic_vector(15 downto 0);
	
	begin
		
			tempreg(15 downto 1) <= A(14 downto 0);
			tempreg(0) <= '0';
			B <= tempreg;
end architecture;	
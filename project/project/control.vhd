library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control is
	port(
			opcode: in std_logic_vector(3 downto 0);
			enabler: out std_logic_vector(7 downto 0)
			);
end entity;

architecture behave of control is

signal enbl: std_logic_vector(7 downto 0):= "11111101";

begin 

contrproc: process(opcode)

	begin

		 if(opcode="0110" or opcode="0111") then --readval,stallid,stallrr,stallexe,stallma,stallwb,sel1,sel6
		 	enbl<="11111101";--see what to do for lmsm
		 elsif(opcode="1000" or opcode="1001" or opcode="1010" or opcode="1111") then
		 	enbl<="11111111";
		 elsif(opcode="1100" or opcode="1101") then
		 	enbl<="11111110";
		 else 
		 	enbl<="11111101";
		 end if;

 	end process;
	
	enabler<=enbl;
 end behave;
		
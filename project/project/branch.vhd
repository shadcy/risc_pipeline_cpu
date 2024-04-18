library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity branch is
port(
		opcode:in std_logic_vector(3 downto 0);
		eq,lt: in std_logic;
		aluop,pcop:in std_logic_vector(15 downto 0);
		alupc: out std_logic_vector(15 downto 0));
end entity;

architecture bhv of branch is
begin

checkproc: process(opcode, eq, lt, aluop, pcop)

begin

	if((opcode="1000" and eq='1') or (opcode="1001" and lt='1') or (opcode="1010" and (eq='1' or lt='1')) or opcode="1100" or opcode="1101" or opcode="1111") then
		alupc<=aluop;
	else 
		alupc<=pcop;
	end if;

end process;

end bhv;
		
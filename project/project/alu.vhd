library ieee;
use ieee.std_logic_1164.all;

entity alu is
port(
	alu_A: in std_logic_vector(15 downto 0);
	alu_B: in std_logic_vector(15 downto 0);
	Cin: in std_logic;
	sel: in std_logic;
	enable: in std_logic;
	alu_out: out std_logic_vector(15 downto 0);
	Cout: out std_logic;
	Z: out std_logic);
end alu;

architecture behav of alu is

signal sumop: std_logic_vector(15 downto 0) := "0000000000000000";
signal nandop: std_logic_vector(15 downto 0) := "0000000000000000";

begin

	alu_out <= sumop when sel ='0' else nandop when sel='1';

	ALU1: process(alu_A, alu_B, Cin, sel, enable, sumop, nandop)
	variable Cinit: std_logic := '0';
	begin
	Cinit := Cin;
	if(sel='0') then
		add: for i in 0 to 15 loop
			sumop(i) <= alu_A(i) xor alu_B(i) xor Cinit;
			Cinit := (alu_A(i) and alu_B(i)) or (Cinit and (alu_A(i) xor alu_B(i)));
		end loop;
		if(enable='1') then
			Cout <= Cinit; --else carry is not generated
		end if;	
		if(sumop="0000000000000000" and Cinit='0') then 
			Z <= '1';
		else Z <= '0';
		end if;
	elsif(sel='1') then
		nandop <= alu_A nand alu_B;
		if(nandop="0000000000000000") then 
			Z <= '1';
		else Z <= '0';
		end if;
	end if;
	end process;

end behav;





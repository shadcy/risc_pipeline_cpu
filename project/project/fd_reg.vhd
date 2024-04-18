library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fd_reg is
		port(
				clk, reset, writevalue: in std_logic;
				instr_ip, pc_ip: in std_logic_vector(15 downto 0);
				instr_op, pc_op: out std_logic_vector(15 downto 0)
		);
end entity;

architecture f_d of fd_reg is
	signal instr, pc: std_logic_vector(15 downto 0);
begin 
	writeproc: process(writevalue,instr_ip,pc_ip)
	begin
	if(writevalue='1') then
		instr<=instr_ip;
		pc<=pc_ip;
	end if;
	end process;
	
		ip_proc: process(clk, writevalue, reset, instr_ip, pc_ip)
			
			begin
				   if(reset='1') then
						pc_op<="0000000000000000";
						instr_op<="0000000000000000";
					elsif (clk'event and clk='0') then
						pc_op<=pc;
						instr_op<=instr;
					end if;
					
			end process;
	end architecture;
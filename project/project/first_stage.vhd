library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 
entity first_stage is
	port (
				clk, reset: in std_logic;
				pc: in std_logic_vector(15 downto 0);
				curr_instr, pc_next: out std_logic_vector(15 downto 0)
			);
end entity;

architecture fetch of first_stage is
			component read_memory is
			port(
					mem_A : in std_logic_vector(15 downto 0);
					mem_data_out: out std_logic_vector(15 downto 0)
					);
				end component;
			
			
			component alu is
			port(
					alu_A, alu_B: in std_logic_vector(15 downto 0);
					Cin, enable: in std_logic;
					sel: in std_logic;
					alu_out: out std_logic_vector(15 downto 0);
					Cout, Z: out std_logic	
					);
				end component;
				
	signal pc_inc, instr_store: std_logic_vector(15 downto 0);
	signal carry_A, zero_A: std_logic;
	
	begin	
		read_mem: read_memory port map(mem_A=>pc, mem_data_out=>instr_store);
		pc_increment: alu port map(alu_A=>pc, alu_B=>"0000000000000001", Cin=>'0', sel=>'0', enable=>'0', alu_out=>pc_inc, Cout=>carry_A, Z=> zero_A);
		
		curr_instr<=instr_store;
		check: process(clk, reset)
			begin
			if(reset='1') then 
				pc_next<="0000000000000000";
		
			elsif (clk'event and clk='0') then 
				if(instr_store(15 downto 15) /= "1") then
						pc_next<=pc_inc;
				else
					pc_next <= pc;
				end if;
			end if;
		end process;
		
	end architecture;
		
		
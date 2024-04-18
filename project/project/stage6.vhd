library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage6 is
		port(
				clk, reset: in std_logic;
				reg3_add_ip: in std_logic_vector(2 downto 0);
				zero_ip, carry_ip: in std_logic;
				cond_ip: in std_logic_vector(1 downto 0);
				pc_ip: in std_logic_vector(15 downto 0);
				opcode_ip: in std_logic_vector(3 downto 0);
				alu_ip: in std_logic_vector(15 downto 0);
				
				reg3_add_op: out std_logic_vector(2 downto 0);
				reg_enable: out std_logic;
				data_op: out std_logic_vector(15 downto 0);
					controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0)
				
			);
end entity;

architecture write_back of stage6 is
		signal data_out: std_logic_vector(15 downto 0);
		signal pc: std_logic_vector(15 downto 0);
		
		begin 
		

			
			write_proc: process(reg3_add_ip, zero_ip, carry_ip, opcode_ip, cond_ip, pc_ip, alu_ip)
			
			
				begin
					
					if((opcode_ip="0001" and (cond_ip="00" or cond_ip="11")) or (opcode_ip="0010" and (cond_ip="00")) or (opcode_ip="0011") or (opcode_ip="0100") or (opcode_ip="0000") or (opcode_ip="0110") or (opcode_ip="1100") or (opcode_ip="1101")) then
						data_out<=alu_ip;
						reg_enable <= '1';
					elsif((opcode_ip = "0001" and (cond_ip = "10") )or (opcode_ip="0010" and (cond_ip="10"))) then
						data_out <= alu_ip;
						reg_enable <= carry_ip; 
					elsif((opcode_ip = "0001" and (cond_ip="01")) or (opcode_ip="0010" and (cond_ip="01"))) then 
						data_out <= alu_ip;
						reg_enable <= zero_ip;
					else 
						reg_enable <= '0';
					end if;

				end process;
			reg3_add_op<=reg3_add_ip;
			data_op<=data_out;
			controlsigout <= controlsigin;
			end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage_4 is
		port(
				clk, reset: in std_logic;
				reg1_ip, reg2_ip: in std_logic_vector(15 downto 0); 
				reg3_add_ip: in std_logic_vector(2 downto 0);
				opcode_ip: in std_logic_vector(3 downto 0);
				imm6_ip: in std_logic_vector(15 downto 0);
				imm9_ip: in std_logic_vector(15 downto 0);
				pc_ip: in std_logic_vector(15 downto 0);
				cond_ip: in std_logic_vector(1 downto 0);
				Rareg_ip: in std_logic_vector(15 downto 0);
				flipin : in std_logic;
				
				
				alu_op: out std_logic_vector(15 downto 0);
				cond_op: out std_logic_vector(1 downto 0);
				carry_op, zero_op, eq_op, lt_op: out std_logic;
				reg3_add_op: out std_logic_vector(2 downto 0);
				opcode_op: out std_logic_vector(3 downto 0);
				Rareg_op: out std_logic_vector(15 downto 0);
				pc_op: out std_logic_vector(15 downto 0);
				flipout : out std_logic;
	
				pcup : out std_logic_vector(15 downto 0);
				controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0));
			
end entity;

architecture execute of stage_4 is
			component alu is
			port(
					alu_A, alu_B: in std_logic_vector(15 downto 0);
					Cin, enable: in std_logic;
					sel: in std_logic;
					alu_out: out std_logic_vector(15 downto 0);
					Cout, Z: out std_logic	
					);
			end component;
			component chooser4 is
			port (   I0, I1,I2,I3 : in std_logic_vector(15 downto 0);
						C : in std_logic_vector(1 downto 0); 
						Y : out std_logic_vector(15 downto 0)
					);
			end component;
			component double is
			port(A: in std_logic_vector(15 downto 0);
					B: out std_logic_vector(15 downto 0)
					);
			end component;
			
			component comparator is
    port(
         A : in std_logic_vector(15 downto 0); 
         B : in std_logic_vector(15 downto 0); 
			lt: out std_logic;
         equal : out std_logic 
    );
		end component;
	 
	component incrementer2 is
    port(
         orgval : in std_logic_vector(15 downto 0); 
			incvalue: out std_logic_vector(15 downto 0)
         );     
	end component;

			
signal reg1, reg2: std_logic_vector(15 downto 0);
signal reg3_add: std_logic_vector(2 downto 0);
signal opcode: std_logic_vector(3 downto 0);
signal pc: std_logic_vector(15 downto 0);
signal carry_out, zero_out: std_logic;
signal rareg, alu_reg: std_logic_vector(15 downto 0);
signal cond: std_logic_vector(1 downto 0);
signal imm6, imm9: std_logic_vector(15 downto 0);
signal a, b: std_logic_vector(15 downto 0);
signal EN : std_logic;
signal alu_sel: std_logic;
signal carry :std_logic;
signal doub_A, doub_B: std_logic_vector(15 downto 0);
signal less, equ:std_logic;

	begin
	
		reg1<=reg1_ip;
		reg2<=reg2_ip;
		reg3_add<=reg3_add_ip;
		opcode<=opcode_ip;
		pc<=pc_ip;
		rareg<=rareg_ip;
		cond<=cond_ip;
		imm6 <= imm6_ip;
		imm9 <= imm9_ip;
		
	alu_ex: alu port map(alu_A=>a, alu_B=>b, Cin=> carry, enable=>EN, sel=>alu_sel, alu_out=>alu_reg, Cout=>carry_out , Z=>zero_out);
	
	
	
	doub: double port map(A=>doub_A, B=>doub_B);
	
	moreorless : comparator port map(A => reg1, B => reg2, lt => less,equal => equ); 
	
	increaser : incrementer2 port map(orgval => pc, incvalue => pcup);
		
		exe_proc: process(reg1, doub_B,reg2, imm6, imm9, pc, opcode, cond, reg3_add,alu_reg,carry_out,flipin,zero_out,equ,less,rareg,controlsigin)
	
		
			begin
	
					if(opcode="0001")then
						if(cond="00" or cond="01" or cond="10") then
							if(flipin='0') then
								a<=reg1;
								b<=reg2;
								EN<='1';
								alu_sel<='0';
								alu_op <= alu_reg;
								carry <='0';
								pc_op <= pc;
								
							
							elsif(flipin='1') then
								a<=reg1;
								b<= not reg2;
								EN<='1';
								alu_sel<='0';
								alu_op <= alu_reg;
								carry <= '0';
								pc_op <= pc;
								end if;

						elsif(cond="11") then
							if (flipin='0') then
								a<=reg1;
								b<=reg2;
								EN<='1';
								alu_sel<='0';
								alu_op <= alu_reg;
								carry <= carry_out;
								pc_op <= pc;
							
							elsif(flipin= '1')then
								a<=reg1;
								b<= not reg2;
								EN<='1';
								alu_sel<='0';
								alu_op <= alu_reg;
								carry <= carry_out;
								pc_op <= pc;
								end if;
						end if;
					
					elsif(opcode="0000") then
						a<=reg1;
						b<=imm6;
						EN<='1';
						alu_sel<='0';
						carry <= '0';
						pc_op <= pc;
						
						
					elsif(opcode="0010")then
											
												if(flipin='0') then
													a<=reg1;
													b<=reg2;
													EN<='1';
													alu_sel<='1';
													alu_op <= alu_reg;
													carry <='0';
													pc_op <= pc;
												
												elsif(flipin= '1') then
													a<=reg1;
													b<= not reg2;
													EN<='1';
													alu_sel<='1';
													alu_op <= alu_reg;
													carry <= '0';
													pc_op <= pc;
												end if;

					elsif(opcode="0011")then
											
										
													a<=imm9;
													b<="0000000000000000";
													EN<='0';
													alu_sel<='0';
													alu_op <= alu_reg;
													carry <='0';
													pc_op <= pc;

					elsif(opcode="0100" or opcode="0101") then
											a<=imm6;
											b<=reg2;
											EN<='0';
											alu_sel<='0';
											alu_op<=alu_reg;
											pc_op <= pc;
					

														
					elsif(opcode="1000" or opcode="1001" or opcode="1010") then
								doub_A <= imm6;
								a <= pc;
								b <= doub_B;
								carry <= '0';
								EN <= '0';
								alu_sel <= '0';
								alu_op <= alu_reg;
								pc_op <= pc xor "0000000000000001";
								
--							else
--								a <= pc;
--								b <= "0000000000000001";
--								carry <= '0';
--								EN <= '0';
--								alu_sel <= '0';
--								alu_op <= alu_reg;
--								end if;
--								
								
						elsif(opcode="1100") then
								doub_A <= imm6;
								a <= pc;
								b <= doub_B;
								carry <= '0';
								EN <= '0';
								alu_sel <= '0';
								alu_op <= alu_reg;
								pc_op <= pc xor "0000000000000001";
								
						elsif(opcode="1101") then
								a <= reg2;
								b <= "0000000000000000";
								carry <= '0';
								EN <= '0';
								alu_sel <= '0';
								alu_op <= alu_reg;
								pc_op <= pc xor "0000000000000001";
						
						elsif(opcode="1111") then
								doub_A <= imm9;
								a <= reg1;
								b <= doub_B;
								carry <= '0';
								EN <= '0';
								alu_sel <= '0';
								alu_op <= alu_reg;
								pc_op <= pc xor "0000000000000001";
					
					end if;
				flipout <= flipin;
				carry_op <= carry_out;
				zero_op <= zero_out;
				cond_op <= cond;
				eq_op <= equ;
				lt_op <= less;
				Rareg_op <= rareg;
				controlsigout <= controlsigin;

		end process;
		
		reg3_add_op <= reg3_add;
		opcode_op <= opcode;

		end execute;
				
				
			
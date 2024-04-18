library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity re_reg is
		port(
		
				clk, reset, writevalue: in std_logic;
				reg1_ip, reg2_ip: in std_logic_vector(15 downto 0);
				reg3_add_ip: in std_logic_vector(2 downto 0);
				ratemp1 : in std_logic_vector(2 downto 0);
				ratemp2 : in std_logic_vector(2 downto 0);
				opcode_ip: in std_logic_vector(3 downto 0);
				imm6_ip, imm9_ip: in std_logic_vector(15 downto 0);
				pc_ip: in std_logic_vector(15 downto 0);
				cond_ip: in std_logic_vector(1 downto 0);
				flipin: in std_logic;
				reg1_op, reg2_op: out std_logic_vector(15 downto 0);
				reg3_add_op: out std_logic_vector(2 downto 0);
				opcode_op: out std_logic_vector(3 downto 0);
				imm6_op, imm9_op: out std_logic_vector(15 downto 0);
				pc_op: out std_logic_vector(15 downto 0);
				cond_op: out std_logic_vector(1 downto 0);
				flipout:out std_logic;
				raforw1: out std_logic_vector(2 downto 0);
				raforw2: out std_logic_vector(2 downto 0);
				controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0));
			
	end re_reg;
	
architecture r_e of re_reg is
	signal reg1, reg2: std_logic_vector(15 downto 0);
	signal reg3_add,ra,rb: std_logic_vector(2 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal imm6, imm9: std_logic_vector(15 downto 0);
	signal pc: std_logic_vector(15 downto 0);
	signal cond: std_logic_vector(1 downto 0);
	signal flip: std_logic;
	signal controlsig :std_logic_vector(7  downto 0);
	
	begin
	
		writeproc:process(writevalue, ratemp1,ratemp2,controlsigin, reg1_ip, reg2_ip, reg3_add_ip, opcode_ip, imm6_ip, imm9_ip, pc_ip, cond_ip, flipin)
		
		begin
		
		
		if(writevalue='1') then
			reg1<=reg1_ip;
			reg2<=reg2_ip;
			reg3_add<=reg3_add_ip;
			opcode<=opcode_ip;
			imm6<=imm6_ip;
			imm9<=imm9_ip;
			pc<=pc_ip;
			cond<=cond_ip;
			flip<=flipin;
			ra <= ratemp1;
			rb <=ratemp2;
			controlsig <= controlsigin;


		end if;
		end process;
	
		ip_proc: process(reset, clk, writevalue, reg1, reg2, reg3_add, opcode, imm6, imm9, pc, cond,flip,ra,rb,controlsig)
		begin
			if(reset='1') then
				pc_op<="0000000000000000";
				reg1_op<="0000000000000000";
				reg2_op<="0000000000000000";
				reg3_add_op<="000";
				opcode_op<="0000";
				imm6_op<="0000000000000000";
				imm9_op<="0000000000000000";
				cond_op<="00";
				flipout<='0';
				raforw1 <= "000";
				raforw2 <= "000";
				controlsigout <= "00000000";
				
			elsif(clk'event and clk='0') then
				reg1_op<=reg1;
				reg2_op<=reg2;
				reg3_add_op<=reg3_add;
				opcode_op<=opcode;
				imm6_op<=imm6;
				imm9_op<=imm9;
				pc_op<=pc;
				cond_op<=cond;
				flipout<=flip;
				raforw1 <= ra;
				raforw2 <= rb;
				controlsigout <= controlsig;
			end if;
		end process;
	end architecture;			
			
			
			
			
			
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dr_reg is
		port(
				clk, reset, writevalue: in std_logic;
				ra_ip, rb_ip, rc_ip: in std_logic_vector(2 downto 0);
				opcode_ip: in std_logic_vector(3 downto 0);
				cond_ip: in std_logic_vector(1 downto 0);
				imm6_ip: in std_logic_vector(15 downto 0);
				imm9_ip: in std_logic_vector(15 downto 0);
				pc_ip: in std_logic_vector(15 downto 0);
				flipin: in std_logic;
				ra_op, rb_op: out std_logic_vector(2 downto 0);
				rc_op : out std_logic_vector(2 downto 0);
				opcode_op: out std_logic_vector(3 downto 0);
				cond_op: out std_logic_vector(1 downto 0);
				imm6_op: out std_logic_vector(15 downto 0);
				imm9_op: out std_logic_vector(15 downto 0);
				pc_op: out std_logic_vector(15 downto 0);
				flipout: out std_logic;
				controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0));
end dr_reg;

architecture d_r of dr_reg is
	signal  pc: std_logic_vector(15 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal cond: std_logic_vector(1 downto 0);
	signal imm6: std_logic_vector(15 downto 0);
	signal imm9: std_logic_vector(15 downto 0);
	signal flip: std_logic;
	signal controlsig: std_logic_vector(7 downto 0);
	signal ra, rb, rc : std_logic_vector(2 downto 0);
	
begin
	writeproc: process(writevalue, ra_ip, rb_ip, rc_ip, pc_ip, opcode_ip, cond_ip, imm6_ip, imm9_ip,controlsigin,flipin)
	begin
	if(writevalue='1') then
		ra<=ra_ip;
		rb<=rb_ip;
		rc<=rc_ip;
		pc<=pc_ip;
		flip<=flipin;
		opcode<=opcode_ip;
		cond<=cond_ip;
		imm6<=imm6_ip;
		imm9<=imm9_ip;
		controlsig <= controlsigin;
	end if;
	end process;

		ip_proc: process(clk, writevalue, reset, ra_ip, rb_ip, rc_ip, pc_ip, opcode_ip, cond_ip, imm6_ip, imm9_ip)
			
			begin
				   if(reset='1') then
						pc_op<="0000000000000000";
						ra_op<="000";
						rb_op<="000";
						rc_op<="000";
						opcode_op<="0000";
						cond_op<="00";
						imm6_op<="0000000000000000";
						imm9_op<="0000000000000000";
						flipout<='0';
						controlsigout <= "00000000";
					elsif (clk'event and clk='0') then
						pc_op<=pc;
						ra_op<=ra;
						rb_op<=rb;
						rc_op<=rc;
						opcode_op<=opcode;
						cond_op<=cond;
						imm6_op<=imm6;
						imm9_op<=imm9;
						flipout<=flip;
						controlsigout <= controlsig;
					end if;
					
			end process;
	end architecture;
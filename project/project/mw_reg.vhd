library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mw_reg is
	port(
			clk, reset, writevalue: in std_logic;
			alu_ip: in std_logic_vector(15 downto 0);
			reg3_add_ip: in std_logic_vector(2 downto 0);
			zero_ip, carry_ip: in std_logic;
			opcode_ip: in std_logic_vector(3 downto 0); 
			pc_ip: in std_logic_vector(15 downto 0);
			cond_ip: in std_logic_vector(1 downto 0);
--			flipin: in std_logic;
			alu_op: out std_logic_vector(15 downto 0);
			reg3_add_op: out std_logic_vector(2 downto 0);
			zero_op, carry_op: out std_logic;
			opcode_op: out std_logic_vector(3 downto 0);
			pc_op: out std_logic_vector(15 downto 0);
			cond_op: out std_logic_vector(1 downto 0);
--			flipout: out std_logic
	controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0));

end mw_reg;

architecture m_w of mw_reg is
	signal alu: std_logic_vector(15 downto 0);
	signal reg3_add: std_logic_vector(2 downto 0);
	signal zero_A, carry_A, flip: std_logic;
	signal opcode: std_logic_vector(3 downto 0);
	signal pc: std_logic_vector(15 downto 0);
	signal cond: std_logic_vector(1 downto 0);
		signal controlsig: std_logic_vector(7 downto 0);
	begin
		
		writeproc: process(writevalue, alu_ip, reg3_add_ip, zero_ip, carry_ip, opcode_ip, pc_ip, cond_ip,controlsigin)
		begin
			if(writevalue='1') then
				alu<=alu_ip;
				reg3_add<=reg3_add_ip;
				zero_A<=zero_ip;
				carry_A<=carry_ip;
				opcode<=opcode_ip;
				pc<=pc_ip;
				cond<=cond_ip;
--				flip<=flipin;
	controlsig <= controlsigin;
			end if;
		end process;
	
	ip_proc: process(clk, reset, writevalue, alu_ip, reg3_add_ip, zero_ip, carry_ip, opcode_ip, pc_ip, cond_ip)
		begin
		
			if(reset='1') then
				pc_op<="0000000000000000";
				alu_op<="0000000000000000";
				reg3_add_op<="000";
				zero_op<='0';
				carry_op<='0';
				opcode_op<="0000";
				cond_op<="00";
				controlsigout <= "00000000";
--				flipout<='0';
			elsif(clk'event and clk='0') then
				pc_op<=pc;
				alu_op<=alu;
				reg3_add_op<=reg3_add;
				zero_op<=zero_A;
				carry_op<=carry_A;
				opcode_op<=opcode;
				cond_op<=cond;
				controlsigout <= controlsig;
--				flipout<=flip;
			end if;
		end process;
end architecture;
		
	
	
	
	
	
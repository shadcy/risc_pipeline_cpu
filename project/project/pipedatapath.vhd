library ieee;
use ieee.std_logic_1164.all;

entity pipedatapath is
	port(
		clk,rst: in std_logic;
		output: out std_logic);
end entity;

architecture pipearch of pipedatapath  is

component first_stage is
	port (
				clk, reset: in std_logic;
				pc: in std_logic_vector(15 downto 0);
				curr_instr, pc_next: out std_logic_vector(15 downto 0)
			);
end component;
		
component stage2 is
 
	port(
		clk,rst : in std_logic;
		pcin : in std_logic_vector(15 downto 0);
		IRip : in std_logic_vector(15 downto 0);
		IR15_12 : out std_logic_vector(3 downto 0);
		IR11_9 : out std_logic_vector(2 downto 0);
		IR8_6 : out std_logic_vector(2 downto 0);
		IR5_3 : out std_logic_vector(2 downto 0);
		IR5_0 : out std_logic_vector(15 downto 0);
		IR8_0 : out std_logic_vector(15 downto 0);
		IR1_0 : out std_logic_vector(1 downto 0);
		IR_c : out std_logic;
		pcout : out std_logic_vector(15 downto 0);
		controlsigout :  out std_logic_vector(7 downto 0)
		);
end component;

component stage3 is
	port(
		clk,rst,writevalue,readvalue : in std_logic;
		mux1: in std_logic_vector(2 downto 0);
		mux2 : in std_logic_vector(2 downto 0);
		mux3 : in std_logic_vector(2 downto 0);
		rcin : in std_logic_vector(2 downto 0);
		opin: in std_logic_vector(3 downto 0);
		imm6in : in std_logic_vector(15 downto 0);
		imm9in : in std_logic_vector(15 downto 0);
		regvalue : in std_logic_vector(15 downto 0);
		pcin : in std_logic_vector(15 downto 0);
		ratemp1:in std_logic_vector(2 downto 0);
		ratemp2:in std_logic_vector(2 downto 0);
		condin : in std_logic_vector(1 downto 0);
		regouta: out std_logic_vector(15 downto 0);
		regoutb: out std_logic_vector(15 downto 0);
		rcout: out std_logic_vector(2 downto 0);
		opout: out std_logic_vector(3 downto 0);
		imm6out: out std_logic_vector(15 downto 0);
		imm9out: out std_logic_vector(15 downto 0);
		condout: out std_logic_vector(1 downto 0);
		pcout : out std_logic_vector(15 downto 0);
		flipin : in std_logic;
		flipout : out std_logic;
		raout1 : out std_logic_vector(2 downto 0);
		raout2 : out std_logic_vector(2 downto 0);
		pcfetch : in std_logic_vector(15 downto 0);
						controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0));
		
end component;

component stage_4 is
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
				controlsigout : out std_logic_vector(7 downto 0)
			);
end component;

component stage5 is
	port(
				clk,rst: in std_logic;
		regadd_in: in std_logic_vector(15 downto 0);
		aluin : in std_logic_vector(15 downto 0);
		rcin : in std_logic_vector(2 downto 0);
		zin : in std_logic;
		cin : in std_logic;
		opin: in std_logic_vector(3 downto 0);
		pcin : in std_logic_vector(15 downto 0);
		condin : in std_logic_vector(1 downto 0);
		aluout: out std_logic_vector(15 downto 0);
		rcout: out std_logic_vector(2 downto 0);
		zout : out std_logic;
		cout : out std_logic;
		opout : out std_logic_vector(3 downto 0);
		pcout : out std_logic_vector(15 downto 0);
		condout: out std_logic_vector(1 downto 0);
			controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0)

	);
end component;

component stage6 is
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
end component;

component fd_reg is -- the fetch to decode pipeline register
		port(
				clk, reset, writevalue: in std_logic;
				instr_ip, pc_ip: in std_logic_vector(15 downto 0);
				instr_op, pc_op: out std_logic_vector(15 downto 0)
		);
end component;

component dr_reg is -- the decode to read pipeline register
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
end component;

component re_reg is --read to execute pipeline register
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
				controlsigout : out std_logic_vector(7 downto 0)
			);
end component;

component em is --execute to memory pipeline register
port(clk,reset,writevalue : in std_logic;
	alu_outip, pc_in: in std_logic_vector(15 downto 0);
	rc_add_in: in std_logic_vector(2 downto 0);
	ra_data_in: in std_logic_vector(15 downto 0);
	z_in,c_in: in std_logic;
	cond_in: in std_logic_vector(1 downto 0);
	opcode_in: in std_logic_vector(3 downto 0);
--	flipin: in std_logic;
	alu_outop, pc_op: out std_logic_vector(15 downto 0);
	rc_add_op: out std_logic_vector(2 downto 0);
	ra_data_op: out std_logic_vector(15 downto 0);
	z_op,c_op: out std_logic;
	cond_op: out std_logic_vector(1 downto 0);
	opcode_op: out std_logic_vector(3 downto 0);
					controlsigin : in std_logic_vector(7 downto 0);
				controlsigout : out std_logic_vector(7 downto 0)
);
end component;

component mw_reg is -- memory to write back pipeline register
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
				controlsigout : out std_logic_vector(7 downto 0)
		
		);
end component;

component pickone is -- a 16 bit 2x1 mux
	 port (  I0, I1 : in std_logic_vector(15 downto 0); 
				C : in std_logic; 
				Y : out std_logic_vector(15 downto 0)
				);
end component;

component chooser4 is -- a 16 bit 4x1 mux
	port(
			I0, I1,I2,I3 : in std_logic_vector(15 downto 0); 
			C : in std_logic_vector(1 downto 0); 
			Y : out std_logic_vector(15 downto 0)
			);
end component;

component forwarder is  -- forwarding unit  
	 port(
         st4in,st5in,st6in : in std_logic_vector(15 downto 0);
         rarr : in std_logic_vector(2 downto 0);
			rbrr : in std_logic_vector(2 downto 0); 
			rcex : in std_logic_vector(2 downto 0);
         rcma : in std_logic_vector(2 downto 0);
			rcwb : in std_logic_vector(2 downto 0);
			formux1:out std_logic_vector(1 downto 0);
			formux2:out std_logic_vector(1 downto 0);
			st4out,st5out,st6out : out std_logic_vector(15 downto 0)
    ); 
	 end component;

component branch is
port(
		opcode:in std_logic_vector(3 downto 0);
		eq,lt: in std_logic;
		aluop,pcop:in std_logic_vector(15 downto 0);
		alupc: out std_logic_vector(15 downto 0));
end component;

signal fliprg2,fliprg3,flipst3,flipst4,zrg4,zst5,zrg5,zst6,crg4,cst5,crg5,cst6,eqrg4,ltrg4,reg_en_rf: std_logic;

signal pcrg1,pcst2,pcrg2,pcrg3,pcst3,pcrg4,pcst4,pcrg5,pcst5,pcst6,pcmem, alupc,pcup,fmux1,fmux2,fmux3:std_logic_vector(15 downto 0);

signal irrg1,irst2,im6rg2,im6st3,im6rg3,im6st4,im9rg2,im9st3,im9rg3,im9st4,rg1st4,rg2st4,alrg4,alrg5,alst5,alst6,addrg4,addst5,data_rf,alumux,regval1,regval2,aluinp1,aluinp2: std_logic_vector(15 downto 0);

signal oprg2,opst3,oprg3,opst4,oprg4,opst5,oprg5,opst6: std_logic_vector(3 downto 0);

signal rarg2,rbrg2,rcrg2,rast3,rbst3,rcst3,rcrg3,rcst4,rcrg4,rcst5,rcrg5,rcst6 ,rcrf,tempa,tempb,fwra,fwrb: std_logic_vector(2 downto 0);

signal cdrg2,cdrg3,cdrg4,cdrg5,cdst3,cdst4,cdst5,cdst6,fsel1,fsel2 : std_logic_vector(1 downto 0);

signal sgrg2,sgrg3,sgrg4,sgrg5,sgst3,sgst4,sgst5,sgst6,sgrf: std_logic_vector(7 downto 0):="11111101";


begin

stage1: first_stage port map(clk => clk, reset => rst, curr_instr=>irrg1,  pc_next=> pcrg1, pc => pcmem);

reg1: fd_reg port map(clk =>clk, reset=>rst , writevalue=> '1', instr_ip=>irrg1, pc_ip=>pcrg1, instr_op=>irst2, pc_op=>pcst2);

stage_2: stage2 port map(clk =>clk, rst=>rst,controlsigout => sgrg2, pcin=>pcst2, IRip=>irst2, IR15_12=>oprg2, IR11_9=>rarg2, IR8_6=>rbrg2, IR5_3=>rcrg2, IR5_0=>im6rg2, IR8_0=>im9rg2, pcout=>pcrg2, IR1_0=>cdrg2,IR_c => fliprg2);

reg2: dr_reg port map(clk=>clk, reset=>rst, writevalue => sgrg2(5),controlsigin => sgrg2, controlsigout =>sgst3 ,flipin => fliprg2,flipout => flipst3, ra_ip=>rarg2, rb_ip=>rbrg2, rc_ip=>rcrg2, opcode_ip=>oprg2, cond_ip=>cdrg2, imm6_ip=>im6rg2, imm9_ip=>im9rg2, pc_ip=>pcrg2, ra_op=>rast3, rb_op=>rbst3, rc_op=>rcst3, opcode_op=>opst3, cond_op=>cdst3, imm6_op=>im6st3, imm9_op=>im9st3, pc_op=>pcst3);

stage_3: stage3 port map(clk=>clk, rst=>rst, pcfetch => pcrg1, controlsigin => sgst3, controlsigout => sgrg3,flipin => flipst3,flipout => fliprg3,ratemp1 => rast3,ratemp2 => rbst3,raout1 =>tempa,raout2 => tempb, readvalue => sgst3(7),writevalue => reg_en_rf, mux1=>rast3, mux2=>rbst3, mux3=>rcrf, rcin=>rcst3, opin=>opst3, imm6in=>im6st3, imm9in=>im9st3, regvalue=>data_rf, pcin=>pcst3, condin=>cdst3, regouta=>regval1, regoutb=>regval2, rcout=>rcrg3, opout=>oprg3, imm6out=>im6rg3, imm9out=>im9rg3, condout=>cdrg3, pcout=>pcrg3);

reg3: re_reg port map(clk=>clk, reset=>rst,controlsigin => sgrg3, controlsigout =>sgst4 ,flipin => fliprg3,ratemp1 => tempa,ratemp2 => tempb, raforw1 => fwra, raforw2 => fwrb,flipout => flipst4, writevalue => sgrg3(4), reg1_ip=>aluinp1, reg2_ip=>aluinp2, reg3_add_ip=>rcrg3, opcode_ip=>oprg3, imm6_ip=>im6rg3, imm9_ip=>im9rg3, pc_ip=>pcrg3, cond_ip=>cdrg3, reg1_op=>rg1st4, reg2_op=>rg2st4, reg3_add_op=>rcst4, opcode_op=>opst4, imm6_op=>im6st4, imm9_op=>im9st4, pc_op=>pcst4, cond_op=>cdst4);

stage4: stage_4 port map(clk=>clk, reset=>rst,controlsigin =>sgst4, controlsigout => sgrg4 ,reg1_ip=>rg1st4,flipin => flipst4, reg2_ip=>rg2st4, reg3_add_ip=>rcst4, opcode_ip=>opst4, imm6_ip=>im6st4, imm9_ip=>im9st4, pc_ip=>pcst4, cond_ip=>cdst4, Rareg_ip=>rg1st4, alu_op=>alumux, cond_op=>cdrg4, carry_op=>crg4, zero_op=>zrg4, eq_op=>eqrg4, lt_op=>ltrg4, reg3_add_op=>rcrg4, opcode_op=>oprg4, Rareg_op=>addrg4, pc_op=>pcrg4, pcup=>pcup);

reg4: em port map(clk=>clk, reset=>rst,controlsigin =>sgrg4 , controlsigout => sgst5, writevalue => sgrg4(3), alu_outip=>alrg4, pc_in=>pcrg4, rc_add_in=>rcrg4, ra_data_in=>addrg4, z_in=>zrg4, c_in=>crg4, cond_in=>cdrg4, opcode_in=>oprg4, alu_outop=>alst5, pc_op=>pcst5, rc_add_op=>rcst5, ra_data_op=>addst5, z_op=>zst5, c_op=>cst5, cond_op=>cdst5, opcode_op=>opst5);

stage_5: stage5 port map(clk=>clk, rst=>rst,controlsigin =>sgst5 , controlsigout =>sgrg5 , regadd_in=>addst5, aluin=>alst5, aluout=>alrg5, rcin=>rcst5, rcout=>rcrg5, zin=>zst5, zout=>zrg5, cin=>cst5, cout=>crg5, opin=>opst5, opout=>oprg5, pcin=>pcst5, pcout=>pcrg5, condin=>cdst5, condout=>cdrg5);

reg5: mw_reg port map(clk=>clk, reset=>rst,controlsigin => sgrg5, controlsigout =>sgst6 , writevalue => sgrg5(2), alu_ip=>alrg5, reg3_add_ip=>rcrg5, zero_ip=>zrg5, carry_ip=>crg5, opcode_ip=>oprg5, pc_ip=>pcrg5, cond_ip=>cdrg5, alu_op=>alst6, reg3_add_op=>rcst6, zero_op=>zst6, carry_op=>cst6, opcode_op=>opst6, pc_op=>pcst6, cond_op=>cdst6);

stage_6: stage6 port map(clk=>clk, reset=>rst, controlsigin => sgst6, controlsigout => sgrf, reg3_add_ip=>rcst6, zero_ip=>zst6, carry_ip=>cst6, cond_ip=>cdst6, pc_ip=>pcst6, opcode_ip=>opst6, alu_ip=>alst6, reg3_add_op=>rcrf, reg_enable=>reg_en_rf, data_op=>data_rf);

-- mux1 is to choose whether alu or next pc value goes into 
branchcheck : branch port map(opcode => oprg4, eq =>eqrg4 , lt => ltrg4, aluop => alrg4, pcop => pcrg4, alupc => alupc);

mux1: pickone port map(I0=>pcrg1, I1=>alupc, C=>sgrg4(1), Y=>pcmem);

--mux2: chooser4 port map(I0=>rast3, I1=>"000", I2=>rbst3, I3=>rcst4, C=>sel2, Y=>add1);
--
--mux3: chooser4 port map(I0=>rbst3, I1=>"000", I2=>"000", I3=>"000", C=>sel3, Y=>add2);
--
--mux4: chooser4 port map(I0=>rcrf, I1=>"000", I2=>"000", I3=>"000", C=>sel4, Y=>add3);
--
--mux5: chooser4 port map(I0=>data_rf, I1=>"000", I2=>"000", I3=>"000", C=>sel5, Y=>valu);

-- a special for jump instructions to put PC+2 into the alu
muxjump : pickone port map(I0 => pcup,I1 => alumux ,C =>sgrg4(0), Y => alrg4);

-- the forwarding unit to remove data dependency hazards
forwardingunit: forwarder port map(st4in => alumux  , st5in => alrg5,st6in => data_rf, rarr => rast3,rbrr => rbst3 ,rcex => rcst4 ,rcma => rcst5 ,rcwb => rcst6,formux1 =>fsel1, formux2 =>fsel2 ,st4out => fmux1  , st5out => fmux2, st6out => fmux3);

forwardmux1: chooser4 port map(I0=>regval1, I1=>fmux1, I2=>fmux2, I3=>fmux3, C=>fsel1, Y=>aluinp1);

forwardmux2:chooser4 port map(I0=>regval2, I1=>fmux1, I2=>fmux2, I3=>fmux3, C=>fsel2, Y=>aluinp2);

output <= '1';

end architecture;

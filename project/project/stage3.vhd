library ieee;
use ieee.std_logic_1164.all;
-- The following code is for the stage 2 of the pipeline, it contains a 16 bit instruction
-- register and a 16 bit signal for transferring pc.

entity stage3 is
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

end entity;

architecture stage3arch of stage3 is

--	component extend_6_16 is
--	port(input: in std_logic_vector(5 downto 0);
--	     output: out std_logic_vector(15 downto 0));
--   end component;
--
--   component extend_9_16 is
--	port(input: in std_logic_vector(8 downto 0);
--		  output: out std_logic_vector(15 downto 0));
--   end component;
		  
--	component extendzero is
--	port(input: in std_logic_vector(8 downto 0);
--		  output: out std_logic_vector(15 downto 0));
--        end component;

		component regfile is
				  port(
						--to store the register number for each address
						RF_A1 : in std_logic_vector(2 downto 0);
						RF_A2 : in std_logic_vector(2 downto 0);
						RF_A3 : in std_logic_vector(2 downto 0);
						RF_D3 : in std_logic_vector(15 downto 0);
						reset : in std_logic;
						clk : in std_logic;
						writevalue : in std_logic;
						readvalue : in std_logic;
						D1o : out std_logic_vector(15 downto 0);
						D2o : out std_logic_vector(15 downto 0);
						PCIN: in std_logic_vector(15 downto 0);
		  write_pc: in std_logic
				  );
				  end component;
	
	signal ext9imm,ext6imm, extzero,regtempa,regtempb: std_logic_vector(15 downto 0);
	
begin
	

	registerfile : regfile port map(RF_A1 => mux1,RF_A2 => mux2, RF_A3 => mux3, RF_D3 => regvalue,
				reset => rst, clk => clk, writevalue => writevalue, readvalue => readvalue, D1o => regtempa, D2o => regtempb,PCIN => pcfetch, write_pc => '1');
	
	stage3work : process(opin,condin,imm6in,imm9in,rcin,pcin,regtempa,regtempb,ratemp1,ratemp2,controlsigin,flipin,mux1)
	begin
	pcout <= pcin;
	opout <= opin;
	condout <= condin;
	imm6out <= imm6in;
	imm9out <= imm9in;
	imm6out <= imm6in;
	raout1 <= ratemp1;
	raout2 <= ratemp2;
	regouta <= regtempa;
	controlsigout <= controlsigin;
	regoutb <= regtempb;
	flipout <= flipin;
	 if(opin = "0011" or opin="0100" or opin="1100" or opin="1101") then
	  	 rcout <= mux1;
	elsif(opin = "0000") then
		 rcout <= mux2;
	else 
	    rcout <= rcin;
	end if;
end process;	
end stage3arch;

		
		
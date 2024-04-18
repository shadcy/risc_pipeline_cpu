library ieee;
use ieee.std_logic_1164.all;
-- The following code is for the stage 2 of the pipeline, it contains a 16 bit instruction
-- register and a 16 bit signal for transferring pc.

entity stage5 is
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
				controlsigout : out std_logic_vector(7 downto 0));
		
end entity;

architecture struct of stage5 is

		component pickone is
  			port ( I0, I1 : in std_logic_vector(15 downto 0); C : in std_logic; Y : out std_logic_vector(15 downto 0));
		end component;

		component memory is
    		port(clk : in std_logic;
        		wrt_enable : in std_logic;
        		reset : in std_logic;
        		mem_A : in std_logic_vector(15 downto 0);
        		mem_data_in : in std_logic_vector(15 downto 0);
        		mem_data_out : out std_logic_vector(15 downto 0));
			end component;
		
	
signal dataout, mema, memdin, memdout, pc: std_logic_vector(15 downto 0);
signal writeval, c, z : std_logic;
signal op: std_logic_vector(3 downto 0);
signal rc: std_logic_vector(2 downto 0);
signal cond: std_logic_vector(1 downto 0);

begin

	Datamemory : memory port map(clk => clk, wrt_enable => writeval, reset => rst,
								 mem_A => mema, mem_data_in => memdin, mem_data_out => dataout);
								 
	pc <= pcin;
	op <= opin;
	cond <= condin;
	rc <= rcin;
	z<= zin;
	c <= cin;

	stage5work : process(regadd_in, opin,aluin,dataout)
	
	begin

	if((opin = "0101") or (opin = "0111")) then
		memdin <= regadd_in;
		writeval <= '1';
		mema <= aluin;
	elsif((opin="0100") or (opin = "0110")) then
		mema <= aluin;
		writeval <= '0';
		aluout <= dataout;
	else 
		aluout <= aluin;
		writeval <= '0';
	end if;

	end process;
	
	pcout <= pc;
	opout <= op;
	condout <= cond;
	rcout <= rc;
	zout <= z;
	cout <= c;	
	controlsigout <= controlsigin;
end struct;
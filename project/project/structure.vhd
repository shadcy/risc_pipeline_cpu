library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity structure is 
     port(
        state : in std_logic_vector(4 downto 0);
        clk : in std_logic;
        rst : in std_logic;

        opcode : out std_logic_vector(3 downto 0);
        loopcondn: out std_logic;
		  condition: out std_logic_vector(1 downto 0);
        C , Z , eq: out std_logic
    );
end entity;

architecture connection of structure is

    component alu is
        port(
            alu_A: in std_logic_vector(15 downto 0);
            alu_B: in std_logic_vector(15 downto 0);
            Cin: in std_logic;
            sel: in std_logic;
            enable: in std_logic;
            alu_out: out std_logic_vector(15 downto 0);
            Cout: out std_logic;
            Z: out std_logic
        );
    end component;

    component tempreg is
        port(
            regin : in std_logic_vector(15 downto 0); -- input value into the register
            regout : out std_logic_vector(15 downto 0); -- output the value stored in the register
            clk : in std_logic;
            rst : in std_logic;
            writevalue : in std_logic 
            );
    end component;

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
            D2o : out std_logic_vector(15 downto 0)
        );
        end component;


        component extend_6_16 is
	port(input: in std_logic_vector(5 downto 0);
	     output: out std_logic_vector(15 downto 0));
        end component;

        component extend_9_16 is
	port(input: in std_logic_vector(8 downto 0);
		  output: out std_logic_vector(15 downto 0));
        end component;

        component seq_ex is
	port(input: in std_logic_vector(8 downto 0);
		  output: out std_logic_vector(15 downto 0));
        end component;
        
        component memory is 
       port(clk : in std_logic;
        wrt_enable : in std_logic;
        reset : in std_logic;
        mem_A : in std_logic_vector(15 downto 0);
        mem_data_in : in std_logic_vector(15 downto 0);
		  mem_data_out : out std_logic_vector(15 downto 0));
        end component;

        component priorityencoder is
        port( inp: in std_logic_vector(7 downto 0);
		outp: out std_logic_vector(2 downto 0);
		loopcondn: out std_logic);
        end component;

        component decoder is
	port(input: in std_logic_vector(2 downto 0);
		  output: out std_logic_vector(8 downto 0));
        end component;
        
        component comparator is 
		  port(
            A : in std_logic_vector(15 downto 0); 
            B : in std_logic_vector(15 downto 0); 
            equal : out std_logic 
       );
		end component;

signal A1, A2, A3, PEout, decin: std_logic_vector(2 downto 0);
signal R7curr, ir, inshft, shftout, seqex, se10out, se7out, se7out2, D3, inMemA, inMemD, Memo, RFD1, RFD2,intr0, intr1, intr2, intr3,tr0o,tr1o,tr2o,tr3o, ALUo, irout, rfin, cnt , Ain, Bin: std_logic_vector(15 downto 0) := (others => '0');
signal enbl : std_logic_vector(7 downto 0) := "00000000";
signal decout : std_logic_vector(8 downto 0);
signal Cin, carry, eqcomp, loopcond, zero, alusel, readen : std_logic;

begin
Tempregister0: tempreg port map(regin => intr0, clk => clk, writevalue => enbl(7), rst => rst, regout => tr0o); -- T0
Tempregister1: tempreg port map(regin => intr1, clk => clk, writevalue => enbl(6), rst => rst, regout => tr1o); -- T1
Tempregister2: tempreg port map(regin => intr2, clk => clk, writevalue => enbl(5), rst => rst, regout => tr2o); --T2
Tempregister3: tempreg port map(regin => intr3, clk => clk, writevalue => enbl(4), rst => rst, regout => tr3o); --T3

ALUmachine : alu port map(alu_A => Ain, alu_B => Bin, Cin => Cin, enable => enbl(3),
									sel => alusel, alu_out => ALUo, Cout => carry, Z => zero);
									
Registerfile : regfile port map(RF_A2 => A2, RF_A1 => A1, RF_A3 => A3, RF_D3 => rfin, writevalue => enbl(2), 
											readvalue => readen, clk => clk, reset => rst,  D1o  => RFD1, D2o => RFD2);
											
Instrucreg : tempreg port map(regin => ir, clk => clk,writevalue => enbl(1), rst => rst, regout => irout);

mem : memory port map(mem_A => inMemA, mem_data_in => inMemD, clk => clk, reset => rst, wrt_enable => enbl(0), mem_data_out => Memo);

Signextender10bit : extend_6_16 port map(input => irout(5 downto 0), output => se10out);

Signextender7bit1 : extend_9_16 port map(input => irout(8 downto 0), output => se7out);


seqextender : seq_ex port map(input => irout(8 downto 0), output => seqex);

prienc : priorityencoder port map(inp(7) => tr2o(0), inp(6) => tr2o(1), inp(5) => tr2o(2), inp(4) => tr2o(3),
                                    inp(3) => tr2o(4), inp(2) => tr2o(5),inp(1) => tr2o(6), inp(0) => tr2o(7), 
                                    outp => PEout, loopcondn => loopcond);
												
dec : decoder port map(input => decin, output => decout);

Signextender7bit2 : extend_9_16 port map(input => decout, output => se7out2);

Comparer : comparator port map(A => tr1o, B => tr2o, equal => eqcomp);

process(state, ALUo, RFD1, RFD2, irout, tr0o, tr1o, tr2o, tr3o, se10out, seqex, shftout, R7curr, Memo, se7out, PEout, se7out2)
	begin	
		case state is 
			when "00001" => --s1
				A1 <= "111";  --r7 to memA and alu and aluout to temp reg for pc
            readen <= '1';
				inMemA <= RFD1;
				ir <= Memo;
				R7curr <= RFD1;
            Ain <= RFD1;
            Bin <= "0000000000000001";
				alusel <= '0';
				Cin <= '0';
            intr3 <= ALUo;
				enbl <= "00010010";
			when "00010" => --s2
				A1 <= irout(11 downto 9); --rega to t1 and regb to t2
            A2 <= irout(8 downto 6);
            readen <= '1';
				intr1 <= RFD1;
				intr2 <= RFD2;
				enbl<= "01100000";
			when "00011" => --s3
				Ain <= tr1o;  --t1 and t2 to alu and aluout to t0
				Cin <= '0';
				Bin <= tr2o;
            alusel <= irout(13);
            intr0 <= ALUo;
				enbl<= "10001000";
				readen <= '0';
				
			when "00100" => --s4
				A3 <= irout(5 downto 3);
				rfin <= tr0o;     --t0 to regc
				readen <= '0';
				enbl<= "00000100"; 
				
			when "00101" => --s5
            rfin <= tr3o;  --pc to reg7
            A3 <= "111";	
				readen <= '0';
				enbl<= "00000100"; 
				
			when "00110" => --s6
				A1 <= irout(11 downto 9);
				readen <= '1';   --regA to t1, ir 5 downto 0 to se to t2
				intr1 <= RFD1;
				intr2 <= se10out;   -- next state is s3 where t1 and t2 are added because ir13 for this state is 0
				enbl<= "01100000";
				
			when "00111" => --s7
				A3 <= irout(8 downto 6);
            rfin <= tr0o;
            readen <= '0'; --t0 to reg b
            enbl<= "00000100";
				
			when "01000" => --s8
				A3 <= irout (11 downto 9);
            rfin <= seqex; --imm 9 bits extended with 0's and then shifted by 7 bits and sent to regA
				readen <= '0';
				enbl<= "00000100";
                
			when "01001" => --s9
			   rfin <= R7curr;
				A3 <= irout(11 downto 9);
            A2 <= irout(8 downto 6); --R7 given to regA and regB is the new PC
            readen <= '1';
				intr3 <= RFD2 ;
				enbl<= "00010100";
				
			when "01010" => --s10
				A2 <= irout(8 downto 6);
				readen <= '1';
				intr2 <= RFD2;
				intr1 <= se10out;  --ir 5 downto 0 sent to signed extender and sent to t1, next state is s3
				enbl<= "01100000"; 
                
			when "01011" => --s11
				inMemA <= tr0o;
				intr1 <= Memo;
				readen <= '0';  --aluout is sent to t0 which is sent to memA and memDout is sent to t1
				enbl<= "01000001";
		
			when "01100" => --s12
				Ain <= tr1o;
				Bin <= "0000000000000000";
				Cin <= '0';
				alusel <= '0';
				rfin <= tr1o;
            A3 <= irout(11 downto 9); --t1 to D3 in regA and it modifies z flag also
				enbl<= "00000100";
				readen <= '0';
				
			when "01101" => --s13
				inMemD <= tr1o; --aluout to t0 to mem add and regA content to mem data ip
				inMemA <= tr0o;
				enbl<= "00000001";
				readen <= '0';
				
			when "01110" => --s14
				intr2 <= se7out;
            A1 <= irout(11 downto 9);
				readen <= '1'; --ir 8-0 to t2 and reg A to T1
				intr1 <= RFD1;
				enbl<= "01100000";
				
			when "01111" => --s15
				 inMemA <= tr1o;
				 Ain <= tr1o;
				 Bin <= "0000000000000001";
				 Cin <= '0';
				 alusel <= '0';
				 intr0 <= ALUo;  --memdata sent to corresponding registers
				 rfin <= Memo;
				 A3 <= PEout;
				 readen <= '0';
				 enbl <= "10000100";
				 
			when "10000" => --s16
				intr1 <= tr0o;
            decin <= PEout;
            Ain <= se7out2;
				Bin <= tr2o;
				Cin <= '0'; --to find out which register is to be filled next
				alusel <= '0';
            intr0 <= ALUo;
				enbl <= "11000000";
				readen <= '0';

			when "10001" => --s17
            intr2 <= tr0o;
				enbl <= "00100000";
				readen <= '0'; --t0 to t2 which then goes back to the previous state
                
         when "10010" => --s18
				Ain <= R7curr;
				Bin <= se10out;
				Cin <= '0';
				alusel <= '0'; --if compeq then r7 + imm to t3 
				intr3 <= ALUo;
				enbl <= "00010000";
				readen <= '0';
          
			when "10011" => --s19
            Ain <= R7curr;
				rfin <= R7curr;
				A3 <= irout(11 downto 9);
				Bin <= se7out;
				Cin <= '0';  --r7 + imm to pc and r7 to regA
				alusel <= '0';
				intr3 <= ALUo;
				enbl <= "00010100";
				readen <= '0';
			
			when "10100" => --s20
				Ain <= tr1o;
				Bin <= "0000000000000001";
				Cin <= '0';
				alusel <= '0';
				intr0 <= ALUo;  --regdata from corresponding registers sent to mem
				A2 <= PEout;
				readen <= '1';
				inMemD <= RFD2;
				inMemA <= tr1o;
				 enbl <= "10000001";
				 
			when others => --s21 is a dummy state so nothing happens there
				enbl <= "00000000";
				readen <= '0';
			
		end case;
	end process;
	
	opcode <= irout(15 downto 12);
	condition <= irout(1 downto 0);
	C <= carry;
	Z <= zero;
	eq <=eqcomp;
   loopcondn <= loopcond;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priorityencoder is
port( inp: in std_logic_vector(7 downto 0);
		outp: out std_logic_vector(2 downto 0);
		loopcondn: out std_logic);
end priorityencoder;

architecture bhv of priorityencoder is

signal outp1 : std_logic_vector(2 downto 0);

begin

encodingproc: process(inp)

	begin
	
		if(inp(7)='1') then 
		outp1<="000";
		loopcondn<='1';
		elsif(inp(6)='1') then
		outp1<="001";
		loopcondn<='1';
		elsif(inp(5)='1') then
		outp1<="010";
		loopcondn<='1';
		elsif(inp(4)='1') then
		outp1<="011";
		loopcondn<='1';
		elsif(inp(3)='1') then
		outp1<="100";
		loopcondn<='1';
		elsif(inp(2)='1') then
		outp1<="101";
		loopcondn<='1';
		elsif(inp(1)='1') then
		outp1<="110";
		loopcondn<='1';
		elsif(inp(0)='1') then
		outp1<="111";
		loopcondn<='1';
		else 
		loopcondn<='0';
		outp1<= "000";
		
		end if;
		
end process;

outp <= outp1;

end bhv;

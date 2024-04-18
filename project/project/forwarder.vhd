library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity forwarder is
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
end forwarder;

architecture forwarding of forwarder is
 
signal ra,rb,rc3,rc4,rc5 : std_logic_vector(2 downto 0);
signal st4,st5,st6: std_logic_vector(15 downto 0);

begin
	ra <= rarr;
   rb <= rbrr;
	rc3 <= rcex;
	rc4 <= rcma;
	rc5 <= rcwb;
	st4 <= st4in;
	st5 <= st5in;
	st6 <= st6in;
	
	forwardproc : process(ra,rb,rc3,rc4,rc5,st4,st5,st6)
	
	begin
	-- we put forwarding logic for add
	--if two register addresses in the RR and further stages are equal 
	--then data needs to be forwarded
	
	if (ra = rc3) then -- forwarding if ra comes out equal to rc
		formux1 <= "01";
	elsif (ra = rc4) then
		formux1 <= "10";
	elsif (ra = rc5) then
		formux1 <= "11";	
	else formux1 <= "00";
	end if;
	
	if (rb = rc3) then -- forwarding if rb comes equal to rc
		formux2 <= "01";
	elsif (rb = rc4) then
		formux2 <= "10";
	elsif (rb = rc5) then
		formux2 <= "11";	
	else formux2 <= "00";
	end if;
	
	st4out <= st4; -- simply pushing the forwarding values to the muxes which decide which value goes into alu
	st5out <= st5;
	st6out <= st6;
	
	end process;
	
end forwarding;
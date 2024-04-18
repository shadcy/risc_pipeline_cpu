library ieee;
use ieee.std_logic_1164.all;

entity chooser2 is
  port ( I0, I1 : in std_logic_vector(15 downto 0); C : in std_logic; Y : out std_logic_vector(15 downto 0));
end entity chooser2;

architecture Struct of chooser2 is
 
 
begin
  -- component instances
  muxprocess : process(I1,I0,C)
   begin
	if (C = '1') then
		Y <= I1;
	else 
		Y <= I0;
end if;
end process;
end Struct;
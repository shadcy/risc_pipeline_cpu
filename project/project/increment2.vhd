library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity incrementer2 is
    port(
         orgval : in std_logic_vector(15 downto 0); 
			incvalue: out std_logic_vector(15 downto 0)
         
    );     
end incrementer2;

architecture bhv of incrementer2 is
 
begin

incvalue <= orgval or "0000000000000010";

end bhv;
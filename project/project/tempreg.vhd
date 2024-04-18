library ieee;
use ieee.std_logic_1164.all;
-- A temporary register to store values coming out of ALU and reg file
entity tempreg is
    port(
        regin : in std_logic_vector(15 downto 0); -- input value into the register
        regout : out std_logic_vector(15 downto 0); -- output the value stored in the register
        clk : in std_logic;
        rst : in std_logic;
        writevalue : in std_logic);
end entity ;

architecture arcreg of tempreg is 
    signal regvalue : std_logic_vector(15 downto 0);

begin

        regvalue <= regin when writevalue='1';

output_proc : process(regin,rst,writevalue,clk)
begin
    if (rst='1') then 
        regout <= "0000000000000000";
    elsif (clk'event and clk='0') then 
        regout <= regvalue;
    end if;
end process output_proc;
end arcreg;
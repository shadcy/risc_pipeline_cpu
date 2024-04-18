library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity read_memory is
    port(
        mem_A : in std_logic_vector(15 downto 0);

        mem_data_out : out std_logic_vector(15 downto 0));
    
end entity;

architecture behav of read_memory is
	
	type data_array is
		array(0 to 65536) of std_logic_vector(15 downto 0);

signal data : data_array := (0 => "0001001010011000",1 => "0001001011100000", 2 => "0000000000000000", 3 => "0000000000000000", 4 => "0011001100110010", others => ( others => '0'));
begin 
mem_data_out <= data(to_integer(unsigned(mem_A)));
end behav;

	
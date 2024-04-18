library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port(clk : in std_logic;
        wrt_enable : in std_logic;
        reset : in std_logic;
        mem_A : in std_logic_vector(15 downto 0);
        mem_data_in : in std_logic_vector(15 downto 0);

        mem_data_out : out std_logic_vector(15 downto 0));
    
end entity;

architecture behav of memory is
	
	type data_array is
		array(0 to 65536) of std_logic_vector(15 downto 0);
	
	signal data : data_array := (0 => "0000101010101000", 1 => "0010000100011001", 2 => "0001011001011010", 3 => "0100101110100000", others => ( others => '0'));
	
	begin
	
		data_assign_proc : process(clk)
		
			begin
				
				if (clk 'event and clk = '0') then
					if(wrt_enable = '1') then
						data(to_integer(unsigned(mem_A))) <= mem_data_in;
					end if;
				end if;
			end process;
		
		mem_data_out <= data(to_integer(unsigned(mem_A)));

end behav;

	
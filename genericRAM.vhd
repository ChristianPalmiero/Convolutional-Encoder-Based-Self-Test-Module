library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity genericRAM is
generic ( width: integer:=8;        --Data size
			 depth: integer:=16384;     --# cells
			 addr: integer:=14);
port ( clock: in std_logic;
		 enable: in std_logic;
		 w: in std_logic;
		 r: in std_logic;
		 address: in std_logic_vector (addr-1 downto 0);
		 data_in: in std_logic_vector (width-1 downto 0);
		 data_out: out std_logic_vector (width-1 downto 0)
		 );
end genericRAM;

architecture Behavioral of genericRAM is

type RAM_type is array(0 to depth-1) of std_logic_vector(width-1 downto 0);
signal content: RAM_type;

begin
--Read process with a synchronous behavior
	process(clock, r)
	begin
		if(clock'event and clock='1') then
			if(enable='1') then
				if(R='1') then
					Data_out <= content(conv_integer(address));
				else
					Data_out <= (Data_out'range => 'Z');
				end if;
			else
				Data_out <= (Data_out'range => 'Z');
			end if;
		end if;
	end process;
	
--Write process with a synchronous behavior
	process(clock, w)
	begin
		if(clock'event and clock='1') then
			if(enable='1') then
				if(w='1') then
					content(conv_integer(address)) <= Data_in;
				end if;
			end if;
		end if;
	end process;

end Behavioral;
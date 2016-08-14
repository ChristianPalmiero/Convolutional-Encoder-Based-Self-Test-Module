library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.textio.all;

entity genericROM is
generic ( width: integer:=8;        --Data size
			 depth: integer:=32768;     --# cells
			 addr: integer:=15);
port ( clk: in std_logic;
		 enable: in std_logic;
		 address: in std_logic_vector (addr-1 downto 0);
		 data_out: out std_logic_vector (width-1 downto 0)
		 );
end genericROM;

architecture Behavioral of genericROM is

type ROM_type is array(natural range 0 to depth-1) of std_logic_vector(width-1 downto 0);
signal content: ROM_type;

begin

   VectorProcess: PROCESS
	FILE vectorfile: text;
	VARIABLE inputline: line;
	VARIABLE inputbit: bit;
	variable addr: integer :=0;
	BEGIN
		file_open(vectorfile,"vectors2.txt",read_mode);
		FOR j in 0 to depth-1 LOOP
			readline(vectorfile, inputline);
			FOR i IN 0 to width-1 LOOP
				read(inputline, inputbit);
				if inputbit = '1' then
					content(addr)(width-1-i)<= '1';
				else 
					content(addr)(width-1-i)<='0';
				end if;
				--wait for 1 ps;
			end loop;
			addr:=addr+1;
			wait for 1 ps;
		end loop;
		file_close(vectorfile);
		WAIT;
	END PROCESS;

--Read process with a synchronous behavior
	process(clk)
	begin
		if(clk'event and clk='1') then
			if(enable='1') then
					Data_out <= content(conv_integer(address));
			else
					Data_out <= (Data_out'range => 'Z');
			end if;
		end if;
	end process;

end Behavioral;
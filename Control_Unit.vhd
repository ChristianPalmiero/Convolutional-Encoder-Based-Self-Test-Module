library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity control_unit is
generic ( width: integer:=8;
			 addr: integer:=15);
port (
		clk: in std_logic;
		power_on: in std_logic;
		rom_outdata: in std_logic_vector (width-1 downto 0);
		m_tvalid: in std_logic;
		s_tready: in std_logic;
		core_outdata: in std_logic_vector (width-1 downto 0);
		rom_enable: out std_logic;
		core_indata: out std_logic_vector(width-1 downto 0);
		s_tvalid: out std_logic;
		core_enable: out std_logic;
		core_reset: out std_logic;
		rom_addr: out std_logic_vector (addr-1 downto 0);
		ram_enable: out std_logic;
		ram_w: out std_logic;
		ram_r: out std_logic;
		ram_address: out std_logic_vector (addr-2 downto 0);
		ram_data_in: out std_logic_vector (width-1 downto 0);
		ram_data_out: in std_logic_vector (width-1 downto 0);
		ok_status: out std_logic;
		fault_status: out std_logic;
		debug_port: out std_logic_vector (width-1 downto 0);
		number_of_errors: out std_logic_vector (addr-1 downto 0)
		);
end control_unit;

architecture Behavioral of control_unit is
	type state_type is (S0, s1, s2, s3, s4, s_end, ok, ok_two, fault, fault_two, debug, debug_two, sWait1, sWait2);
	signal nextstate, currstate: state_type;
	signal int_rom_addr: std_logic_vector (addr-1 downto 0);
	signal int_ram_addr: std_logic_vector (addr-2 downto 0):=(others=>'1');
	signal cnt: std_logic_vector (addr-1 downto 0);
	signal allOnes: std_logic_vector (addr-2 downto 0):=(others=>'1');
	begin
	
	state_proc: process (clk)
	variable start: natural:=0;
	begin 
		if(rising_edge(clk)) then
			if(power_on='1') then
				currstate<=S0;
				start:=1;
			else
				if (start=1) then
					currstate<=nextstate;
				end if;
			end if;
		end if;
	end process;

	func_proc: process (currstate)
	--7463 = sup (50 us/6.7 ns)
	variable ok_cnt: natural range 0 to 7463 := 7463;
	--150 = sup (1 us/6.7 ns)
	variable fault_cnt: natural range 0 to 150 := 150;
	begin
		case currstate is
			--resetting state for the ROM, the RAM and the Core
			when s0 =>
			ok_status <= '0';
			fault_status <= '0';
			rom_enable <= '0';
			ram_enable <= '0';
			ram_r <= '0';
			ram_w <= '0';
			core_reset <= '0';
			s_tvalid <= '1';
			core_enable <= '1';
			int_rom_addr <= (int_rom_addr'range => '0');
			cnt <= (cnt'range => '0');
			int_ram_addr <= (int_ram_addr'range => '1');
			core_indata <= (core_indata'range => 'Z');
			ram_data_in <= (ram_data_in'range => 'Z');
			debug_port <= (debug_port'range => 'Z');
			number_of_errors <= (number_of_errors'range => 'Z');
			nextstate <= sWait1;
			
			--aresetn needs to be asserted low for at least two clock cycles to initialize the circuit. 
			--The core becomes ready for normal operation two cycles after aresetn goes high if aclken is high.
			when sWait1 =>
			core_reset<='1';
			nextstate <= sWait2;
			
			when sWait2 =>
			rom_enable <= '1';
			ram_enable <= '1';
			nextstate <= s1;
			
			when s1 =>
			ram_w<='0';
			s_tvalid <= '1';
			int_rom_addr <= int_rom_addr + ('1'&not(allOnes)) - 1;
			if (int_rom_addr = (('1'&not(allOnes))+1)) then
				nextstate <= s4;
				s_tvalid <= '0';
			elsif (int_rom_addr = ('1'&not(allOnes))) then
				s_tvalid <= '0';
				nextstate <=s2;
			else
				nextstate <= s2;
			end if;
			
			when s2 =>
			if(m_tvalid='1' and int_rom_addr>((not(allones)&'1'))) then
				if(rom_outdata/=core_outdata) then
					cnt<=cnt+1;
					ram_w<='1';
					int_ram_addr<=int_ram_addr+1;
				end if;
			end if;
			s_tvalid <= '0';
			int_rom_addr <= int_rom_addr + 2 - ('1'&not(allOnes));
			nextstate <= s3;
			
			when s3 =>
			nextstate <= s1;
			
			when s4 =>
			--s_tvalid <= '0';
			rom_enable<='0';
			core_enable <= '0';
			if(cnt = (cnt'range=>'0')) then
				nextstate <= ok;
				ok_status <= '1';
			else
				nextstate <= fault;
				number_of_errors<=cnt;
				fault_status <= '1';
			end if;	
			
			when ok =>
			ok_cnt:= ok_cnt - 1;
			if(ok_cnt=0) then
				nextstate <= s_end;
				ok_status <= '0';
			else
				nextstate <= ok_two;
			end if;
			
			when ok_two =>
			ok_cnt:= ok_cnt - 1;
			nextstate <= ok;
			
			when fault =>
			fault_cnt:= fault_cnt - 1;
			nextstate <= fault_two;
			
			when fault_two =>
			fault_cnt:= fault_cnt - 1;
			if(fault_cnt=0) then
				nextstate <= debug;
				int_ram_addr <= (int_ram_addr'range => '0');
				ram_r<='1';
				number_of_errors <= (number_of_errors'range => 'Z');
			else
				nextstate <= fault;
			end if;
			
			when debug =>
			if(int_ram_addr=cnt-1) then
				nextstate <= s_end;
				ram_r <= '0';
			else
				nextstate <= debug_two;
				int_ram_addr <= int_ram_addr + 1;
			end if;
			
			when debug_two =>
				if(int_ram_addr=cnt-1) then
					nextstate <= s_end;
					ram_r <= '0';
				else
					nextstate <= debug;
					int_ram_addr <= int_ram_addr + 1;
				end if;
			
			when s_end =>
			fault_status <= '0';
			rom_enable <= '0';
			ram_enable <= '0';
			int_rom_addr <= (int_rom_addr'range => '0');
			int_ram_addr <= (int_ram_addr'range => '0');
			ram_data_in <= (ram_data_in'range => 'Z');
			nextstate <= s_end;
			
			when others =>
			nextstate <= s_end;
		end case;
		ram_data_in<=core_outdata;
	end process;
	core_indata<=rom_outdata;
	ram_address<=int_ram_addr;
	rom_addr<=int_rom_addr;
	debug_port<=ram_data_out;
	end Behavioral;
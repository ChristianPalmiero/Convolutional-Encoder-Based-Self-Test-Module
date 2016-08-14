library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_entity is
generic ( width: integer:=8;
			 addr: integer:=15);
Port ( 
		clk: in std_logic;
		power_on: in std_logic;
		ok_status: out std_logic;
		fault_status: out std_logic;
		debug_port: out std_logic_vector (width-1 downto 0);
		number_of_errors: out std_logic_vector (addr-1 downto 0)
		);
end top_entity;

architecture struct of top_entity is

component genericROM is
generic ( width: integer:=8;        --Data size
			 depth: integer:=32768;     --# cells
			 addr: integer:=15);
port ( clk: in std_logic;
		 enable: in std_logic;
		 address: in std_logic_vector (addr-1 downto 0);
		 data_out: out std_logic_vector (width-1 downto 0)
		 );
end component;

component genericRAM is
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
end component;

component control_unit is
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
end component;

component convolution_v8_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC
  );
END component;
signal rom_enable, core_reset, core_enable, s_tvalid, m_tvalid, s_tready, ram_enable, ram_r, ram_w: std_logic;
signal rom_outdata, core_indata, core_outdata, ram_data_in, ram_data_out: std_logic_vector(7 downto 0);
signal rom_addr: std_logic_vector(14 downto 0);
signal ram_address: std_logic_vector(13 downto 0); 

begin
cu: control_unit port map (clk, power_on, rom_outdata, m_tvalid, s_tready, core_outdata, 
rom_enable, core_indata, s_tvalid, core_enable, core_reset, rom_addr, ram_enable, ram_w, 
ram_r, ram_address, ram_data_in, ram_data_out, ok_status, fault_status, debug_port, number_of_errors);
rom: genericRom port map (clk=>clk,enable=>rom_enable,address=>rom_addr, data_out=>rom_outdata);
encoder: convolution_v8_0 port map (aclk=>clk, aresetn=>core_reset, aclken=>core_enable, 
s_axis_data_tdata=> core_indata, s_axis_data_tvalid=>s_tvalid, s_axis_data_tready=>s_tready, 
m_axis_data_tdata=>core_outdata, m_axis_data_tvalid=>m_tvalid);
ram: genericRam port map (clock=>clk, enable=>ram_enable, w=> ram_w, r=> ram_r, 
address => ram_address, data_in => ram_data_in, data_out => ram_data_out);
end struct;
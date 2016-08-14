-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
  COMPONENT top_entity is
  generic ( width: integer:=8;
				 addr: integer:=15);
  Port ( 
		clk: in std_logic;
		power_on: in std_logic;
		ok_status: out std_logic;
		fault_status: out std_logic;
		debug_port: out std_logic_vector (width-1 downto 0);
		number_of_errors: out std_logic_vector (addr-1 downto 0));
  end component;

  --Inputs
   signal power_on : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
	signal ok_status : std_logic;
   signal fault_status : std_logic;
	signal debug_port : std_logic_vector (7 downto 0);
	signal number_of_errors: std_logic_vector (14 downto 0);
	
	-- Clock period definitions
   constant clk_period : time := 6.7 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_entity PORT MAP (
          clk => clk,
          power_on => power_on,
          ok_status => ok_status,
			 fault_status => fault_status,
          debug_port => debug_port,
			 number_of_errors => number_of_errors
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		power_on <= '0';
		wait for 10 us;
		power_on <='1';
		wait for 2 us;
		power_on <='0';
		wait;
   end process;

END;

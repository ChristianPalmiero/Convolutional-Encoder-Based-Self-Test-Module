--------------------------------------------------------------------------------
--    This file is owned and controlled by Xilinx and must be used solely     --
--    for design, simulation, implementation and creation of design files     --
--    limited to Xilinx devices or technologies. Use with non-Xilinx          --
--    devices or technologies is expressly prohibited and immediately         --
--    terminates your license.                                                --
--                                                                            --
--    XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY    --
--    FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY    --
--    PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE             --
--    IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS      --
--    MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY      --
--    CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY       --
--    RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY       --
--    DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE   --
--    IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR          --
--    REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF         --
--    INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A   --
--    PARTICULAR PURPOSE.                                                     --
--                                                                            --
--    Xilinx products are not intended for use in life support appliances,    --
--    devices, or systems.  Use in such applications are expressly            --
--    prohibited.                                                             --
--                                                                            --
--    (c) Copyright 1995-2015 Xilinx, Inc.                                    --
--    All rights reserved.                                                    --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- You must compile the wrapper file convolution_v8_0.vhd when simulating
-- the core, convolution_v8_0. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
LIBRARY XilinxCoreLib;
-- synthesis translate_on
ENTITY convolution_v8_0 IS
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
END convolution_v8_0;

ARCHITECTURE convolution_v8_0_a OF convolution_v8_0 IS
-- synthesis translate_off
COMPONENT wrapped_convolution_v8_0
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
END COMPONENT;

-- Configuration specification
  FOR ALL : wrapped_convolution_v8_0 USE ENTITY XilinxCoreLib.convolution_v8_0(behavioral)
    GENERIC MAP (
      C_CONSTRAINT_LENGTH => 9,
      C_CONVOLUTION_CODE0 => 369,
      C_CONVOLUTION_CODE1 => 491,
      C_CONVOLUTION_CODE2 => 157,
      C_CONVOLUTION_CODE3 => 0,
      C_CONVOLUTION_CODE4 => 0,
      C_CONVOLUTION_CODE5 => 0,
      C_CONVOLUTION_CODE6 => 0,
      C_DUAL_CHANNEL => 0,
      C_HAS_ACLKEN => 1,
      C_HAS_M_AXIS_DATA_TREADY => 0,
      C_OUTPUT_RATE => 3,
      C_PUNCTURED => 0,
      C_PUNC_CODE0 => 0,
      C_PUNC_CODE1 => 0,
      C_PUNC_INPUT_RATE => 1,
      C_PUNC_OUTPUT_RATE => 3
    );
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_convolution_v8_0
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    aclken => aclken,
    s_axis_data_tdata => s_axis_data_tdata,
    s_axis_data_tvalid => s_axis_data_tvalid,
    s_axis_data_tready => s_axis_data_tready,
    m_axis_data_tdata => m_axis_data_tdata,
    m_axis_data_tvalid => m_axis_data_tvalid
  );
-- synthesis translate_on

END convolution_v8_0_a;

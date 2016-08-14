LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Nreg is
GENERIC (N: integer:= 4);
PORT (I: IN std_logic_vector(N-1 DOWNTO 0);
Q: OUT std_logic_vector(N-1 DOWNTO 0);
Clk, Rst: IN std_logic);
END Nreg;

ARCHITECTURE Beh OF Nreg IS
BEGIN
PROCESS (Clk)
BEGIN
IF (Clk= '1' AND Clk'EVENT) THEN
IF (Rst= '1') THEN
Q <= (OTHERS => '0');
ELSE
Q <= I;
END IF;
END IF;
END PROCESS;
END Beh;
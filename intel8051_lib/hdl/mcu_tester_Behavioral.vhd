LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mcu_tester IS
  generic(
    per: time := 50 ns
   );
  PORT (
    clk: out std_logic := '1'
  );
END ENTITY mcu_tester;


ARCHITECTURE Behavioral OF mcu_tester IS
BEGIN
  process
  begin
    
    while now < 10000 ns loop
      clk <= not clk;
      wait for per / 2;
    end loop;
    
    wait;
    
  end process;
END ARCHITECTURE Behavioral;


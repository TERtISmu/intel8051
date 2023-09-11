LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.std_logic_arith.all;
USE IEEE.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY program_counter_register IS
   GENERIC( 
      address_bus_width : integer := 8
   );
   PORT( 
      clk             : IN     std_logic;
      enable          : IN     std_logic;
      command_address : OUT    std_logic_vector (address_bus_width-1 DOWNTO 0) := (others => '0')
   );

END program_counter_register ;


ARCHITECTURE Behavioral OF program_counter_register IS
  SIGNAL command_number : std_logic_vector(address_bus_width-1 DOWNTO 0) := (others => '0');

BEGIN
  
   Process (clk) is
      begin
         if rising_edge(clk) then
            if (enable = '1') then
               command_number <= command_number + 1;
            end if;
         command_address <= command_number;
         end if;
      end process;


END Behavioral;

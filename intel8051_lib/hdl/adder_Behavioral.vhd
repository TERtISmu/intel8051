LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY adder IS
   GENERIC( 
      data_bus_width : integer := 8
   );
   PORT( 
      clk     : IN     std_logic;
      ACC_REG : IN     std_logic_vector (data_bus_width-1 DOWNTO 0);
      TSR     : IN     std_logic_vector (data_bus_width-1 DOWNTO 0);
      opcode  : IN     std_logic_vector (1 DOWNTO 0);
      res     : OUT    std_logic_vector (data_bus_width-1 DOWNTO 0) := x"ZZ"
   );

END adder ;


ARCHITECTURE Behavioral OF adder IS
BEGIN
  
   Process (opcode) is
      variable temp1, temp2, sum: std_logic_vector(data_bus_width downto 0);
      begin
        
         case (opcode) is 
            when "00" => -- ADD
               temp1 := "0" & ACC_REG(7 downto 0);
               temp2 := "0" & TSR(7 downto 0);
               sum := temp1 + temp2;
               res <= sum(data_bus_width-1 downto 0);            
            
            when "ZZ" =>
              res <= x"ZZ";
             
            when others => null;
              
         end case;
         
      end process;

   res <= x"ZZ";

END Behavioral;

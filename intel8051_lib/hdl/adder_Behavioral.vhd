LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY adder IS
   GENERIC( 
      data_bus_width : integer := 8
   );
   PORT( 
      clk        : in     std_logic;
      ACC_REG    : in     std_logic_vector (data_bus_width-1 DOWNTO 0);
      TSR        : in     std_logic_vector (data_bus_width-1 DOWNTO 0);
      opcode     : in     std_logic_vector (1 DOWNTO 0);
      res        : out    std_logic_vector (data_bus_width-1 DOWNTO 0) := x"ZZ";
      carry_flag : out    std_logic := '0'
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
              carry_flag <= sum(8);            
            
            when "01" => -- COMPARE
              if (TSR = ACC_REG) then
	         					res <= "10000000";
				      elsif (TSR < ACC_REG) then
						    carry_flag <= '1';
						    res <= "01111111";
				      else
						    carry_flag <= '0';
						    res <= "01111111";
			       	end if;
			       	
            when "ZZ" =>
              res <= x"ZZ";
             
            when others => null;
              
         end case;
         
      end process;

   res <= x"ZZ";

END Behavioral;

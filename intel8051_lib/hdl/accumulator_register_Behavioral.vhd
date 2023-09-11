LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY accumulator_register IS
  generic(
		data_bus_width: integer := 8
	);
  Port(
    clk : in STD_LOGIC;
    write : in STD_LOGIC;
    read : in STD_LOGIC;
    data_in : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ"; --data to data_bus
    data_out: out STD_LOGIC_VECTOR(data_bus_width-1 downto 0)             --data to adder
  );
END ENTITY accumulator_register;


ARCHITECTURE Behavioral OF accumulator_register IS
  signal ACC_REG_data : STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ";
  
BEGIN
  
  process(clk)
    begin
        if rising_edge(clk) then
          if (write = '1') then
            ACC_REG_data <= data_in;
            data_in <= (others => 'Z');
          elsif (read = '1') then 
            data_in <= ACC_REG_data;
          else
            data_in <= (others => 'Z');
          end if;
        end if;
  end process;
  
  data_out <= ACC_REG_data;
    
END ARCHITECTURE Behavioral;


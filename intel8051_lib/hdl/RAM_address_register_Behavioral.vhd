LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RAM_address_register IS
  generic(
		data_bus_width: integer := 8
	);
  Port(
    clk : in STD_LOGIC;
    write : in STD_LOGIC;
    data_in : in STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ";
    data_out: out STD_LOGIC_VECTOR(data_bus_width-1 downto 0)
  );
END ENTITY RAM_address_register;


ARCHITECTURE Behavioral OF RAM_address_register IS
  signal RAR_data : STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ";
  
BEGIN
  
  process(clk)
    begin
        if rising_edge(clk) then
          if (write = '1') then
            RAR_data <= data_in;
          end if;
        end if;
  end process;
  
  data_out <= RAR_data;
  
END ARCHITECTURE Behavioral;


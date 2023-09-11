LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY accumulator IS
  generic(
		data_bus_width: integer := 8
	);
  Port(
    clk : in STD_LOGIC;
    write : in STD_LOGIC;
    read : in STD_LOGIC;
    data : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ";
    parity_flag: out STD_LOGIC := '0'
  );
END ENTITY accumulator;


ARCHITECTURE Behavioral OF accumulator IS
  signal ACC_data : STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"01";
  
BEGIN
  
  process(clk)
    begin
        if rising_edge(clk) then
          if (write = '1') then
            ACC_data <= data;
            data <= (others => 'Z');
          elsif (read = '1') then 
            data <= ACC_data;
          else
            data <= (others => 'Z');
          end if;
        end if;
    end process;
  
END ARCHITECTURE Behavioral;


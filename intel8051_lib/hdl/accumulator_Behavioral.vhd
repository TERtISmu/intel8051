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
    
    process(ACC_data)
      variable CountOnes : INTEGER;
    begin
        CountOnes := 0;
        for i in ACC_data'range loop
            if ACC_data(i) = '1' then
                CountOnes := CountOnes + 1;
            end if;
        end loop;
        
        if CountOnes mod 2 = 0 then
            parity_flag <= '0'; -- ������ ���������� ������
        else
            parity_flag <= '1'; -- �������� ���������� ������
        end if;
    end process;
  
END ARCHITECTURE Behavioral;


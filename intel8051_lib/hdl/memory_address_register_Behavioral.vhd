LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY memory_address_register IS
  generic(
		address_bus_width: integer := 8
	);
  Port(
        clk : in STD_LOGIC;
        write : in STD_LOGIC;
        read : in STD_LOGIC;
        addr : in STD_LOGIC_VECTOR(address_bus_width-1 downto 0);
        out_addr : out STD_LOGIC_VECTOR(address_bus_width-1 downto 0) := x"ZZ"
  );
END ENTITY memory_address_register;


ARCHITECTURE Behavioral OF memory_address_register IS
  signal reg_addr : STD_LOGIC_VECTOR(address_bus_width-1 downto 0) := x"00";
  
BEGIN
  
  process (clk)
    begin
        if rising_edge(clk) then
          if write = '1' then
            reg_addr <= addr;
            out_addr <= (others => 'Z');
          elsif (read = '1') then 
            out_addr <= reg_addr;
          else
            out_addr <= (others => 'Z');
          end if;
        end if;
    end process;
  
END ARCHITECTURE Behavioral;


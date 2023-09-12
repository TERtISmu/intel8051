LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY ROM IS
  generic(
	  address_bus_width: integer := 8;
	  data_bus_width: integer := 8
  );
  port (
    clk:       in  std_logic;
	  read:      in  std_logic;
	  addr:      in  std_logic_vector(address_bus_width-1 downto 0);
	  data_out:  out std_logic_vector(data_bus_width-1 downto 0) := (others => '0')
  );
END ENTITY ROM;


ARCHITECTURE Behavioral OF ROM IS
  type MEMORY is array (0 to 255) of std_logic_vector(address_bus_width-1 downto 0);
  constant ROM: MEMORY := (
	  "00101100",                          -- ADD A, R4 (1 + E = F)
	  "10000101", "00001010", "00001011",  -- MOV 0x0A, 0x0B (6F <- DE)      
	  "10110110", "00000101", "00001010",  -- CJNE @R0, 0x05, start (0x05 == 0x05)
    "10000101", "00001110", "00001111",  -- MOV 0x0E, 0x0F (25 <- CD)
    "10110111", "00000101", "00001010",  -- CJNE @R1, 0x05, start (0x77 != 0x05)
	  others => "00000000"
  );
  
BEGIN
  
  Process (clk) is
	variable byte_address: integer range 0 to 2**address_bus_width - 1;
	begin
		if rising_edge(clk) then
		  byte_address := conv_integer(addr);
			if (read = '1') then
				data_out <= ROM(byte_address);
			else 
			  data_out <= (others => 'Z');
			end if;
		end if;
	end process;
  
END ARCHITECTURE Behavioral;


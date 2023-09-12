LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY RAM IS
  generic(
	  address_bus_width: integer := 8
  );
  port (
    clk: in std_logic;
    read: in std_logic;
    write: in std_logic;
    addr: in std_logic_vector(7 downto 0);
    data: inout std_logic_vector(7 downto 0) := x"ZZ"
  );
END ENTITY RAM;


ARCHITECTURE Behavioral OF RAM IS
  type MEMORY is array (0 to 255) of std_logic_vector(7 downto 0);
  signal RAM256 : MEMORY;
BEGIN
  
  Process (clk)
    variable byte_number: integer range 0 to 2**address_bus_width - 1;
    variable startup: boolean := true;
  begin
    if (startup = true) then
      RAM256 <= (
           "00001101", -- 00
           "00010000", -- 01
           "00000001", -- 02
           "00000011", -- 03
           "11111111", -- 04 (FF)
           "00001010", -- 05
           "00000100", -- 06
           "00000000", -- 07
           "00000000", -- 08
           "00000001", -- 09
           "01101111", -- 0A
           "11011110", -- 0B
           "00000011", -- 0C
           "00000101", -- 0D
           "00100101", -- 0E
           "11001101", -- 0F
           "01110111", -- 10
            others => "00000000");
      data <= (others => 'Z');
      startup := false;
    elsif rising_edge(clk) then
      byte_number := conv_integer(addr);
      
      if (write = '1') then
        RAM256(byte_number) <= data;
        data <= (others => 'Z');
      elsif (read = '1') then 
        data <= RAM256(byte_number);
      else
        data <= (others => 'Z');
      end if; 
      
    end if;
  end process;
  
END ARCHITECTURE Behavioral;


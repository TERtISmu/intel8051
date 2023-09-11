LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY program_status_word_register IS
  generic(
		data_bus_width: integer := 8
	);
  Port(
    clk : in STD_LOGIC;
    write : in STD_LOGIC;
    read : in STD_LOGIC;
    carry_flag : in STD_LOGIC;
    parity_flag : in STD_LOGIC;
    psw : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0) := x"ZZ"
  );
END ENTITY program_status_word_register;


ARCHITECTURE Behavioral OF program_status_word_register IS
  signal reg_psw : STD_LOGIC_VECTOR(7 downto 0) := x"00";
  
BEGIN
  
  
  
  process(clk)
    begin
        if rising_edge(clk) then
          
          if carry_flag = '1' then
            reg_psw(7) <= '1';
          else
            reg_psw(7) <= '0';
          end if;
          
          if (write = '1') then
            reg_psw <= psw;
            psw <= (others => 'Z');
          elsif (read = '1') then 
            psw <= reg_psw;
          else
            psw <= (others => 'Z');
          end if;
        end if;
  end process;
  
END ARCHITECTURE Behavioral;


LIBRARY ieee;
LIBRARY intel8051_lib;
USE intel8051_lib.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

ENTITY test IS
  generic(
	  address_bus_width: integer := 8;
	  data_bus_width: integer := 8
  );
END ENTITY test;


ARCHITECTURE Behavioral OF test IS
  
  component program_counter_register is
    generic(
		  address_bus_width: integer := 8;
		  data_bus_width: integer := 8
	  );
	  port(
		  clk             : in  std_logic;
		  enable          : in  std_logic;
		  jump            : in  std_logic;
      jump_through    : in  std_logic_vector(data_bus_width-1 DOWNTO 0);
		  command_address : out std_logic_vector(address_bus_width-1 downto 0)
	  );
  end component;
  
  component memory_address_register is
    generic(
    		address_bus_width: integer := 8
   	);
    Port (
      clk : in STD_LOGIC;
      write : in STD_LOGIC;
      read : in STD_LOGIC;
      addr : in STD_LOGIC_VECTOR(address_bus_width-1 downto 0);
      out_addr : out STD_LOGIC_VECTOR(address_bus_width-1 downto 0)
    );
  end component;
  
  component ROM is
    generic(
	    address_bus_width: integer := 8;
	    data_bus_width: integer := 8
    );
    port (
      clk:       in  std_logic;
	    read:      in  std_logic;
	    addr:      in  std_logic_vector(address_bus_width-1 downto 0);
	    data_out:  out std_logic_vector(data_bus_width-1 downto 0)
    );
  end component;
  
  component accumulator is
    generic(
		  data_bus_width: integer := 8
	  );
	  port(
		  clk : in STD_LOGIC;
      write : in STD_LOGIC;
      read : in STD_LOGIC;
      data : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0);
      parity_flag : out STD_LOGIC
	  );
  end component;
  
  component accumulator_register is
    generic(
		  data_bus_width: integer := 8
	  );
    Port(
      clk : in STD_LOGIC;
      write : in STD_LOGIC;
      read : in STD_LOGIC;
      data_in : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0);
      data_out: out STD_LOGIC_VECTOR(data_bus_width-1 downto 0)
     );
  end component;
  
  component temporary_storage_register is
    generic(
		  data_bus_width: integer := 8
	  );
    Port(
      clk : in STD_LOGIC;
      write : in STD_LOGIC;
      read : in STD_LOGIC;
      data_in : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0);
      data_out: out STD_LOGIC_VECTOR(data_bus_width-1 downto 0)
     );
  end component;
  
  component RAM_address_register is
    generic(
		  data_bus_width: integer := 8
	  );
    Port(
      clk : in STD_LOGIC;
      write : in STD_LOGIC;
      data_in : in STD_LOGIC_VECTOR(data_bus_width-1 downto 0);
      data_out: out STD_LOGIC_VECTOR(data_bus_width-1 downto 0)
     );
  end component;
  
  component RAM is
    generic(
	    address_bus_width: integer := 8
    );
    port(
      clk: in std_logic;
      read: in std_logic;
      write: in std_logic;
      addr: in std_logic_vector(7 downto 0);
      data: inout std_logic_vector(7 downto 0)
    );
  end component;
  
  component adder is
    generic(
	    data_bus_width: integer := 8
    );
    port(
      clk:        in std_logic;
	    ACC_REG:    in std_logic_vector(data_bus_width-1 downto 0);
	    TSR:        in std_logic_vector(data_bus_width-1 downto 0);
	    opcode:     in std_logic_vector(1 downto 0);
	    res:        out std_logic_vector(data_bus_width-1 downto 0);
	    carry_flag: out std_logic
	  );
  end component;
  
  component program_status_word_register is
    generic(
		  data_bus_width: integer := 8
	  );
    Port(
      clk : in STD_LOGIC;
      write : in STD_LOGIC;
      read : in STD_LOGIC;
      carry_flag : in STD_LOGIC;
      parity_flag : in STD_LOGIC;
      psw : inout STD_LOGIC_VECTOR(data_bus_width-1 downto 0)
    );
  end component;
  
  component mcu_tester IS
    generic(
      per: time := 50 ns
     );
    port (
      clk: out std_logic
    );
  end component mcu_tester;
  
  component control_unit is
    generic(
		  address_bus_width: integer := 8
	  );
	  port(
		  clk:           in  std_logic;
		  enable_RPC:    out  std_logic;
		  jump_RPC:      out  std_logic;
		  read_MAR:      out  std_logic;
		  write_MAR:     out  std_logic;
		  read_ROM:      out  std_logic;
		  command:       inout  std_logic_vector(address_bus_width-1 downto 0);
		  write_ACC:     out  std_logic;
		  read_ACC:      out  std_logic;
		  write_ACC_REG: out  std_logic;
		  read_ACC_REG:  out  std_logic;
		  write_TSR:     out  std_logic;
		  read_TSR:      out  std_logic;
		  write_RAR:     out  std_logic;
		  read_RAM:      out  std_logic;
		  write_RAM:     out  std_logic;
		  write_PSW:     out  std_logic;
		  read_PSW:      out  std_logic;
		  opcode:        out std_logic_vector(1 downto 0)
	  );
  end component;
  
  for CU: control_unit use entity intel8051_lib.control_unit;
  for RPC: program_counter_register use entity intel8051_lib.program_counter_register;
  for MAR: memory_address_register use entity intel8051_lib.memory_address_register;
  for ROM1: ROM use entity intel8051_lib.ROM;
  for ACC: accumulator use entity intel8051_lib.accumulator;
  for ACC_REG: accumulator_register use entity intel8051_lib.accumulator_register;
  for TSR: temporary_storage_register use entity intel8051_lib.temporary_storage_register;
  for RAR: RAM_address_register use entity intel8051_lib.RAM_address_register;
  for RAM1: RAM use entity intel8051_lib.RAM;
  for ALU: adder use entity intel8051_lib.adder;
  for PSW: program_status_word_register use entity intel8051_lib.program_status_word_register;
  for TEST: mcu_tester use entity intel8051_lib.mcu_tester;
  
  signal clk, enable_RPC, jump_RPC, write_MAR, read_MAR, read_ROM, write_ACC, read_ACC, write_ACC_REG, read_ACC_REG, write_TSR, read_TSR,
         write_RAR, read_RAM, write_RAM, carry_flag, parity_flag, write_PSW, read_PSW : std_logic := '0';
  signal program_counter_bus, address_bus, data_bus, ACC_REG_BUS, TSR_BUS, RAR_BUS: std_logic_vector(address_bus_width-1 downto 0) := (others => '0');
  signal opcode_bus: std_logic_vector(1 downto 0) := (others => '0');
  
BEGIN
  
  CU: control_unit
  generic map(
		address_bus_width => address_bus_width
	)
	port map(
		clk => clk,
		enable_RPC => enable_RPC, 
		jump_RPC => jump_RPC,
		write_MAR => write_MAR,   
		read_MAR => read_MAR,     
		read_ROM => read_ROM,  
		command => data_bus,
		write_ACC => write_ACC,
		read_ACC => read_ACC,
		write_ACC_REG => write_ACC_REG,
		read_ACC_REG => read_ACC_REG,
		write_TSR => write_TSR,
		read_TSR => read_TSR,
		write_RAR => write_RAR,
		read_RAM => read_RAM,
		write_RAM => write_RAM,
		opcode => opcode_bus,
		write_PSW => write_PSW,
		read_PSW => read_PSW
	);
  
  RPC: program_counter_register
  generic map(
		address_bus_width => address_bus_width
	)
	port map(
		clk => clk,
		enable => enable_RPC,
		jump => jump_RPC,
    jump_through => data_bus,
		command_address => program_counter_bus
	);
	
	MAR: memory_address_register
	generic map(
		address_bus_width => address_bus_width
	)
  port map(
    clk => clk,
    write => write_MAR,
    read => read_MAR,
    addr => program_counter_bus,
    out_addr => address_bus
  );
  
  ROM1: ROM
  generic map(
	  address_bus_width => address_bus_width,
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
	  read => read_ROM,
	  addr => address_bus,
	  data_out => data_bus
  );
  
  ACC: accumulator
  generic map(
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
    write => write_ACC,
    read => read_ACC,
    data => data_bus,
    parity_flag => parity_flag
  );
  
  ACC_REG: accumulator_register
  generic map(
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
    write => write_ACC_REG,
    read => read_ACC_REG,
    data_in => data_bus,
    data_out => ACC_REG_BUS
  );
  
  TSR: temporary_storage_register
  generic map(
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
    write => write_TSR,
    read => read_TSR,
    data_in => data_bus,
    data_out => TSR_BUS
  );
  
  RAR: RAM_address_register
  generic map(
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
    write => write_RAR,
    data_in => data_bus,
    data_out => RAR_BUS
  );
  
  RAM1: RAM
  generic map(
	  address_bus_width => address_bus_width
  )
  port map(
    clk => clk,
    read => read_RAM,
    write => write_RAM,
    addr => RAR_BUS,
    data => data_bus
  );
  
  ALU: adder
  generic map(
	  data_bus_width => data_bus_width
  )
  port map(
    clk => clk,
	  ACC_REG => ACC_REG_BUS,
	  TSR => TSR_BUS,
	  opcode => opcode_bus,
	  res => data_bus,
	  carry_flag => carry_flag
  );
  
  PSW: program_status_word_register
  generic map(
	  data_bus_width => data_bus_width
	)
  port map(
    clk => clk,
    write => write_PSW,
    read  => read_PSW,
    carry_flag => carry_flag,
    parity_flag => parity_flag,
    psw => data_bus
  );
  
  TEST: mcu_tester
  --generic map(
  --  per => per
  --)
  port map(
    clk => clk
  );
	
END ARCHITECTURE Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY control_unit IS
  generic(
	  address_bus_width: integer := 8;
	  data_bus_width: integer := 8
  );
  port(
  	clk:           in  std_logic;
  	enable_RPC:    out  std_logic;
  	jump_RPC:      out  std_logic;
	 write_MAR:     out  std_logic;
	 read_MAR:      out  std_logic;
	 read_ROM:      out  std_logic;
	 command:       inout  std_logic_vector(address_bus_width-1 downto 0) := x"ZZ";
	 write_ACC:     out  std_logic;
	 read_ACC:      out  std_logic;
	 write_ACC_REG: out  std_logic;
	 read_ACC_REG:  out  std_logic;
	 write_TSR:     out  std_logic;
	 read_TSR:      out  std_logic;
	 write_RAR:     out  std_logic;
	 read_RAM:      out  std_logic;
	 write_RAM:     out  std_logic;
	 opcode:        out std_logic_vector(1 downto 0) := "ZZ";
	 write_PSW:     out  std_logic;
	 read_PSW:      out  std_logic
);
END ENTITY control_unit;


ARCHITECTURE Behavioral OF control_unit IS
  type state is (next_cmd_1, next_cmd_2, next_cmd_3, next_cmd_4, next_cmd_5, 
                 add_1, add_2, add_3, add_4, add_5, add_6, add_7, add_8, add_9, add_10,
                 mov_1, mov_2, mov_3, mov_4, mov_5, mov_6, mov_7, mov_8, mov_9, mov_10, mov_11, mov_12, mov_13, mov_14, mov_15, mov_16, mov_17, mov_18, mov_19,
                 cjne_1, cjne_2, cjne_3, cjne_4, cjne_5, cjne_6, cjne_7, cjne_8, cjne_9, cjne_10, cjne_11, cjne_12, cjne_13, cjne_14, cjne_15,
                 cjne_16, cjne_17, cjne_18, cjne_19, cjne_20, cjne_21, cjne_22);
                 
  signal current_state, next_state: state;
  signal reg_num: std_logic_vector(2 downto 0) := (others => '0');
  
BEGIN
  
  Process (clk) is
	begin
		if rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
  
  Process (current_state) is
	begin
	  
		enable_RPC <= '0';
		jump_RPC <= '0';
		write_MAR <= '0';
		read_MAR <= '0';
		read_ROM <= '0';
		write_ACC <= '0';
		read_ACC <= '0';
		write_ACC_REG <= '0';
		read_ACC_REG <= '0';
		write_TSR <= '0';
		read_TSR <= '0';
		write_RAR <= '0';
		read_RAM <= '0';
		write_RAM <= '0';
		write_PSW <= '0';
		read_PSW <= '0';
		
		case (current_state) is
		  
			when next_cmd_1 =>
				enable_RPC <= '1';        --read from RPC in program counter bus
				next_state <= next_cmd_2;
				
			when next_cmd_2 =>
				write_MAR <= '1';         --write from program counter bus in MAR
				enable_RPC <= '0';        
				next_state <= next_cmd_3;
			
			when next_cmd_3 =>
			  write_MAR <= '0';         
				read_MAR <= '1';          --read MAR in address bus
				next_state <= next_cmd_4;
			
			when next_cmd_4 =>
			  read_MAR <= '0';         
				read_ROM <= '1';          --read address from address bus in ROM
				next_state <= next_cmd_5;
				
			when next_cmd_5 =>
			  read_ROM <= '0';
			  if (command(7 downto 3) = "00101") then
			    reg_num <= command(2 DOWNTO 0);
			    next_state <= add_1;
			  elsif (command(7 downto 0) = "10000101") then
			    next_state <= mov_1;
			  elsif (command(7 downto 1) = "1011011") then
			    reg_num <= "00" & command(0);
			    next_state <= cjne_1;
			  end if;
			  
			 when add_1 =>
			   read_ACC <= '1';
			   next_state <= add_2;
			  
			 when add_2 =>
			   write_ACC_REG <= '1';
			   read_ACC <= '0';
			   next_state <= add_3;
			 
			 when add_3 =>
			   write_ACC_REG <= '0';
			   next_state <= add_4;
			   
			 when add_4 =>
			   write_ACC_REG <= '0';
			   command <= "00000" & reg_num;
			   write_RAR <= '1';
			   next_state <= add_5;
			   
			 when add_5 =>
			   write_RAR <= '0';
			   command <= x"ZZ";
			   next_state <= add_6;
			 
			 when add_6 =>
			   read_RAM <= '1';
			   next_state <= add_7;
			   
			 when add_7 =>
			   write_TSR <= '1';
			   read_RAM <= '0';
			   next_state <= add_8;
			 
			 when add_8 =>
			   opcode <= "00";
			   write_ACC <= '1';
			   next_state <= add_9;
			   
			 when add_9 =>
			   write_ACC <= '0';
			   opcode <= "ZZ";
			   next_state <= add_10;
			   
			 when add_10 =>
			   write_ACC <= '0';
			   next_state <= next_cmd_1;
			   
			 when mov_1 =>
			   enable_RPC <= '1';
			   next_state <= mov_2;
			 
			 when mov_2 =>
			   write_MAR <= '1';
				 enable_RPC <= '0';        
				 next_state <= mov_3;
			
			 when mov_3 =>
			   write_MAR <= '0';         
				 read_MAR <= '1';
				 next_state <= mov_4;
			
			 when mov_4 =>
			   read_MAR <= '0';         
				 read_ROM <= '1';   
				 next_state <= mov_5;
			
			 when mov_5 =>
			   write_TSR <= '1';
			   read_ROM <= '0';
			   next_state <= mov_6;
			   
			 when mov_6 =>
			   write_TSR <= '0';
			   next_state <= mov_7;
			   
			 when mov_7 => 
			   enable_RPC <= '1';
			   next_state <= mov_8;
			 
			 when mov_8 =>
			   write_MAR <= '1';
				 enable_RPC <= '0';        
				 next_state <= mov_9;
			
			 when mov_9 =>
			   write_MAR <= '0';         
				 read_MAR <= '1';
				 next_state <= mov_10;
			
			 when mov_10 =>
			   read_MAR <= '0';         
				 read_ROM <= '1';   
				 next_state <= mov_11;
			
			 when mov_11 =>
			   write_RAR <= '1';
			   read_ROM <= '0';
			   next_state <= mov_12;
			 
			 when mov_12 =>
			   write_RAR <= '0';
			   next_state <= mov_13;
			 
			 when mov_13 =>
			   read_RAM <= '1';
			   next_state <= mov_14;
			 
			 when mov_14 =>
			   write_ACC_REG <= '1';
			   read_RAM <= '0';
			   next_state <= mov_15;
			   
			 when mov_15 =>
			   read_TSR <= '1';
			   next_state <= mov_16;
			 
			 when mov_16 =>
			   write_RAR <= '1';
			   read_TSR <= '0';
			   next_state <= mov_17;
			 
			 when mov_17 =>
			   write_RAR <= '0';
			   read_ACC_REG <= '1';
			   next_state <= mov_18;
			 
			 when mov_18 =>
			   write_RAM <= '1';
			   read_ACC_REG <= '0';
			   next_state <= mov_19;
			 
			 when mov_19 =>
			   write_RAM <= '0';
			   next_state <= next_cmd_1;
			   
			 when cjne_1 =>
			   command <= "00000" & reg_num;
			   write_RAR <= '1';
			   next_state <= cjne_2;
			   
			 when cjne_2 =>
			   write_RAR <= '0';
			   command <= x"ZZ";
			   next_state <= cjne_3;
			 
			 when cjne_3 =>
			   read_RAM <= '1';
			   next_state <= cjne_4;
			   
			 when cjne_4 =>
			   write_RAR <= '1';
			   read_RAM <= '0';
			   next_state <= cjne_5;
			   
			 when cjne_5 =>
			   write_RAR <= '0';
			   next_state <= cjne_6;
			 
			 when cjne_6 =>
			   read_RAM <= '1';
			   next_state <= cjne_7;
			   
			 when cjne_7 =>
			   write_TSR <= '1';
			   read_RAM <= '0';
			   next_state <= cjne_8;
			 
			 when cjne_8 =>
			   write_TSR <= '0';
			   next_state <= cjne_9;
			  
			 when cjne_9 =>
			   enable_RPC <= '1';
			   next_state <= cjne_10;
			 
			 when cjne_10 =>
				 write_MAR <= '1';         --write from program counter bus in MAR
				 enable_RPC <= '0';        
				 next_state <= cjne_11;
			
			 when cjne_11 =>
			   write_MAR <= '0';         
				 read_MAR <= '1';          --read MAR in address bus
				 next_state <= cjne_12;
			
			 when cjne_12 =>
			   read_MAR <= '0';         
				 read_ROM <= '1';          --read address from address bus in ROM
				 next_state <= cjne_13;
			
			 when cjne_13 =>
			   write_ACC_REG <= '1';
			   read_ROM <= '0';
			   next_state <= cjne_14;
			 
			 when cjne_14 =>
         write_ACC_REG <= '0';
         opcode <= "01";
				 next_state <= cjne_15;
			 
			 when cjne_15 =>
			   opcode <= "ZZ";
			   if (command(7 downto 0) = "10000000") then --if equal
			     --���� ����������� ��� ��������� ����
			     next_state <= cjne_16;
			   elsif (command(7 downto 0) = "01111111") then --if not equal
			     --next_state <= mov_1;
			     next_state <= cjne_18;
			   end if;
				
				--if equal
				when cjne_16 =>
				  enable_RPC <= '1';
				  next_state <= cjne_17;
				
				when cjne_17 =>
				  enable_RPC <= '0';
				  next_state <= next_cmd_1;
				  
				--if not equal
				when cjne_18 =>
				  enable_RPC <= '1';       
				  next_state <= cjne_19;
				
     			when cjne_19 =>
      				write_MAR <= '1';         
      				enable_RPC <= '0';        
      				next_state <= cjne_20;
      			
     			when cjne_20 =>
     			  write_MAR <= '0';         
      				read_MAR <= '1';          
      				next_state <= cjne_21;
      			
      		when cjne_21 =>
      			 read_MAR <= '0';         
      			 read_ROM <= '1';          
      			 next_state <= cjne_22;
    			 
    			 when cjne_22 =>
     				 jump_RPC <= '1';
     				 next_state <= next_cmd_1;
     				 
		end case;
	end process;
  
END ARCHITECTURE Behavioral;


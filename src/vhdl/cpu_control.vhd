-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 10.08.2015     Patrick Appenheimer    entity
-- 11.08.2015     Patrick Appenheimer    main fsm
-- 11.08.2015     Patrick Appenheimer    5 instr fsm
-- 12.08.2015     Patrick Appenheimer    minor changes

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;  


entity cpu_control is
  port(
      clk                   	: in  std_logic;
      rst                   	: in  std_logic;
      rd_mask   	        : out std_logic_vector(3  downto 0);
      wr_mask		        : out std_logic_vector(3  downto 0);
      instr_stall       	: in  std_logic;
      data_stall        	: in  std_logic;
      instr_in              	: in  std_logic_vector(31 downto 0);
      alu_op            	: out std_logic_vector(5 downto 0);
      exc_mux1              	: out std_logic_vector(1 downto 0);
      exc_mux2              	: out std_logic_vector(1 downto 0);
      exc_alu_zero		: in  std_logic_vector(0 downto 0);
      memstg_mux        	: out std_logic;
      id_regdest_mux    	: out std_logic_vector (1 downto 0);
      id_regshift_mux       	: out std_logic_vector (1 downto 0);
      id_enable_regs		: out std_logic;
      in_mux_pc             	: out std_logic;
      stage_control		: out std_logic_vector (4 downto 0)
    );

end entity cpu_control;

architecture structure_cpu_control of cpu_control is

  constant s0    : std_logic_vector(4 downto 0) := b"00000";
  constant s1    : std_logic_vector(4 downto 0) := b"00001";
  constant s2    : std_logic_vector(4 downto 0) := b"00010";
  constant s3    : std_logic_vector(4 downto 0) := b"00011";
  constant s4    : std_logic_vector(4 downto 0) := b"00100";
  constant sX    : std_logic_vector(4 downto 0) := b"11111";

  signal instr1         : std_logic_vector(31 downto 0);
  signal instr2         : std_logic_vector(31 downto 0);
  signal instr3         : std_logic_vector(31 downto 0);
  signal instr4         : std_logic_vector(31 downto 0);
  signal instr5         : std_logic_vector(31 downto 0);

  signal currentstate1         : std_logic_vector(4 downto 0);
  signal currentstate2         : std_logic_vector(4 downto 0);
  signal currentstate3         : std_logic_vector(4 downto 0);
  signal currentstate4         : std_logic_vector(4 downto 0);
  signal currentstate5         : std_logic_vector(4 downto 0);
  
  signal nextstate1         : std_logic_vector(4 downto 0);
  signal nextstate2         : std_logic_vector(4 downto 0);
  signal nextstate3         : std_logic_vector(4 downto 0);
  signal nextstate4         : std_logic_vector(4 downto 0);
  signal nextstate5         : std_logic_vector(4 downto 0);
  
  signal output_buffer1 : std_logic_vector(29 downto 0);
  signal output_buffer2 : std_logic_vector(29 downto 0);
  signal output_buffer3 : std_logic_vector(29 downto 0);
  signal output_buffer4 : std_logic_vector(29 downto 0);
  signal output_buffer5 : std_logic_vector(29 downto 0);
  
  signal busy1      : std_logic;
  signal busy2      : std_logic;
  signal busy3      : std_logic;
  signal busy4      : std_logic;
  signal busy5      : std_logic;
  
  signal go1      : std_logic;
  signal go2      : std_logic;
  signal go3      : std_logic;
  signal go4      : std_logic;
  signal go5      : std_logic;

  signal currentstate  : std_logic_vector(4 downto 0);
  signal nextstate     : std_logic_vector(4 downto 0);
  
begin

	fsm1:	entity work.fsm(behavioral) port map(clk, rst, instr1, instr_stall, data_stall,
	currentstate1, nextstate1, output_buffer1, busy1, go1);
	fsm2:	entity work.fsm(behavioral) port map(clk, rst, instr2, instr_stall, data_stall,
	currentstate2, nextstate2, output_buffer2, busy2, go2);
	fsm3:	entity work.fsm(behavioral) port map(clk, rst, instr3, instr_stall, data_stall,
	currentstate3, nextstate3, output_buffer3, busy3, go3);
	fsm4:	entity work.fsm(behavioral) port map(clk, rst, instr4, instr_stall, data_stall,
	currentstate4, nextstate4, output_buffer4, busy4, go4);
	fsm5:	entity work.fsm(behavioral) port map(clk, rst, instr5, instr_stall, data_stall,
	currentstate5, nextstate5, output_buffer5, busy5, go5);

	stage_control (1 downto 0) <= b"11";
	
state_encode: process(currentstate, busy1, busy2, busy3, busy4, busy5)
  begin
    case currentstate is
    	when sX =>
    	if (busy1 = '0') then
    	    nextstate <= s0;
    	else
    	    nextstate <= sX;
    	end if;
        when s0 =>
        if (busy2 = '0') then
            nextstate <= s1;
        else                          
            nextstate <= s0;
        end if;
        when s1 =>                     
        if (busy3 = '0') then
            nextstate <= s2;
        else                          
            nextstate <= s1;
        end if;
        when s2 =>                      
        if (busy4 = '0') then
            nextstate <= s3;
        else                          
            nextstate <= s2;
        end if;
        when s3 =>                     
        if (busy5 = '0') then
            nextstate <= s4;
        else                          
            nextstate <= s3;
        end if;
        when s4 =>                     
        if (busy1 = '0') then
            nextstate <= s0;
        else                          
            nextstate <= sX;
        end if;
        when others => nextstate <= sX;
    end case;
  end process state_encode;
  
  state_register: process(rst, clk)
  begin
    if (rst = '0') then
      currentstate <= sX;
    elsif (clk'event and clk = '1') then
      currentstate <= nextstate;
    end if;
  end process state_register;
  
  state_decode: process(currentstate)
  begin
    case currentstate is
      when sX =>
      	go1 <= '0';
      	go2 <= '0';
      	go3 <= '0';
      	go4 <= '0';
      	go5 <= '0';
      when s0 =>
      	instr1 <= instr_in;
      	go1 <= '1';
      when s1 =>
      	instr2 <= instr_in;
      	go2 <= '1';
      when s2 =>
      	instr3 <= instr_in;
      	go3 <= '1';
      when s3 =>
      	instr4 <= instr_in;
      	go4 <= '1';
      when s4 =>
      	instr5 <= instr_in;
      	go5 <= '1';
      when others =>
        -- do something
    end case;
  end process state_decode;
  
  fsm1_ctrl: process(currentstate1)
  begin
  	case currentstate1 is
		when s0 =>
			id_regdest_mux <= output_buffer1 (28 downto 27);
			id_regshift_mux <= output_buffer1 (26 downto 25);
		when s1 =>
			exc_mux1 <= output_buffer1 (23 downto 22);
			exc_mux2 <= output_buffer1 (21 downto 20);
			alu_op <= output_buffer1 (19 downto 14);
			in_mux_pc <= output_buffer1 (29);
			stage_control (2) <= output_buffer1 (2);
		when s2 =>
			memstg_mux <= output_buffer1 (13);
			rd_mask <= output_buffer1 (12 downto 9);
			wr_mask <= output_buffer1 (8 downto 5);
			stage_control (3) <= output_buffer1 (3);
		when s3 =>
			stage_control (4) <= output_buffer1 (4);
		when s4 =>
			id_enable_regs <= output_buffer1 (24);
			go1 <= '0';
		when others =>
			--do nothing
	end case;
  end process fsm1_ctrl;


  
  fsm2_ctrl: process(currentstate2)
  begin
  	case currentstate2 is
		when s0 =>
			id_regdest_mux <= output_buffer2 (28 downto 27);
			id_regshift_mux <= output_buffer2 (26 downto 25);
		when s1 =>
			exc_mux1 <= output_buffer2 (23 downto 22);
			exc_mux2 <= output_buffer2 (21 downto 20);
			alu_op <= output_buffer2 (19 downto 14);
			in_mux_pc <= output_buffer2 (29);
			stage_control (2) <= output_buffer2 (2);
		when s2 =>
			memstg_mux <= output_buffer2(13);
			rd_mask <= output_buffer2 (12 downto 9);
			wr_mask <= output_buffer2 (8 downto 5);
			stage_control (3) <= output_buffer2 (3);
		when s3 =>
			stage_control (4) <= output_buffer2 (4);
		when s4 =>
			id_enable_regs <= output_buffer2 (24);
			go2 <= '0';
		when others =>
			--do nothing
	end case;
  end process fsm2_ctrl;
  
  fsm3_ctrl: process(currentstate3)
  begin
  	case currentstate3 is
		when s0 =>
			id_regdest_mux <= output_buffer3 (28 downto 27);
			id_regshift_mux <= output_buffer3 (26 downto 25);
		when s1 =>
			exc_mux1 <= output_buffer3 (23 downto 22);
			exc_mux2 <= output_buffer3 (21 downto 20);
			alu_op <= output_buffer3 (19 downto 14);
			in_mux_pc <= output_buffer3 (29);
			stage_control (2) <= output_buffer3 (2);
		when s2 =>
			memstg_mux <= output_buffer3 (13);
			rd_mask <= output_buffer3 (12 downto 9);
			wr_mask <= output_buffer3 (8 downto 5);
			stage_control (3) <= output_buffer3 (3);
		when s3 =>
			stage_control (4) <= output_buffer3 (4);
		when s4 =>
			id_enable_regs <= output_buffer3 (24);
			go3 <= '0';
		when others =>
			--do nothing
	end case;
  end process fsm3_ctrl;
  
  fsm4_ctrl: process(currentstate4)
  begin
  	case currentstate4 is
		when s0 =>
			id_regdest_mux <= output_buffer4 (28 downto 27);
			id_regshift_mux <= output_buffer4 (26 downto 25);
		when s1 =>
			exc_mux1 <= output_buffer4 (23 downto 22);
			exc_mux2 <= output_buffer4 (21 downto 20);
			alu_op <= output_buffer4 (19 downto 14);
			in_mux_pc <= output_buffer4 (29);
			stage_control (2) <= output_buffer4 (2);
		when s2 =>
			memstg_mux <= output_buffer4 (13);
			rd_mask <= output_buffer4 (12 downto 9);
			wr_mask <= output_buffer4 (8 downto 5);
			stage_control (3) <= output_buffer4 (3);
		when s3 =>
			stage_control (4) <= output_buffer4 (4);
		when s4 =>
			id_enable_regs <= output_buffer4 (24);
			go4 <= '0';
		when others =>
			--do nothing
	end case;
  end process fsm4_ctrl;
  
  fsm5_ctrl: process(currentstate5)
  begin
  	case currentstate5 is
		when s0 =>
			id_regdest_mux <= output_buffer5 (28 downto 27);
			id_regshift_mux <= output_buffer5 (26 downto 25);
		when s1 =>
			exc_mux1 <= output_buffer5 (23 downto 22);
			exc_mux2 <= output_buffer5 (21 downto 20);
			alu_op <= output_buffer5 (19 downto 14);
			in_mux_pc <= output_buffer5 (29);
			stage_control (2) <= output_buffer5 (2);
		when s2 =>
			memstg_mux <= output_buffer5 (13);
			rd_mask <= output_buffer5 (12 downto 9);
			wr_mask <= output_buffer5 (8 downto 5);
			stage_control (3) <= output_buffer5 (3);
		when s3 =>
			stage_control (4) <= output_buffer5 (4);
		when s4 =>
			id_enable_regs <= output_buffer5 (24);
			go5 <= '0';
		when others =>
			--do nothing
	end case;
  end process fsm5_ctrl;

		
	
end architecture structure_cpu_control;

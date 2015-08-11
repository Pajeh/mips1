-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 10.08.2015     Patrick Appenheimer    entity
-- 11.08.2015     Patrick Appenheimer    architecture

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;  

entity cpu_control is
  port(
      clk                   	: in  std_logic;
      rst                   	: in  std_logic;
      instr_addr            	: out std_logic_vector(31 downto 0);
      data_addr             	: out std_logic_vector(31 downto 0);
      rd_mask   	        : out std_logic_vector(3  downto 0);
      wr_mask		        : out std_logic_vector(3  downto 0);
      instr_stall       	: in  std_logic;
      data_stall        	: in  std_logic;
      instr_in              	: in  std_logic_vector(31 downto 0);
      data_to_cpu           	: in  std_logic_vector(31 downto 0);
      data_from_cpu         	: out std_logic_vector(31 downto 0);
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
  
  signal nexttstate1         : std_logic_vector(4 downto 0);
  signal nexttstate2         : std_logic_vector(4 downto 0);
  signal nexttstate3         : std_logic_vector(4 downto 0);
  signal nexttstate4         : std_logic_vector(4 downto 0);
  signal nexttstate5         : std_logic_vector(4 downto 0);
  
  signal output_buffer1 : std_logic_vector(29 downto 0);
  signal output_buffer2 : std_logic_vector(29 downto 0);
  signal output_buffer3 : std_logic_vector(29 downto 0);
  signal output_buffer4 : std_logic_vector(29 downto 0);
  signal output_buffer5 : std_logic_vector(29 downto 0);
  
  signal busy1      : std_logic := '0';
  signal busy2      : std_logic := '0';
  signal busy3      : std_logic := '0';
  signal busy4      : std_logic := '0';
  signal busy5      : std_logic := '0';

  signal currentstate  : std_logic_vector(4 downto 0)  := (others => '0');
  signal nextstate     : std_logic_vector(4 downto 0)  := (others => '0');
  
begin

	fsm1:	entity work.fsm(behavioral) port map(clk, rst, instr1, instr_stall, data_stall,
	currentstate1, nextstate1, output_buffer1, busy1);
	fsm2:	entity work.fsm(behavioral) port map(clk, rst, instr2, instr_stall, data_stall,
	currentstate2, nextstate2, output_buffer2, busy2);
	fsm3:	entity work.fsm(behavioral) port map(clk, rst, instr3, instr_stall, data_stall,
	currentstate3, nextstate3, output_buffer3, busy3);
	fsm4:	entity work.fsm(behavioral) port map(clk, rst, instr4, instr_stall, data_stall,
	currentstate4, nextstate4, output_buffer4, busy4);
	fsm5:	entity work.fsm(behavioral) port map(clk, rst, instr5, instr_stall, data_stall,
	currentstate5, nextstate5, output_buffer5, busy5);

	
state_encode: process(currentstate, busy1, busy2, busy3, busy4, busy5)
  begin
    case currentstate is
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
            nextstate <= s4;
        end if;
        when others => nextstate <= s0;
    end case;
  end process state_encode;
  
  state_register: process(rst, clk)
  begin
    if (rst = '0') then
      currentstate <= s0;
    elsif (clk'event and clk = '1') then
      currentstate <= nextstate;
    end if;
  end process state_register;
  
  state_decode: process(currentstate)
  begin
    case currentstate is
      when s0 =>
      	instr1 <= instr_in;
      when s1 =>
      	instr2 <= instr_in;
      when s2 =>
      	instr3 <= instr_in;
      when s3 =>
      	instr4 <= instr_in;
      when s4 =>
      	instr5 <= instr_in;
      when others =>
        -- do something
    end case;
  end process state_decode;
	
		
	
end architecture structure_cpu_control;

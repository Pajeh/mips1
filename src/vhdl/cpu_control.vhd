-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 10.08.2015     Patrick Appenheimer    entity

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

  signal state1         : std_logic_vector(4 downto 0);
  signal state2         : std_logic_vector(4 downto 0);
  signal state3         : std_logic_vector(4 downto 0);
  signal state4         : std_logic_vector(4 downto 0);
  signal state5         : std_logic_vector(4 downto 0);
  
  signal busy1      : std_logic := '0';
  signal busy2      : std_logic := '0';
  signal busy3      : std_logic := '0';
  signal busy4      : std_logic := '0';
  signal busy5      : std_logic := '0';

  
begin

	fsm1:	entity work.fsm(behavioral) port map(clk, rst, instr1, state1, state5, state2, busy1);
	fsm2:	entity work.fsm(behavioral) port map(clk, rst, instr2, state2, state1, state3, busy2);
	fsm3:	entity work.fsm(behavioral) port map(clk, rst, instr3, state3, state2, state4, busy3);
	fsm4:	entity work.fsm(behavioral) port map(clk, rst, instr4, state4, state3, state5, busy4);
	fsm5:	entity work.fsm(behavioral) port map(clk, rst, instr5, state5, state4, state1, busy5);
	
	instr_ctrl: process(instr_in)
	begin
		if (busy1 = '0') then
			instr1 <= instr_in;
			busy1 <= '1';
		elsif (busy2 = '0') then
			instr2 <= instr_in;
			busy2 <= '1';
		elsif (busy3 = '0') then
			instr3 <= instr_in;
			busy3 <= '1';
		elsif (busy4 = '0') then
			instr3 <= instr_in;
			busy4 <= '1';
		elsif (busy5 = '0') then
			instr3 <= instr_in;
			busy5 <= '1';
		end if;
	end process;
	

			
	fsm1: process(state1)
	begin
	case state1 is
	when s0 =>
	id_regdest_mux <= output_buffer1 (28 downto 27);
	id_regshift_mux <= output_buffer1 (26 downto 25);
	
		
	
end architecture structure_cpu_control;

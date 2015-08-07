-- Revision history:
-- 07.08.2015	Carlos Minamisava Faria	created 

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;  


-- --------------------------------------  --
-- FSM-signal-Howto:			   --
-- --------------------------------------  --

	-- -------- Datapath -----------------
-- pc_mux:
-- 1: Branch logic
-- 0: old PC +4
  	-- -------- Instr. Decode  -----------------
-- regdest_mux:
-- 00: if instruction is of R-type
-- 01: if regdest must be set to 31 (JAL?)
-- 10: if instruction is of I-type
-- 11: NEVER EVER EVER!!!
--
-- regshift_mux:
-- 00: if instruction is of R-type
-- 01: if shift must be 16 (No idea, which instruction uses that...)
-- 10: if you like non-deterministic behaviour
-- 11: if you love non-deterministic behaviour
--
-- enable_regs:
-- 1: if the writeback-stage just finished an R-type- or I-type-instruction (except for JR)
-- 0: if the writeback-stage just finished a J-type-instruction or JR
-- 

  	-- -------- Execution -----------------
-- in_mux1 chooses the input of register A for the ALU
-- 00: Zero extend
-- 01: outputs x"0000_0004"
-- 10: in A from Decode
-- 11: others => 'X'
--
-- in_mux2 chooses the input of register B for the ALU:
-- 00: in_b
-- 01: immediate 16
-- 10: Instruction Pointer (IP)
-- 11: others => 'X'
-- in_alu_instruction:
-- 000000: 
-- 


	-- -------- Memory Stage  -----------------
-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback
-- mux_decisions:
-- 1: output is the aluResult_in
-- 0: output is the memory_buffer, which carries the memory read value
-- 

  -- -- stage_control: --
  -- to activate registers, set signal stage_control as follows:
  -- stage0->stage1: xxxx1
  -- stage1->stage2: xxx1x
  -- stage2->stage3: xx1xx
  -- stage3->stage4: x1xxx
  -- stage4->stage5: 1xxxx
entity FSM is
PORT ( 
	-- General Signals
	clk: in std_logic;
	rst: in std_logic;

	--rst_soft in std_logic:	-- Soft reset
	
	
	-- -------- Datapath -----------------
	pc_mux: out std_logic;
	-- -------- Instr. Fetch -----------------
	instr:	in std_logic_vector(31 downto 0);	-- instruction
	
  	-- -------- Instr. Decode  -----------------
	regdest_mux, regshift_mux: out std_logic_vector (1 downto 0);
	enable_regs: out std_logic;
  	-- -------- Execution -----------------
	in_mux1               : out  std_logic_vector(1 downto 0);
	in_mux2               : out  std_logic_vector(1 downto 0);
	in_alu_instruction    : out  std_logic_vector(5 downto 0);

	ex_alu_zero           : in  std_logic_vector(0  downto 0);		
  	
	-- -------- Memory Stage  -----------------
  	mux_decision: out std_logic;	


	-- -------- Write Back -----------------

	-- -------- Memory  -----------------
	rd_mask                 : out std_logic_vector(3  downto 0);
    	wr_mask                 : out std_logic_vector(3  downto 0);
    	instr_stall             : in  std_logic;
    	data_stall              : in  std_logic;


	-- -------- Pipeline  -----------------
      	stage_control              : out std_logic_vector(4  downto 0);		-- next step in pipeline
)
end entity FSM;

architecture behavioral of FSM is

-- output_buffer code:
-- output_buffer (29 downto 29): pc_mux: out std_logic;
-- output_buffer (28 downto 27): regdest_mux, 
-- output_buffer (26 downto 25): regshift_mux: out std_logic_vector (1 downto 0);
-- output_buffer (24 downto 24): enable_regs: out std_logic;
-- output_buffer (23 downto 22): in_mux1               : out  std_logic_vector(1 downto 0);
-- output_buffer (21 downto 20): in_mux2               : out  std_logic_vector(1 downto 0);
-- output_buffer (19 downto 14): in_alu_instruction    : out  std_logic_vector(5 downto 0);
-- output_buffer (13 downto 13): mux_decision: out std_logic;	
-- output_buffer (12 downto 9): rd_mask                 : out std_logic_vector(3  downto 0);
-- output_buffer (8 downto 5): wr_mask                 : out std_logic_vector(3  downto 0);
-- output_buffer (4 downto 0): pipeline_reg: out std_logic_vector(4  downto 0);		
signal output_buffer: std_logic_vector(29 downto 0);
	begin
		
		
end architecture behavioral;



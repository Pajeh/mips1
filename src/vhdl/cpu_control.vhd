-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 08.07.2015	  Carlos Minamisava Faria	interfaces definition

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;  

entity cpu_control is
PORT ( 
	-- General Signals
	clk: in std_logic;
	rst: in std_logic;

	--rst_soft in std_logic:	-- Soft reset
	
	
	-- -------- Datapath -----------------
	pc_mux: out std_logic;
	-- -------- Instr. Fetch -----------------
	opcode:	in std_logic_vector(5 downto 0);	-- opcode (6) is the instr (31 downto 26) 
	
  	-- -------- Instr. Decode  -----------------
	regdest_mux, regshift_mux: out std_logic_vector (1 downto 0);
	enable_regs: out std_logic;
  	-- -------- Execution -----------------
	in_mux1               : out  std_logic_vector(1 downto 0);
	in_mux2               : out  std_logic_vector(1 downto 0);
	in_alu_instruction    : out  std_logic_vector(5 downto 0);

	ex_alu_zero           : in  std_logic_vector(0  downto 0);		
  	
	-- -------- Memory Stage  -----------------
	-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback
  	mux_decision: out std_logic;	


	-- -------- Write Back -----------------

	-- -------- Memory  -----------------
	rd_mask                 : out std_logic_vector(3  downto 0);
      	wr_mask                 : out std_logic_vector(3  downto 0);
      	instr_stall             : in  std_logic;
      	data_stall              : in  std_logic;


	-- -------- Pipeline  -----------------
      	pipeline_reg              : out std_logic_vector(4  downto 0);		-- next step in pipeline
)


end entity cpu_control;
-- Finite State Machine for the CPU Control

-- The reference program needs the following assembly commands:
-- 	lui	-- Load upper immediate:	0011 11
-- 	addiu	-- Add immediate unsigned 	0010 01
-- 	j	-- Jumps 			0000 10
-- 	lw	-- Load word			1000 11
-- 	nop	-- Performs no operation.	0000 00
-- 	sb	-- Store byte			1010 00
-- 	sw	-- Store word			1010 11
-- 	slti	-- Set on less than immediate (signed)	0010 10
-- 	beqz	-- Branch on equal		0001 00
-- 	bnez	-- Branch on greater than or equal to zero	0001 01
-- 	lbu	-- Load byte unsigned		1001 00
-- 	andi	-- 
-- 	jalx
-- 	
-- 	
-- 	
-- 	
-- 
-- 
-- 
architecture structure_cpu_control of cpu_control is

begin

end architecture structure_cpu_control;

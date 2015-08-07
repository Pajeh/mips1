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
-- 	andi	-- And Immediate		0011 00		
-- 	jalx	--  Jump and Link Exchange	0111 01




-- 
architecture structure_cpu_control of cpu_control is

begin
signal pipeline: std_logic_vector(2 downto 0) := b"000";

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

-- FSM has 11 stages -> at least 5 bits
signal fsm: std_logic_vector(4 downto 0):= b"00000";
process (clk, rst) is
	case fsm is
		when 0 =>	-- Instruction fetch
			output_buffer <= (others => '0');	-- reinitialize all to zero
			
		when 1 =>	-- Instruction Decode / Register fetch
		when 2 =>	-- Memory address computation
		when 3 =>	-- Execution
		when 4 =>	-- Branch completion
		when 5 =>	-- Jump Completion
		when 6 =>	-- Memory access read
		when 7 =>	-- Memory access write
		when 8 =>	-- Writeback
		when 9 =>	-- R-Type completion
		when 10 =>	-- R-Type completion - Overflow
		when 11 =>	-- Type I

	end case;
end process

output: process (clk, rst) is
	if (rst ='0') then output_buffer <=output_buffer <= (others => '0');	-- reinitialize all to zero does this outputs XXX?
	else 	-- output_buffer is outputed
		pc_mux<=output_buffer (29 downto 29);
		regdest_mux<=output_buffer (28 downto 27);
		regshift_mux<= output_buffer (26 downto 25);
		enable_regs<= output_buffer (24 downto 24);
		in_mux1<= output_buffer (23 downto 22);
		in_mux2<=output_buffer (21 downto 20);
		in_alu_instruction<= output_buffer (19 downto 14);
		mux_decision<=output_buffer (13 downto 13);
		rd_mask <= output_buffer (12 downto 9);
		wr_mask<=  output_buffer (8 downto 5);
pipeline_reg<= output_buffer (4 downto 0);

	end if;
end process output;
	
end architecture structure_cpu_control;

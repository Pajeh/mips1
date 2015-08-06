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
	
	
	-- -------- Datapath -----------------
	pc_mux: in std_logic;
	-- -------- Instr. Fetch -----------------
	  
	
  	-- -------- Instr. Decode  -----------------
	regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
	enable_regs: in std_logic;
  	-- -------- Executione -----------------
	in_mux1               : in  std_logic_vector(1 downto 0);
	in_mux2               : in  std_logic_vector(1 downto 0);
	in_alu_instruction    : in  std_logic_vector(5 downto 0);
	
  	-- -------- Memory Stage  -----------------
	-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback
  	mux_decision: in std_logic;	


	-- -------- Write Back -----------------

	-- -------- Memory  -----------------
	rd_mask                 : out std_logic_vector(3  downto 0);
      	wr_mask                 : out std_logic_vector(3  downto 0);
      	instr_stall             : in  std_logic;
      	data_stall              : in  std_logic;
)


end entity cpu_control;

architecture structure_cpu_control of cpu_control is

begin

end architecture structure_cpu_control;

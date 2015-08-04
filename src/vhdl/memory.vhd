-- Revision history:
-- 03.08.2015	Carlos Minamisava Faria	created 
-- 03.08.2015	Carlos Minamisava Faria	entity MemoryStage

library IEEE;
use IEEE.std_logic_1164.ALL;

entity MemoryStage is
port(
clk: in std_logic;
rst: in std_logic;

aluResult_in: in std_logic_vector( CPU_DATA_WIDTH-1 downto 0);			-- ALU results from Execution Stage

data_in: in std_logic_vector(CPU_DATA_WIDTH-1 downto 0);				-- Data from execution stage
																		-- Memory Read/Write decision comes from the FSS
memory_address: out std_logic_vector(CPU_MEM_CELL_WIDTH-1 downto 0);	-- Memory address output for memory r/w
memory_data_out: out std_logic_vector(CPU_MEM_CELL_WIDTH-1 downto 0);	-- Memory data out. This is a CPU_MEM_CELL_WIDTH (8) long register. Mostly 4 clocks needed for 32 bits r/w.
memory_data_in: in std_logic_vector(CPU_MEM_CELL_WIDTH-1 downto 0);		-- Read data from memory. This is a CPU_MEM_CELL_WIDTH (8) long register. Mostly 4 clocks needed for 32 bits r.

memory_data_reg: in std_logic_vector(CPU_REG_ADDR_WIDTH-1 downto 0); 	-- Register control of the memory read process. (time control)

mux_decision: in std_logic;												-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback
fss_memory: in std_logic_vector(CPU_REG_ADDR_WIDTH-1 downto 0);			-- FSS decision for data access: r/w.

writeback: out std_logic_vector( CPU_DATA_WIDTH-1 downto 0);			-- Data to send to next stage: Writeback

reg_dest_in: in std_logic_vector(CPU_REG_ADDR_WIDTH-1 downto 0);		-- k.A.
reg_dest_out: out std_logic_vector(CPU_REG_ADDR_WIDTH-1 downto 0));		-- k.A.
end entity MemoryStage

architecture memory_stage of MemoryStage is
	begin
		process
		begin
			if (!rst) then
				writeback <= 0;
			else 
				memory_address <= data_in;
				
				memory_data_out
				
			end
		end process
		
		memdata: process(fss_memory) 
			begin
				case (fss_memory) is
					when 
			end process memdata
end architecture behavioral
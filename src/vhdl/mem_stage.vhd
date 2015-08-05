-- Revision history:
-- 03.08.2015	Carlos Minamisava Faria	created 
-- 03.08.2015	Carlos Minamisava Faria	entity MemoryStage
-- 04.08.2015	Carlos Minamisava Faria architecture MemoryStage

library IEEE;
use IEEE.std_logic_1164.ALL;

entity MemoryStage is
port(
	clk: in std_logic;
	rst: in std_logic;

	aluResult_in: in std_logic_vector( 31 downto 0);--CPU_DATA_WIDTH-1 downto 0);	-- ALU results from Execution Stage

	data_in: in std_logic_vector(31 downto 0);--CPU_DATA_WIDTH-1 downto 0);	-- Data from execution stage
									-- Memory Read/Write decision comes from the FSS
	data_addr: out std_logic_vector(31 downto 0);--CPU_ADDR_WIDTH-1 downto 0);	-- Memory address output for memory r/w
	data_from_cpu: out std_logic_vector(31 downto 0);--CPU_DATA_WIDTH-1 downto 0);	-- Memory data out. 
	data_to_cpu: in std_logic_vector(31 downto 0);--CPU_DATA_WIDTH-1 downto 0);	-- Read data from memory.


--not needed--    data_stall              : in  std_logic;				-- data stall - cpu input

	mux_decision: in std_logic;					-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback

	writeback: out std_logic_vector( 31 downto 0);--CPU_DATA_WIDTH-1 downto 0);	-- Data to send to next stage: Writeback

	reg_dest_in: in std_logic_vector(31 downto 0);--CPU_REG_ADDR_WIDTH-1 downto 0);        -- k.A.
	reg_dest_out: out std_logic_vector(31 downto 0));--CPU_REG_ADDR_WIDTH-1 downto 0));     -- k.A.
end entity MemoryStage;

architecture behavioral of MemoryStage is
--	signal memory_buffer: std_logic_vector(31 downto 0);--CPU_DATA_WIDTH-1 downto 0);
	begin
	
		-- Data address and data are always routed out.
		data_addr <= data_in;
		data_from_cpu <= aluResult_in;
		
		-- reg_dest is forwarded
		reg_dest_out <= reg_dest_in;
		
		output: process is
		begin
			if (rst='0') then                                   -- reset condition
				writeback <= x"00_00_00_00";
			else 
				if (mux_decision ='1') then		-- mux_decision choses between the two possible outputs: the result from ALU of the read memory	
					writeback <= aluResult_in;	-- output is the aluResult_in
				else
					writeback <= data_to_cpu;	-- output is the memory_buffer, which carries the memory read value.
				end
			end
		end process output
		
end architecture behavioral;

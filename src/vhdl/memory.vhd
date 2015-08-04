-- Revision history:
-- 03.08.2015	Carlos Minamisava Faria	created 
-- 03.08.2015	Carlos Minamisava Faria	entity MemoryStage

library IEEE;
use IEEE.std_logic_1164.ALL;

entity MemoryStage is
port(
clk: in std_logic;
rst: in std_logic;

aluResult_in: in std_logic_vector( 31 downto 0);

data_in: in std_logic_vector(31 downto 0);
memory_rw: out std_logic;
memory_address: out std_logic_vector(31 downto 0);
memory_data_out: out std_logic_vector(31 downto 0);
memory_data_in: in std_logic_vector(31 downto 0);

writeback: out std_logic_vector( 31 downto 0);

reg_dest_in: in std_logic_vector(4 downto 0);
reg_dest_out: out std_logic_vector(4 downto 0));
end entity MemoryStage

architecture behavioral of MemoryStage is
	begin
	output: process ( clk, rst, data_in, aluResult_in, memory_data_in, reg_dest_in) is
		begin
	
end output
end architecture behavioral

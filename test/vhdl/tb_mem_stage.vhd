-- revision history:
-- 05.08.2015     Carlos Minamisava Faria    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_mem_stage is
end entity tb_mem_stage;

architecture behav_tb_mem_stage of tb_mem_stage is

  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;

  -- -------- MEM_STAGE INTERFACE -----------------
  signal clk                  : std_logic         := '0';
  signal rst                  : std_logic;
  signal test_alu          : std_logic_vector(31 downto 0);
  signal test_data_in      : std_logic_vector(31 downto 0);

  signal test_data_addr          : std_logic_vector(31  downto 0);
  signal test_data_from_cpu          : std_logic_vector(31  downto 0);
  signal test_data_to_cpu          : std_logic_vector(31  downto 0);

  signal test_writeback          : std_logic_vector(31  downto 0);

  signal test_mux		: std_logic;	-- FSS decision for writeback

  signal test_dest_in          : std_logic_vector(31  downto 0);
  signal test_dest_out          : std_logic_vector(31  downto 0);

  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish           : std_logic;


  begin

  -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  -- MEM_STAGE
  u1_mem_stage: entity work.MemoryStage(behavioral)
    PORT MAP(clk, rst, test_alu, test_data_in, test_data_addr, test_data_from_cpu, test_data_to_cpu,
		test_mux, test_writeback, test_dest_in, test_dest_out);

  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '1';
wait for 1 ns;
	-- Test mem_stage passes the value read from memory
	-- test_data_to_cpu=0101_0100
	-- test_writeback= 0101_0100
    test_data_in <= x"0000_0010";
    test_data_to_cpu <= x"0101_0100";	
    test_mux <= '0';
    wait for 3 ns;
	-- Test mem_stage passes the value from ALU
	-- test_alu = FF10_8543
	-- test_data_to_cpu=0101_0100
	-- test_writeback= FF10_8543
	test_alu <= x"FF10_8543";
    test_mux <= '1';
    wait for 3 ns;
    test_data_to_cpu <= x"0000_0000";	
    wait for 3 ns;
	-- Test mem_stage passes the value read from memory
	-- test_data_to_cpu=0000_0000
	-- test_writeback= 0000_0000
    test_mux <= '0';
    wait for 3 ns;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_mem_stage;

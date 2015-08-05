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
  signal test_in_data_in      : std_logic_vector(31 downto 0);

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
  u1_mem_stage: entity work.mem_stage(behave)
    PORT MAP(clk, rst, test_alu, test_data, test_data_addr, test_data_from_cpu, test_data_to_cpu,
		test_mux, test_dest_in, test_dest_out);

  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '0';
    test_alu <= x"0000_0001";
    test_data <= x"0000_0010";
    test_data_to_cpu <= x"0101_0100";	
    test_mux <= b"0";
    wait for 1 ns;
    test_mux <= b"1";
    wait for 1 ns;
    test_data_to_cpu <= x"000_0000";	
    wait for 1 ns;
    test_mux <= b"0";
    wait for 1 ns;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_mem_stage;

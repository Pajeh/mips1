-- revision history:
-- 07.08.2015     Patrick Appenheimer    created


library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_fsm is
end entity tb_fsm;

architecture behav_tb_fsm of tb_fsm is
  
  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;

  -- -------- FSM INTERFACE -----------------
  signal clk                  : std_logic         := '0';
  signal rst                  : std_logic;
  signal test_pc_mux          : std_logic;
  signal test_instr           : std_logic_vector(31 downto 0);
  signal test_regdest_mux     : std_logic_vector(1 downto 0);
  signal test_regshift_mux    : std_logic_vector(1 downto 0);
  signal test_enable_regs     : std_logic;
  signal test_in_mux1	      : std_logic_vector(1 downto 0);
  signal test_in_mux2	      : std_logic_vector(1 downto 0);
  signal test_alu_instr       : std_logic_vector(5  downto 0);  
  signal test_zero            : std_logic_vector(0 downto 0);
  signal test_memstg_mux      : std_logic;
  signal test_rd_mask         : std_logic_vector(3 downto 0);
  signal test_wr_mask         : std_logic_vector(3 downto 0);
  signal test_instr_stall     : std_logic;
  signal test_data_stall      : std_logic;
  signal test_stage_control   : std_logic_vector(4 downto 0);
  
  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish           : std_logic;




  begin

  -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  -- FSM
  u1_fsm: entity work.fsm(behavioral)
    PORT MAP(clk, rst, test_pc_mux, test_instr, test_regdest_mux, test_regshift_mux, test_enable_regs, test_in_mux1, test_in_mux2,
		test_alu_instr, test_zero, test_memstg_mux, test_rd_mask, test_wr_mask, test_instr_stall, test_data_stall, test_stage_control);


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '0';

    wait for 1 ns;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_fsm;

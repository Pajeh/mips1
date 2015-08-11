-- revision history:
-- 2015-08-06       Carlos Minamisava Faria        created

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.cpu_pack.all;

entity tb_cpu_control is
end entity tb_cpu_control;

architecture behavioural of tb_cpu_control is

  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME                                                           : time                           := 2000 ps;
  constant RST_TIME                                                           : time                           := 30 ns;
  -- -------- CPU CONTROL  -----
  signal clk, rst, instr_stall, data_stall, memstg, id_enable_regs, in_mux_pc : std_logic                      := '0';
  signal instr_addr, data_addr, data_to_cpu, data_from_cpu                    : std_logic_vector (31 downto 0) := x"00000000";
  signal alu_op                                                               : std_logic_vector (5 downto 0)  := "000000";
  signal exc_mux1, exc_mux2, id_regdest_mux, id_regshift_mux                  : std_logic_vector(1 downto 0)   := "00";
  signal exc_alu_zero                                                         : std_logic_vector(0 downto 0)   := "0";
  signal stage_control                                                        : std_logic_vector(4 downto 0)   := "11111";
  signal rd_mask, wr_mask                                                     : std_logic_vector(3 downto 0)   := "0000";
  -- Tweak clock frequency here
  constant clk_time                                                           : time                           := 10 ns;
begin
  -- GENERAL CONTROL SIGNALS
  clk <= not clk after CLK_TIME;
  --rst   <= '1', '0'     after RST_TIME;

  -- datapath
  u1_control : entity work.cpu_control(structure_cpu_control)
    port map(
      clk           => clk,
      rst           => rst,
      instr_addr    => instr_addr,
      data_addr     => data_addr,
      rd_mask       => rd_mask,
      wr_mas        => wr_mas,
      instr_stall   => instr_stall,
      data_stall    => data_stall,
      instr_in      => instr_in,
      data_to       => data_to,
      data_from     => data_from,
      alu_op        => alu_op,
      exc_mux1      => exc_mux1,
      exc_mux2      => exc_mux2,
      exc_alu       => exc_alu,
      memstg_mux    => memstg_mux,
      id_regdest    => id_regdest,
      id_regshift   => id_regshift,
      id_enable     => id_enable,
      in_mux        => in_mux,
      stage_control => stage_control
      );
  );


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish <= '0';

    rst                  <= '0';
    test_stage_control   <= b"11111";
    wait for 2*CLK_TIME;
    rst                  <= '1';
    wait for CLK_TIME;
    -- ADDI ==> Opcode: 0010_00 rs: 0_0001 rt: 0_0010 im: 0000_0000_0000_0001
    instr_in        <= b"0010_00_00_001_0_0010_0000_0000_0000_0001";
    -- test_alu_op          <= b"10_0000";
    -- test_exc_mux1        <= b"10";
    -- test_exc_mux2        <= b"01";
    -- test_memstg_mux      <= '1';
    -- test_id_regdest_mux  <= b"10";
    -- test_id_regshift_mux <= b"00";
    -- test_id_enable_regs  <= '0';
    -- test_in_mux_pc       <= '0';
  end process test_process;
end architecture;

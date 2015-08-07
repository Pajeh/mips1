-- revision history:
-- 06.08.2015     Patrick Appenheimer    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_cpu_datapath is
end entity tb_cpu_datapath;

architecture behav_tb_cpu_datapath of tb_cpu_datapath is
  
  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2000 ps;
  constant RST_TIME           : time              := 30 ns;

  -- -------- ALU INTERFACE -----------------
  signal clk                 	    : std_logic         := '0';
  signal rst                 	    : std_logic;
  signal test_instr_addr     	    : std_logic_vector(31 downto 0);
  signal test_data_addr     	    : std_logic_vector(31 downto 0);
  signal test_instr_in      	    : std_logic_vector(31 downto 0);
  signal test_data_to_cpu           : std_logic_vector(31 downto 0);
  signal test_data_from_cpu         : std_logic_vector(31 downto 0);
  signal test_alu_op                : std_logic_vector(5 downto 0);
  signal test_exc_mux1              : std_logic_vector(1 downto 0);
  signal test_exc_mux2              : std_logic_vector(1 downto 0);
  signal test_exc_alu_zero          : std_logic_vector(0 downto 0);
  signal test_memstg_mux            : std_logic;
  signal test_id_regdest_mux        : std_logic_vector (1 downto 0);
  signal test_id_regshift_mux       : std_logic_vector (1 downto 0);
  signal test_id_enable_regs        : std_logic;
  signal test_in_mux_pc             : std_logic;
  signal test_stage_control	    : std_logic_vector (4 downto 0);
  
  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish           : std_logic;
  

  begin

  -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  --rst   <= '1', '0'     after RST_TIME;

  -- datapath
  u1_datapath: entity work.cpu_datapath(structure_cpu_datapath)
    PORT MAP(clk, rst, test_instr_addr, test_data_addr, test_instr_in, test_data_to_cpu, test_data_from_cpu, test_alu_op, test_exc_mux1, test_exc_mux2,
		test_exc_alu_zero, test_memstg_mux, test_id_regdest_mux, test_id_regshift_mux, test_id_enable_regs, test_in_mux_pc, test_stage_control);


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '0';
    
	rst <= '0';
	test_stage_control <= b"11111";
        wait for 2*CLK_TIME;
        rst <= '1';	
	wait for CLK_TIME;
	-- ADDI ==> Opcode: 0010_00 rs: 0_0001 rt: 0_0010 im: 0000_0000_0000_0001
	test_instr_in <= b"0010_00_00_001_0_0010_0000_0000_0000_0001";
	test_alu_op <= b"10_0000";
	test_exc_mux1 <= b"10";
	test_exc_mux2 <= b"01";
	test_memstg_mux <= '1';
	test_id_regdest_mux <= b"10";
	test_id_regshift_mux <= b"00";
	test_id_enable_regs <= '0';
	test_in_mux_pc <= '0';
    	wait for 5*CLK_TIME;
    	-- SUB ==> Opcode: 0000_00 rs: 0_0010 rt: 0_0010 rd: 0_0011 func: 10_0010
	test_instr_in <= b"000000_00010_00010_00011_00000100010";
	test_alu_op <= b"10_0010";
	test_exc_mux1 <= b"10";
	test_exc_mux2 <= b"00";
	test_memstg_mux <= '1';
	test_id_regdest_mux <= b"00";
	test_id_regshift_mux <= b"00";
	test_id_enable_regs <= '1';
	test_in_mux_pc <= '1';

    
    
    wait for 5*CLK_TIME;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_cpu_datapath;

-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;
  use WORK.memory_pack.memory;

entity tb_cpu is
end entity tb_cpu;

architecture behav_tb_cpu of tb_cpu is
  
   -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;

  constant INIT_RISE          : time              := 1 ns; 
  constant SIGNAl_ACTIVE      : time              := 2 ns;

  constant FULL_MIPS_SET      : string            := "OF";

  -- -------- CPU INTERFACE -----------------
  signal clk                  : std_logic         := '0';
  signal rst                  : std_logic;
  signal instr_addr           : std_logic_vector(31 downto 0);
  signal data_addr            : std_logic_vector(31 downto 0);
  signal rd_mask              : std_logic_vector(3  downto 0);
  signal wr_mask              : std_logic_vector(3  downto 0);
  signal instr_stall          : std_logic;
  signal data_stall           : std_logic;
  signal instr_in             : std_logic_vector(31 downto 0);
  signal data_to_cpu          : std_logic_vector(31 downto 0);
  signal data_from_cpu        : std_logic_vector(31 downto 0);

  -- ------ MEMORY INIT ----------------------
  signal init                 : std_logic := '0';  
  
  -- ------ SIMULATION CONTROL ---------------
  signal sim_enable           : std_logic := '0';
  signal sim_finish           : std_logic;

  signal exec_done            : std_logic;
  signal ff_exec_done         : std_logic := '0';

  -- simulation memory
  for u2_memory: memory use entity WORK.memory(simulation_memory);

  -- full MIPS I instruction set test memory
  -- for u2_memory: memory use entity WORK.memory(behav_memory);

  -- FPGA memory
  -- for u2_memory: memory use entity WORK.memory(fpga_memory);

begin ---------------- BEGIN ------------------ BEGIN -------------------------
  --
  -- GENERAL CONTROL SIGNAL
  --
  clk   <= not clk      after CLK_TIME;
  rst   <= '0', '1'     after RST_TIME;

  -- ____ ___  _  _ 
  -- |    |__] |  | 
  -- |___ |    |__| 
  u1_cpu: cpu
    PORT MAP(
      clk           => clk,           rst         => rst,
      instr_in      => instr_in,      data_to_cpu => data_to_cpu,
      instr_stall   => instr_stall,   data_stall  => data_stall,
      instr_addr    => instr_addr,    data_addr   => data_addr,
      rd_mask       => rd_mask,       wr_mask     => wr_mask,
      data_from_cpu => data_from_cpu
    );

  -- _  _ ____ _  _ ____ ____ _   _ 
  -- |\/| |___ |\/| |  | |__/  \_/  
  -- |  | |___ |  | |__| |  \   |   
  u2_memory: memory
    PORT MAP(
      clk         => clk,          rst         => rst,
      wr_mask     => wr_mask,      rd_mask     => rd_mask,
      instr_stall => instr_stall,  data_stall  => data_stall,
      prog_addr   => instr_addr,   data_addr   => data_addr,
      prog_out    => instr_in,     data_in     => data_from_cpu,
      data_out    => data_to_cpu
    );

  -- --------------------------------------------------------------------------
  -- _  _ ____ _ _  _    ___  ____ ____ ____ ____ ____ ____ 
  -- |\/| |__| | |\ |    |__] |__/ |  | |    |___ [__  [__  
  -- |  | |  | | | \|    |    |  \ |__| |___ |___ ___] ___] 
  test_process:
  process
  begin
    init         <= '0';
    sim_finish   <= '0';

    -- ------- INITIALISE MEMORY -----------------------
    wait for INIT_RISE;     init        <= '1';    
    wait for SIGNAL_ACTIVE; init        <= '0';
    -- -- ------- EXECUTION RUN ---------------------------
    wait until ff_exec_done = '1';
    -- ------- FINISH SIMULATION ----------------------
                            sim_finish  <= '1';
    wait;
  end process;

  -- --------------------------------------------------------------------------
  -- ____ _  _ _    _       _  _ _ ___  ____    ____ ____ ___ 
  -- |___ |  | |    |       |\/| | |__] [__     [__  |___  |  
  -- |    |__| |___ |___    |  | | |    ___]    ___] |___  |  
  --
  -- switch on some debug output for full mips set test
  --
  full_mips_set_debug: if FULL_MIPS_SET = "ON" generate
    component functions is
      generic(
        CORE       : string(2 downto 1);
        ADDR_LIMIT : integer
      );
      port(
        addr       : in integer
      );
    end component functions;

    signal i_prog_addr        : integer     := 0;
  begin
    -- --------------------------------------------------------------------------
    -- ____ _ _  _ _  _ _    ____ ___ _ ____ _  _    ____ ____ _  _ ___ ____ ____ _    
    -- [__  | |\/| |  | |    |__|  |  | |  | |\ |    |    |  | |\ |  |  |__/ |  | |    
    -- ___] | |  | |__| |___ |  |  |  | |__| | \|    |___ |__| | \|  |  |  \ |__| |___ 
    --
    -- activate simulation control
    --
    sim_enable   <= '1' after INIT_RISE;

    --
    -- get simulation control signals
    --
    exec_done  <= sim_enable when i_sim_control.sim_finish  /= '0' else '0';

    --
    -- algorithm execution done signal is synchron to enable flush
    --
    process(clk)
    begin
      if rising_edge( clk ) then
        if rst = '1' then ff_exec_done     <= '0';
        else              ff_exec_done     <= exec_done;
        end if;
      end if;            
    end process;  


    i_prog_addr <= to_integer(unsigned(instr_addr(24 downto 0)));

    fnct_unit: functions
      GENERIC MAP( CORE   => "00", ADDR_LIMIT    => 2326528)
      PORT MAP(    addr   => i_prog_addr);
  end generate;

end architecture behav_tb_cpu;

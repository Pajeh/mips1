-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;
  use WORK.memory_pack.memory;
  use WORK.uart_pack.uart;

entity hdllab is
  port(
    -- general: CLK and RESET
    clk_p                     : in  std_logic;
    clk_n                     : in  std_logic;
    rst                       : in  std_logic;
    -- UART interface
    rx                        : in  std_logic;
    tx                        : out std_logic;
    -- LED indication
    leds                      : out std_logic_vector(7 downto 0)
  );
end entity hdllab;


architecture behav_hdllab of hdllab is

  -- ____ ____ _  _ ___  ____ _  _ ____ _  _ ___ ____ 
  -- |    |  | |\/| |__] |  | |\ | |___ |\ |  |  [__  
  -- |___ |__| |  | |    |__| | \| |___ | \|  |  ___] 
  --
  -- PLL for clock generation
  --
  component hdllab_pll is
  port ( CLKIN1_N_IN  : in    std_logic; 
         CLKIN1_P_IN  : in    std_logic; 
         RST_IN       : in    std_logic; 
         CLKFBOUT_OUT : out   std_logic; 
         CLKOUT0_OUT  : out   std_logic; 
         LOCKED_OUT   : out   std_logic);
  end component;

  --
  -- general control signals
  --
  signal sys_clk              : std_logic;
  signal pll_lock             : std_logic;

  --
  -- -------- UART interface ------
  --
  signal t_req                : std_logic;    -- write request
  signal t_ack                : std_logic;    -- write acknowledge
  signal t_data               : std_logic_vector(7 downto 0);
  signal r_req                : std_logic;    -- read request
  signal r_ack                : std_logic;    -- read acknowledge
  signal r_data               : std_logic_vector(7 downto 0);

  --
  -- -------- CPU INTERFACE --------
  --
  signal instr_addr           : std_logic_vector(31 downto 0);
  signal data_addr,
       i_data_addr            : std_logic_vector(31 downto 0);
  signal rd_mask              : std_logic_vector(3  downto 0);
  signal wr_mask,
       i_wr_mask              : std_logic_vector(3  downto 0);
  signal instr_stall,
       i_instr_stall          : std_logic;
  signal data_stall           : std_logic;
  signal instr_in             : std_logic_vector(31 downto 0);
  signal data_to_cpu          : std_logic_vector(31 downto 0);
  signal data_from_cpu,
       i_data_from_cpu        : std_logic_vector(31 downto 0);

  --
  -- TB control signals
  --
  --
  -- state machine
  --
  type t_state is (sIDLE, sUART, sCPU);
  signal state, n_state       : t_state;

  type t_addr is
    record
      load                    : std_logic;              -- load initial value
      inc                     : std_logic;              -- increment
      full                    : std_logic;              -- indicate full memory
      val                     : unsigned(7 downto 0);   -- current memory addr
    end record;

  signal addr                 : t_addr;
  constant MEM_ADDR_INIT      : unsigned(7 downto 0) := (others => '0');

  --
  -- main CPU switch
  --
  signal cpu_switch           : std_logic;

  --
  -- Full design only with FPGA memory
  --
  for u2_memory: memory use entity WORK.memory(fpga_memory);

begin ---------------- BEGIN ------------------ BEGIN -------------------------

  process( sys_clk )
  begin
    if rising_edge( sys_clk ) then
      if rst = '1' then
        state           <= sIDLE;

        addr.val        <= MEM_ADDR_INIT;
      else
        state           <= n_state;

        if addr.load = '1' then
          addr.val      <= MEM_ADDR_INIT + 1;
        elsif addr.inc = '1' then
          addr.val      <= addr.val      + 1;
        end if;
      end if;
    end if;
  end process;

  --
  -- address value is counter one round
  --
  addr.full    <= '1' when addr.val = MEM_ADDR_INIT else '0';

  --
  -- TEST BENCH STATE LOGIC
  --
  tb_state_logic:
  process( state, r_req, addr.full )
  begin
    --
    -- ######## DEFAULT ###########
    --
    -- memory address contorl
    --
    addr.load           <= '0';         -- no load
    addr.inc            <= '0';         -- no increment

    --
    -- UART interface
    --
    r_ack               <= '0';         -- no acknowledge

    --
    -- main CPU switch
    --
    cpu_switch          <= '0';         -- switch to TB logic

    --
    -- state
    --
    n_state             <= sIDLE;       -- wait for data over UART

    --
    -- ######### STATE LOGIC ######
    --
    case state is
      -- <<<<<<<<<<< IDLE >>>>>>>>
      when sIDLE  =>  
        if r_req = '1' then             -- data comes over UART
          addr.load     <= '1';         -- load initial value
          r_ack         <= '1';         -- acknowlege data
          n_state       <= sUART;       -- go to UART logic
        end if;

      -- <<<<<<<<<<<< UART >>>>>>>
      when sUART  => 
        n_state         <= sUART;       -- remain in the state

        if addr.full = '1' then         -- all data are written to memory
          n_state       <= sCPU;
        elsif r_req = '1' then          -- data are coming over UART
          r_ack         <= '1';         -- acknowledge them
          addr.inc      <= '1';         -- get next memory address
        end if;

      -- <<<<<<<<<<<<< CPU >>>>>>
      when sCPU   =>
        cpu_switch      <= '1';         -- apply main CPU switch to CPU <-> MEMORY
        n_state         <= sCPU;        -- remain in the state

    end case;
  end process;



  --
  -- UART SEND LOGIC is unused
  --
  t_req                 <= '0';
  t_data                <= (others => '0');

  -- _  _ ____ _ _  _    _  _ _  _ _  _ 
  -- |\/| |__| | |\ |    |\/| |  |  \/  
  -- |  | |  | | | \|    |  | |__| _/\_ 
  --
  -- connects control signal to TB or CPU
  --
  i_instr_stall   <= instr_stall    when cpu_switch = '1' else '1';                                       -- instruction stall -> stops CPU 
  i_data_addr     <= data_addr      when cpu_switch = '1' else x"0000_00" & std_logic_vector(mem_addr);   -- memory address
  i_wr_mask       <= wr_mask        when cpu_switch = '1' else "0001";                                    -- write bytes to memory
  i_data_from_cpu <= data_from_cpu  when cpu_switch = '1' else std_logic_vector(r_data) &                 -- data to memory
                                                               std_logic_vector(r_data) & 
                                                               std_logic_vector(r_data) & 
                                                               std_logic_vector(r_data);  

  -- ____ ___  _  _ 
  -- |    |__] |  | 
  -- |___ |    |__| 
  u1_cpu: cpu
    PORT MAP(
      clk           => sys_clk,       rst         => rst,
      instr_in      => instr_in,      data_to_cpu => data_to_cpu,
      instr_stall   => i_instr_stall, data_stall  => data_stall,
      instr_addr    => instr_addr,    data_addr   => data_addr,
      rd_mask       => rd_mask,       wr_mask     => wr_mask,
      data_from_cpu => data_from_cpu
    );

  -- _  _ ____ _  _ ____ ____ _   _ 
  -- |\/| |___ |\/| |  | |__/  \_/  
  -- |  | |___ |  | |__| |  \   |   
  u2_memory: memory
    PORT MAP(
      clk         => sys_clk,      rst         => rst,
      wr_mask     => i_wr_mask,    rd_mask     => rd_mask,
      instr_stall => instr_stall,  data_stall  => data_stall,
      prog_addr   => instr_addr,   data_addr   => i_data_addr,
      prog_out    => instr_in,     data_in     => i_data_from_cpu,
      data_out    => data_to_cpu,  leds        => leds
    );

  -- _  _ ____ ____ ___ 
  -- |  | |__| |__/  |  
  -- |__| |  | |  \  |  
  u3_uart: uart
    PORT MAP(
      clk     => sys_clk,         rst          => rst,

      t_req   => t_req,           t_ack        => t_ack,
      t_data  => t_data,
      r_req   => r_req,           r_ack        => r_ack,
      r_data  => r_data,

      rx      => rx,              tx           => tx
    );

  -- ___  _    _    
  -- |__] |    |    
  -- |    |___ |___ 
  u4_pll: hdllab_pll
    PORT MAP(
      CLKIN1_N_IN     => clk_n,   CLKIN1_P_IN => clk_p,
      RST_IN          => '0',
      CLKFBOUT_OUT    => open,
      CLKOUT0_OUT     => sys_clk,
      LOCKED_OUT      => pll_lock
    );
               

end behav_hdllab;

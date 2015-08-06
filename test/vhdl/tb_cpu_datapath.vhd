-- revision history:
-- 2015-08-06       Lukas Jaeger        created

entity tb_cpu_datapath is
end entity tb_cpu_datapath;

architecture behavioural of tb_cpu_datapath is
    component cpu_datapath
    port(
      clk                   : in  std_logic;
      rst                   : in  std_logic;
      instr_addr            : out std_logic_vector(31 downto 0);
      data_addr             : out std_logic_vector(31 downto 0);
      instr_in              : in  std_logic_vector(31 downto 0);
      data_to_cpu           : in  std_logic_vector(31 downto 0);
      data_from_cpu         : out std_logic_vector(31 downto 0);
      alu_op                : in  std_logic_vector(5 downto 0);
      exc_mux1              : in  std_logic_vector(1 downto 0);
      exc_mux2              : in  std_logic_vector(1 downto 0);
      exc_alu_zero          : out std_logic_vector(0 downto 0);
      memstg_mux            : in  std_logic;
      id_regdest_mux        : in std_logic_vector (1 downto 0);
      id_regshift_mux       : in std_logic_vector (1 downto 0);
      id_enable_regs        : in std_logic;
      in_mux_pc             : in std_logic_vector(0 downto 0)      
    );
    end component;
    
    signal clk, rst, memstg_mux, id_enable_regs : std_logic;
    signal instr_in, data_to_cpu, : std_logic_vector (31 downto 0);
    signal alu_op : std_logic_vector (5 downto 0);
    signal exc_mux1, exc_mux2, id_regdest_mux. id_regshift_mux : std_logic_vector(1 downto 0);
    signal exc_alu_zero, in_mux_pc : std_logic_vector(0 downto 0);
    -- Tweak clock frequency here
    constant clk_time : time := 10 ns;
    begin
        dut: cpu_datapath port map(
            clk => clk,
            rst => rst,
            instr_in => instr_in,
            data_to_cpu => data_to_cpu,
            alu_op => alu_op,
            exc_mux1 => exc_mux1,
            exc_mux2 => exc_mux2,
            memstg_mux => memstg_mux,
            id_regdest_mux => id_regdest_mux,
            id_regshift_mux => id_regshift_mux,
            id_enable_regs => id_enable_regs,
        );
        clk_proc : process
        begin
               clk <= '0';
                wait for clk_time / 2;
                clk <= '1';
                wait for clk_time / 2;
        end process;
    end architecture;

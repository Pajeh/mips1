-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 05.08.2015     Patrick Appenheimer    first try
-- 06.08.2015     Patrick Appenheimer    ports and entities added


entity cpu_datapath is
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
      exc_alu_zero          : out std_logic_vector(0 downto 0)
      
    );

end entity cpu_datapath;


architecture structure_cpu_datapath of cpu_datapath is

  -- -------- Instr. Fetch ==> Instr. Decode -----------------
  signal instr_1         : std_logic_vector(31 downto 0);
  signal ip_1            : std_logic_vector(31 downto 0);
  
  -- -------- Instr. Decode ==> Execution -----------------
  signal shift_2          : std_logic_vector(4 downto 0);
  signal reg_a_2          : std_logic_vector(31 downto 0);
  signal reg_b_2          : std_logic_vector(31 downto 0);
  signal regdest_2        : std_logic_vector(4 downto 0);
  signal imm_2            : std_logic_vector(31 downto 0);
  signal ip_2             : std_logic_vector(31 downto 0);

  -- -------- Execution ==> Memory Stage -----------------
  signal alu_result_3     : std_logic_vector(31 downto 0);
  signal data_3           : std_logic_vector(31 downto 0);
  signal regdest_3        : std_logic_vector(4 downto 0);

  -- -------- Memory Stage ==> Write Back -----------------
  signal writeback_4      : std_logic_vector(31 downto 0);
  signal regdest_4        : std_logic_vector(4 downto 0);


begin

-- INSTRUCTION FETCH:
instruction_fetch:    entity work.instruction_fetch(behavioral) port map(  TODO );

-- INSTRUCTION DECODE:
instruction_decode:   entity work.instruction_decode(behavioral) port map(  TODO );

-- EXECUTION:
variable alu_result   : std_logic_vector(31 downto 0);
variable data_out     : std_logic_vector(31 downto 0);
variable destreg_out  : std_logic_vector(4  downto 0);
execution:            entity work.execution(behave) port map(clk, rst, alu_result, data_out, destreg_out,
                                                              exc_alu_zero, reg_a_2, reg_b_2, regdest_2, imm_2,
                                                              ip_2, shift_2, exc_mux1, exc_mux2,alu_op);

-- MEMORY STAGE:
memory_stage:         entity work.MemoryStage(behavioral) port map(  TODO );

-- WRITE BACK:
write_back:           entity work.write_back(behavioral) port map(  TODO );

process(clk, rst)
begin
  if (rst = '0') then
    alu_result_3 <= (others => '0');
    data_3 <= (others => '0');
    regdest_3 <= (others => '0');
  elsif (rising_edge(clk)) then
    alu_result_3 <= alu_result;
    data_3 <= data_out;
    regdest_3 <= destreg_out;
  end if;
end process;


end architecture structure_cpu_datapath;

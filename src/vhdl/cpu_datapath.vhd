-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 05.08.2015     Patrick Appenheimer    first try


entity cpu_datapath is

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

instruction_fetch:    entity work.instruction_fetch(behavioral) port map(  TODO );
instruction_decode:   entity work.instruction_decode(behavioral) port map(  TODO );
variable alu_result   : std_logic_vector(31 downto 0);
execution:            entity work.execution(behave) port map(,,alu_result,,,,,,,,,,,,);
memory_stage:         entity work.MemoryStage(behavioral) port map(  TODO );
write_back:           entity work.write_back(behavioral) port map(  TODO );

process(clk, rst)
begin
  if (rst = '0') then
    alu_result_3 <= (others => '0');
    data_3 <= (others => '0');
    regdest_3 <= (others => '0');
  elsif (rising_edge(clk)) then
    alu_result_3 <= alu_result;
  end if;
end process;


end architecture structure_cpu_datapath;

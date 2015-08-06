-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 05.08.2015     Patrick Appenheimer    first try
-- 06.08.2015     Patrick Appenheimer    ports and entities added

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;

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
      exc_alu_zero          : out std_logic_vector(0 downto 0);
      memstg_mux            : in  std_logic;
      id_regdest_mux        : in std_logic_vector (1 downto 0);
      id_regshift_mux       : in std_logic_vector (1 downto 0);
      id_enable_regs        : in std_logic;
      in_mux_pc             : in std_logic_vector(0 downto 0)
      
    );

end entity cpu_datapath;


architecture structure_cpu_datapath of cpu_datapath is

  signal mux_out_0       : std_logic_vector(31 downto 0);

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
variable if_ip      : std_logic_vector(31 downto 0);
variable if_instr   : std_logic_vector(31 downto 0);
instruction_fetch:    entity work.instruction_fetch(behavioral) port map(clk, rst, mux_pc_out, instr_in, if_ip,
                                                                          instr_addr, if_instr);

-- INSTRUCTION DECODE:
variable id_a       : std_logic_vector(31 downto 0);
variable id_b       : std_logic_vector(31 downto 0);
variable id_imm     : std_logic_vector(31 downto 0);
variable id_ip      : std_logic_vector(31 downto 0);
variable id_regdest : std_logic_vector(4 downto 0);
variable id_shift   : std_logic_vector(4 downto 0);
instruction_decode:   entity work.instruction_decode(behavioral) port map(instr_1, ip_1, wb_writeback_out, alu_result,
                                                                          memstg_writeback_out, exc_destreg_out,
                                                                          memstg_destreg_out, id_regdest_mux,
                                                                          id_regshift_mux, clk, rst, id_enable_regs,
                                                                          id_a, id_b, id_imm, id_ip, id_regdest, id_shift);

-- EXECUTION:
variable alu_result       : std_logic_vector(31 downto 0);
variable data_out         : std_logic_vector(31 downto 0);
variable exc_destreg_out  : std_logic_vector(4  downto 0);
execution:            entity work.execution(behave) port map(clk, rst, alu_result, data_out, exc_destreg_out,
                                                              exc_alu_zero, reg_a_2, reg_b_2, regdest_2, imm_2,
                                                              ip_2, shift_2, exc_mux1, exc_mux2,alu_op);

-- MEMORY STAGE:
variable memstg_writeback_out : std_logic_vector(31 downto 0);
variable memstg_destreg_out   : std_logic_vector(4  downto 0);
memory_stage:         entity work.MemoryStage(behavioral) port map(clk, rst, alu_result_3, data_3, data_addr,
                                                                    data_from_cpu, data_to_cpu, memstg_mux,
                                                                    memstg_writeback_out, regdest_3, memstg_destreg_out);

-- WRITE BACK:
variable wb_writeback_out : std_logic_vector(31 downto 0);
variable wb_destreg_out   : std_logic_vector(4  downto 0);
write_back:           entity work.write_back(behavioral) port map(clk, rst, writeback_4, regdest_4,
                                                                  wb_writeback_out, wb_destreg_out);

path: process(clk, rst)
begin
  if (rst = '0') then
    mux_out_0 <= (others => '0');
    instr_1 <= (others => '0');
    ip_1 <= (others => '0');
    shift_2 <= (others => '0');
    reg_a_2 <= (others => '0');
    reg_b_2 <= (others => '0');
    regdest_2 <= (others => '0');
    imm_2 <= (others => '0');
    ip_2 <= (others => '0');
    alu_result_3 <= (others => '0');
    data_3 <= (others => '0');
    regdest_3 <= (others => '0');
    writeback_4 <= (others => '0');
    regdest_4 <= (others => '0');
  elsif (rising_edge(clk)) then
    mux_out_0 <= mux_pc_out;
    instr_1 <= if_instr;
    ip_1 <= if_ip;
    shift_2 <= id_shift;
    reg_a_2 <= id_a;
    reg_b_2 <= id_b;
    regdest_2 <= id_regdest;
    imm_2 <= id_imm;
    ip_2 <= ip_1;
    alu_result_3 <= alu_result;
    data_3 <= data_out;
    regdest_3 <= destreg_out;
    writeback_4 <= memstg_writeback_out;
    regdest_4 <= memstg_destreg_out;
  end if;
end process;

variable mux_pc_out      : std_logic_vector(31 downto 0);

mux: process(in_mux_pc)
  begin
    case in_mux_pc is
      -- 0
      when "0" =>
      mux_pc_out <= ip_1;
      -- 1
      when "1" =>
      mux_pc_out <= id_ip;
    end case;
  end process;


end architecture structure_cpu_datapath;

-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 05.08.2015     Patrick Appenheimer    first try
-- 06.08.2015     Patrick Appenheimer    ports and entities added
-- 10.08.2015     Patrick Appenheimer    minor changes
-- 12.08.2015     Patrick Appenheimer    changed rising_edge to falling_edge
-- 14.08.2015     Patrick Appenheimer    changed pc_mux control

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;
  
  -- -- stage_control: --
  -- to activate registers, set signal stage_control as follows:
  -- stage0->stage1: xxxx1
  -- stage1->stage2: xxx1x
  -- stage2->stage3: xx1xx
  -- stage3->stage4: x1xxx
  -- stage4->stage5: 1xxxx

entity cpu_datapath is
  port(
      clk                   	: in  std_logic;
      rst                   	: in  std_logic;
      instr_addr            	: out std_logic_vector(31 downto 0);
      data_addr             	: out std_logic_vector(31 downto 0);
      instr_in              	: in  std_logic_vector(31 downto 0);
      data_to_cpu           	: in  std_logic_vector(31 downto 0);
      data_from_cpu         	: out std_logic_vector(31 downto 0);
      alu_op            	: in  std_logic_vector(5 downto 0);
      exc_mux1              	: in  std_logic_vector(1 downto 0);
      exc_mux2              	: in  std_logic_vector(1 downto 0);
      exc_alu_zero		: out std_logic_vector(0 downto 0);
      memstg_mux        	: in  std_logic;
      id_regdest_mux    	: in std_logic_vector (1 downto 0);
      id_regshift_mux       	: in std_logic_vector (1 downto 0);
      id_enable_regs		: in std_logic;
      in_mux_pc             	: in std_logic;
      stage_control		: in std_logic_vector (4 downto 0)
      
    );

end entity cpu_datapath;


architecture structure_cpu_datapath of cpu_datapath is

  -- -------- PC ==> Instr. Fetch -----------------
  signal mux_out_0       : std_logic_vector(31 downto 0);
  signal instr_0	 : std_logic_vector(31 downto 0);

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

-- IP:
  signal mux_pc_out      : std_logic_vector(31 downto 0);
  
-- Instr. Fetch:
  signal if_ip      : std_logic_vector(31 downto 0);
  signal if_instr   : std_logic_vector(31 downto 0);

-- Instr. Decode:
  signal id_a       : std_logic_vector(31 downto 0);
  signal id_b       : std_logic_vector(31 downto 0);
  signal id_imm     : std_logic_vector(31 downto 0);
  signal id_ip      : std_logic_vector(31 downto 0);
  signal id_regdest : std_logic_vector(4 downto 0);
  signal id_shift   : std_logic_vector(4 downto 0);

-- Execution:
  signal alu_result       : std_logic_vector(31 downto 0);
  signal data_out         : std_logic_vector(31 downto 0);
  signal exc_destreg_out  : std_logic_vector(4  downto 0);
  
-- Memory Stage:
  signal memstg_writeback_out : std_logic_vector(31 downto 0);
  signal memstg_destreg_out   : std_logic_vector(4  downto 0);

-- Write Back:
  signal wb_writeback_out : std_logic_vector(31 downto 0);
  signal wb_destreg_out   : std_logic_vector(4  downto 0);

  signal last_instruction : std_logic_vector( 31 downto 0);


begin

-- INSTRUCTION FETCH:
  instruction_fetch:    entity work.instruction_fetch(behavioral) port map(clk, rst, mux_out_0, instr_0, if_ip,
                                                                          instr_addr, if_instr);

-- INSTRUCTION DECODE:
  instruction_decode:   entity work.instruction_decode(behavioral) port map(instr_1, ip_1, wb_writeback_out, alu_result,
                                                                          memstg_writeback_out, regdest_4, exc_destreg_out,
                                                                          memstg_destreg_out, id_regdest_mux,
                                                                          id_regshift_mux, clk, rst, id_enable_regs,
                                                                          id_a, id_b, id_imm, id_ip, id_regdest, id_shift);

-- EXECUTION:
  execution:            entity work.execution(behave) port map(clk, rst, alu_result, data_out, exc_destreg_out,
                                                              exc_alu_zero, reg_a_2, reg_b_2, regdest_2, imm_2,
                                                              ip_2, shift_2, exc_mux1, exc_mux2,alu_op);

-- MEMORY STAGE:
  memory_stage:         entity work.MemoryStage(behavioral) port map(clk, rst, alu_result_3, data_3, data_addr,
                                                                    data_from_cpu, data_to_cpu, memstg_mux,
                                                                    memstg_writeback_out, regdest_3, memstg_destreg_out);

-- WRITE BACK:
  write_back:           entity work.write_back(behavioral) port map(clk, rst, writeback_4, regdest_4,
                                                                  wb_writeback_out, wb_destreg_out);

stage0: process(clk, rst)
begin
  if (rst = '1') then
    mux_out_0 <=  (others => '0');
    instr_0 <=	  (others => '0');
  elsif ((rising_edge(clk)) and (stage_control (0 downto 0) = "1")) then
    mux_out_0 <= mux_pc_out;
    instr_0 <=	 instr_in;
  end if;
end process;

stage1: process(clk, rst)
begin
  if (rst = '1') then
    instr_1 <= (others => '0');
    ip_1 <= (others => '0');
  elsif ((rising_edge(clk)) and (stage_control (1 downto 1) = "1")) then
    instr_1 <= if_instr;
    ip_1 <= if_ip;
  end if;
end process;

stage2: process(clk, rst)
begin
  if (rst = '1') then
    shift_2 <= (others => '0');
    reg_a_2 <= (others => '0');
    reg_b_2 <= (others => '0');
    regdest_2 <= (others => '0');
    imm_2 <= (others => '0');
    ip_2 <= (others => '0');
  elsif ((rising_edge(clk)) and (stage_control (2 downto 2) = "1")) then
    shift_2 <= id_shift;
    reg_a_2 <= id_a;
    reg_b_2 <= id_b;
    regdest_2 <= id_regdest;
    imm_2 <= id_imm;
    ip_2 <= ip_1;
  end if;
end process;

stage3: process(clk, rst)
begin
  if (rst = '1') then
    alu_result_3 <= (others => '0');
    data_3 <= (others => '0');
    regdest_3 <= (others => '0');
  elsif ((rising_edge(clk)) and (stage_control (3 downto 3) = "1")) then
    alu_result_3 <= alu_result;
    data_3 <= data_out;
    regdest_3 <= exc_destreg_out;
  end if;
end process;

stage4: process(clk, rst)
begin
  if (rst = '1') then
    writeback_4 <= (others => '0');
    regdest_4 <= (others => '0');
  elsif ((rising_edge(clk)) and (stage_control (4 downto 4) = "1")) then
    writeback_4 <= memstg_writeback_out;
    regdest_4 <= memstg_destreg_out;
  end if;
end process;

mux: process(in_mux_pc, id_ip, if_ip)
  begin
	if (in_mux_pc = '1')then
		mux_pc_out <= id_ip;
		mux_out_0 <= id_ip;
	else
		mux_pc_out <= if_ip;
	end if;
  end process;

--mux: process(instr_in, id_ip, if_ip, clk)
--  begin
--  	if (clk'event and clk = '1') then
--		if ((instr_in(31 downto 26) = "000100") or (instr_in(31 downto 26) = "000010") or (instr_in(31 downto 26) = "000101") or (instr_in(31 downto 26) = "011101"))then
--			mux_pc_out <= id_ip;
--		else
--			mux_pc_out <= if_ip;
--		end if;
--	end if;
--  end process;
  
last_instruction_proc: process(clk) is
begin
        if (clk'event and clk = '1') then
            last_instruction <= instr_in;
        end if;
end process;


end architecture structure_cpu_datapath;

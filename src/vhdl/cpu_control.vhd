-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 10.08.2015     Patrick Appenheimer    entity
-- 11.08.2015     Patrick Appenheimer    main fsm
-- 11.08.2015     Patrick Appenheimer    5 instr fsm

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;

library WORK;
use WORK.all;


entity cpu_control is
  port(
    clk             : in  std_logic;
    rst             : in  std_logic;
    rd_mask         : out std_logic_vector(3 downto 0);
    wr_mask         : out std_logic_vector(3 downto 0);
    instr_stall     : in  std_logic;
    data_stall      : in  std_logic;
    instr_in        : in  std_logic_vector(31 downto 0);
    alu_op          : out std_logic_vector(5 downto 0);
    exc_mux1        : out std_logic_vector(1 downto 0);
    exc_mux2        : out std_logic_vector(1 downto 0);
    exc_alu_zero    : in  std_logic_vector(0 downto 0);
    memstg_mux      : out std_logic;
    id_regdest_mux  : out std_logic_vector (1 downto 0);
    id_regshift_mux : out std_logic_vector (1 downto 0);
    id_enable_regs  : out std_logic;
    in_mux_pc       : out std_logic;
    stage_control   : out std_logic_vector (4 downto 0)
    );

end entity cpu_control;

architecture structure_cpu_control of cpu_control is

--      State Machine   --
  constant s0 : std_logic_vector(4 downto 0) := b"00000";
  constant s1 : std_logic_vector(4 downto 0) := b"00001";
  constant s2 : std_logic_vector(4 downto 0) := b"00010";
  constant s3 : std_logic_vector(4 downto 0) := b"00011";
  constant s4 : std_logic_vector(4 downto 0) := b"00100";

  type t_states is array (4 downto 0) of std_logic_vector(4 downto 0);
  signal currentstate : t_states := ((others => (others => '0')));
  signal nextstate    : t_states := ((others => (others => '0')));

  type t_output is array (4 downto 0) of std_logic_vector(29 downto 0);
  signal output_buffer : t_output                     := ((others => (others => '0')));
  signal rst_fsm       : std_logic_vector(4 downto 0) := (others  => '1');
  
begin
  fsm1 : entity work.fsm(behavioral) port map(clk, rst_fsm(0), nextstate(4), nextstate(0), currentstate(0), output_buffer(0), instr_in, instr_stall, data_stall);
  fsm2 : entity work.fsm(behavioral) port map(clk, rst_fsm(1), nextstate(0), nextstate(1), currentstate(1), output_buffer(1), instr_in, instr_stall, data_stall);
  fsm3 : entity work.fsm(behavioral) port map(clk, rst_fsm(2), nextstate(1), nextstate(2), currentstate(2), output_buffer(2), instr_in, instr_stall, data_stall);
  fsm4 : entity work.fsm(behavioral) port map(clk, rst_fsm(3), nextstate(2), nextstate(3), currentstate(3), output_buffer(3), instr_in, instr_stall, data_stall);
  fsm5 : entity work.fsm(behavioral) port map(clk, rst_fsm(4), nextstate(3), nextstate(4), currentstate(4), output_buffer(4), instr_in, instr_stall, data_stall);


  init : process(rst, currentstate)
  begin
    if rst'event and rst = '0' then     -- reset condition forwarded
      rst_fsm(4 downto 0) <= (others => '1');
    else
      -- if all currentstates are zero, we are at the initial condition
      if currentstate(0) = s0 and currentstate(1) = s0 and currentstate(2) = s0 and currentstate(3) = s0 and currentstate(4) = s0 then
        rst_fsm(4 downto 0) <= b"00001";
      elsif currentstate(1) = s0 and currentstate(2) = s0 and currentstate(3) = s0 and currentstate(4) = s0 then
        rst_fsm(4 downto 0) <= b"00011";
      elsif currentstate(2) = s0 and currentstate(3) = s0 and currentstate(4) = s0 then
        rst_fsm(4 downto 0) <= b"00111";
      elsif currentstate(3) = s0 and currentstate(4) = s0 then
        rst_fsm(4 downto 0) <= b"01111";
      else
        rst_fsm(4 downto 0) <= b"11111";
      end if;
    end if;
  end process init;

  output_s0 : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      id_regdest_mux  <= output_buffer(0) (28 downto 27);
      id_regshift_mux <= output_buffer(0) (26 downto 25);
    elsif (currentstate(1) = s1) then
      id_regdest_mux  <= output_buffer(1) (28 downto 27);
      id_regshift_mux <= output_buffer(1) (26 downto 25);
    elsif (currentstate(2) = s2) then
      id_regdest_mux  <= output_buffer(2) (28 downto 27);
      id_regshift_mux <= output_buffer(2) (26 downto 25);
    elsif (currentstate(3) = s3) then
      id_regdest_mux  <= output_buffer(3) (28 downto 27);
      id_regshift_mux <= output_buffer(3) (26 downto 25);
    elsif (currentstate(4) = s4) then
      id_regdest_mux  <= output_buffer(4) (28 downto 27);
      id_regshift_mux <= output_buffer(4) (26 downto 25);
    end if;
  end process output_s0;

  output_s1 : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      exc_mux1          <= output_buffer(0) (23 downto 22);
      exc_mux2          <= output_buffer(0) (21 downto 20);
      alu_op            <= output_buffer(0) (19 downto 14);
      in_mux_pc         <= output_buffer(0) (29);
      stage_control (2) <= output_buffer(0) (2);
    elsif (currentstate(1) = s1) then
      exc_mux1          <= output_buffer(1) (23 downto 22);
      exc_mux2          <= output_buffer(1) (21 downto 20);
      alu_op            <= output_buffer(1) (19 downto 14);
      in_mux_pc         <= output_buffer(1) (29);
      stage_control (2) <= output_buffer(1) (2);
    elsif (currentstate(2) = s2) then
      exc_mux1          <= output_buffer(2) (23 downto 22);
      exc_mux2          <= output_buffer(2) (21 downto 20);
      alu_op            <= output_buffer(2) (19 downto 14);
      in_mux_pc         <= output_buffer(2) (29);
      stage_control (3) <= output_buffer(2) (2);
    elsif (currentstate(3) = s3) then
      exc_mux1          <= output_buffer(3) (23 downto 22);
      exc_mux2          <= output_buffer(3) (21 downto 20);
      alu_op            <= output_buffer(3) (19 downto 14);
      in_mux_pc         <= output_buffer(3) (29);
      stage_control (2) <= output_buffer(3) (2);
    elsif (currentstate(4) = s4) then
      exc_mux1          <= output_buffer(4) (23 downto 22);
      exc_mux2          <= output_buffer(4) (21 downto 20);
      alu_op            <= output_buffer(4) (19 downto 14);
      in_mux_pc         <= output_buffer(4) (29);
      stage_control (2) <= output_buffer(4) (2);
    end if;
  end process output_s1;

  output_s2 : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      memstg_mux        <= output_buffer(0) (13);
      rd_mask           <= output_buffer(0) (12 downto 9);
      wr_mask           <= output_buffer(0) (8 downto 5);
      stage_control (3) <= output_buffer(0) (3);
    elsif (currentstate(1) = s1) then
      memstg_mux        <= output_buffer(1) (13);
      rd_mask           <= output_buffer(1) (12 downto 9);
      wr_mask           <= output_buffer(1) (8 downto 5);
      stage_control (3) <= output_buffer(1) (3);
    elsif (currentstate(2) = s2) then
      memstg_mux        <= output_buffer(2) (13);
      rd_mask           <= output_buffer(2) (12 downto 9);
      wr_mask           <= output_buffer(2) (8 downto 5);
      stage_control (3) <= output_buffer(2) (3);
    elsif (currentstate(3) = s3) then
      memstg_mux        <= output_buffer(3) (13);
      rd_mask           <= output_buffer(3) (12 downto 9);
      wr_mask           <= output_buffer(3) (8 downto 5);
      stage_control (3) <= output_buffer(3) (3);
    elsif (currentstate(4) = s4) then
      memstg_mux        <= output_buffer(4) (13);
      rd_mask           <= output_buffer(4) (12 downto 9);
      wr_mask           <= output_buffer(4) (8 downto 5);
      stage_control (3) <= output_buffer(4) (3);
    end if;
  end process output_s2;

  output_s3 : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      stage_control (4) <= output_buffer(0) (4);
    elsif (currentstate(1) = s1) then
      stage_control (4) <= output_buffer(1) (4);
     elsif (currentstate(2) = s2) then
      stage_control (4) <= output_buffer(2) (4);
     elsif (currentstate(3) = s3) then
      stage_control (4) <= output_buffer(3) (4);
     elsif (currentstate(4) = s4) then
      stage_control (4) <= output_buffer(4) (4);
     end if;
  end process output_s3;

  output_s4 : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      id_enable_regs <= output_buffer(0) (24);
    elsif (currentstate(1) = s1) then
      id_enable_regs <= output_buffer(1) (24);
    elsif (currentstate(2) = s2) then
      id_enable_regs <= output_buffer(2) (24);
    elsif (currentstate(3) = s3) then
      id_enable_regs <= output_buffer(3) (24);
    elsif (currentstate(4) = s4) then
      id_enable_regs <= output_buffer(4) (24);
    end if;
  end process output_s4;


end architecture structure_cpu_control;

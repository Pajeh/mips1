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
  signal output_buffer : t_output                       := ((others => (others => '0')));
  signal output        : std_logic_vector (29 downto 0) := (others  => '0');
  signal rst_fsm       : std_logic_vector(4 downto 0)   := (others  => '1');
  
begin
  fsm1 : entity work.fsm(behavioral) port map(clk, rst_fsm(0), nextstate(4), nextstate(0), currentstate(0), output_buffer(0), instr_in, instr_stall, data_stall);
  fsm2 : entity work.fsm(behavioral) port map(clk, rst_fsm(1), nextstate(0), nextstate(1), currentstate(1), output_buffer(1), instr_in, instr_stall, data_stall);
  fsm3 : entity work.fsm(behavioral) port map(clk, rst_fsm(2), nextstate(1), nextstate(2), currentstate(2), output_buffer(2), instr_in, instr_stall, data_stall);
  fsm4 : entity work.fsm(behavioral) port map(clk, rst_fsm(3), nextstate(2), nextstate(3), currentstate(3), output_buffer(3), instr_in, instr_stall, data_stall);
  fsm5 : entity work.fsm(behavioral) port map(clk, rst_fsm(4), nextstate(3), nextstate(4), currentstate(4), output_buffer(4), instr_in, instr_stall, data_stall);


  init : process(rst, currentstate)
  begin
    if rst = '0' then     -- reset condition forwarded
      rst_fsm(4 downto 0) <= (others => '0');
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


  output_if : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s0) then
      if currentstate(0) /= nextstate(0) then
        output(0) <= '1';
      else
        output(0) <= '0';
      end if;
    elsif (currentstate(1) = s0) then
      if currentstate(1) /= nextstate(1) then
        output(0) <= '1';
      else
        output(0) <= '0';
      end if;
    elsif (currentstate(2) = s0) then
      if currentstate(2) /= nextstate(2) then
        output(0) <= '1';
      else
        output(0) <= '0';
      end if;
    elsif (currentstate(3) = s0) then
      if currentstate(3) /= nextstate(3) then
        output(0) <= '1';
      else
        output(0) <= '0';
      end if;
    elsif (currentstate(4) = s0) then
      if currentstate(4) /= nextstate(4) then
        output(0) <= '1';
      else
        output(0) <= '0';
      end if;
    end if;
  end process output_if;

  output_ID : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s1) then
      output(28 downto 27) <= output_buffer(0) (28 downto 27);
      output(26 downto 25) <= output_buffer(0) (26 downto 25);
      output(29)           <= output_buffer(0) (29);
      if currentstate(0) /= nextstate(0) then
        output(1) <= '1';
      else
        stage_control (1) <= '0';
      end if;
    elsif (currentstate(1) = s1) then
      output(28 downto 27) <= output_buffer(1) (28 downto 27);
      output(26 downto 25) <= output_buffer(1) (26 downto 25);
      output(29)           <= output_buffer(1) (29);
      if currentstate(1) /= nextstate(1) then
        output(1) <= '1';
      else
        stage_control (1) <= '0';
      end if;
    elsif (currentstate(2) = s1) then
      output(28 downto 27) <= output_buffer(2) (28 downto 27);
      output(26 downto 25) <= output_buffer(2) (26 downto 25);
      output(29)           <= output_buffer(2) (29);
      if currentstate(2) /= nextstate(2) then
        output(1) <= '1';
      else
        output(1) <= '0';
      end if;
    elsif (currentstate(3) = s1) then
      output(28 downto 27) <= output_buffer(3) (28 downto 27);
      output(26 downto 25) <= output_buffer(3) (26 downto 25);
      output(29)           <= output_buffer(3) (29);
      if currentstate(3) /= nextstate(3) then
        output(1) <= '1';
      else
        stage_control (1) <= '0';
      end if;
    elsif (currentstate(4) = s1) then
      output(28 downto 27) <= output_buffer(4) (28 downto 27);
      output(26 downto 25) <= output_buffer(4) (26 downto 25);
      output(29)           <= output_buffer(4) (29);
      if currentstate(4) /= nextstate(4) then
        output(1) <= '1';
      else
        stage_control (1) <= '0';
      end if;
    end if;
  end process output_ID;

  output_ex : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s2) then
      output(23 downto 22) <= output_buffer(0) (23 downto 22);
      output(21 downto 20) <= output_buffer(0) (21 downto 20);
      output(19 downto 14) <= output_buffer(0) (19 downto 14);
      if currentstate(0) /= nextstate(0) then
        output(2) <= output_buffer(0) (2);
      else
        stage_control (2) <= '0';
      end if;
    elsif (currentstate(1) = s2) then
      output(23 downto 22) <= output_buffer(1) (23 downto 22);
      output(21 downto 20) <= output_buffer(1) (21 downto 20);
      output(19 downto 14) <= output_buffer(1) (19 downto 14);
      if currentstate(1) /= nextstate(1) then
        output(2) <= output_buffer(1) (2);
      else
        stage_control (2) <= '0';
      end if;

    elsif (currentstate(2) = s2) then
      output(23 downto 22) <= output_buffer(2) (23 downto 22);
      output(21 downto 20) <= output_buffer(2) (21 downto 20);
      output(19 downto 14) <= output_buffer(2) (19 downto 14);
      if currentstate(2) /= nextstate(2) then
        output(2) <= output_buffer(2) (2);
      else
        stage_control (2) <= '0';
      end if;

    elsif (currentstate(3) = s2) then
      output(23 downto 22) <= output_buffer(3) (23 downto 22);
      output(21 downto 20) <= output_buffer(3) (21 downto 20);
      output(19 downto 14) <= output_buffer(3) (19 downto 14);
      if currentstate(3) /= nextstate(3) then
        output(2) <= output_buffer(3) (2);
      else
        stage_control (2) <= '0';
      end if;

    elsif (currentstate(4) = s2) then
      output(23 downto 22) <= output_buffer(4) (23 downto 22);
      output(21 downto 20) <= output_buffer(4) (21 downto 20);
      output(19 downto 14) <= output_buffer(4) (19 downto 14);
      if currentstate(4) /= nextstate(4) then
        output(2) <= output_buffer(4) (2);
      else
        stage_control (2) <= '0';
      end if;

    end if;
  end process output_ex;

  output_me : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s3) then
      output(13)          <= output_buffer(0) (13);
      output(12 downto 9) <= output_buffer(0) (12 downto 9);
      output(8 downto 5)  <= output_buffer(0) (8 downto 5);
      if currentstate(0) /= nextstate(0) then
       output(3) <= '1';
      else
       output(3) <= '0';
      end if;
    elsif (currentstate(1) = s3) then
      output(13)          <= output_buffer(1) (13);
      output(12 downto 9) <= output_buffer(1) (12 downto 9);
      output(8 downto 5)  <= output_buffer(1) (8 downto 5);
      if currentstate(0) /= nextstate(0) then
        output(3) <= '1';
      else
       output(3) <= '0';
      end if;
    elsif (currentstate(2) = s3) then
      output(13)          <= output_buffer(2) (13);
      output(12 downto 9) <= output_buffer(2) (12 downto 9);
      output(8 downto 5)  <= output_buffer(2) (8 downto 5);
      if currentstate(0) /= nextstate(0) then
        output(3) <= '1';
      else
       output(3) <= '0';
      end if;
    elsif (currentstate(3) = s3) then
      output(13)          <= output_buffer(3) (13);
      output(12 downto 9) <= output_buffer(3) (12 downto 9);
      output(8 downto 5)  <= output_buffer(3) (8 downto 5);
      if currentstate(0) /= nextstate(0) then
        output(3) <= '1';
      else
       output(3) <= '0';
      end if;
    elsif (currentstate(4) = s3) then
      output(13)          <= output_buffer(4) (13);
      output(12 downto 9) <= output_buffer(4) (12 downto 9);
      output(8 downto 5)  <= output_buffer(4) (8 downto 5);
      if currentstate(0) /= nextstate(0) then
        output(3) <= '1';
      else
       output(3) <= '0';
      end if;
    end if;
  end process output_me;


  output_wb : process(output_buffer, currentstate)
  begin
    if (currentstate(0) = s4) then
      output(24) <= output_buffer(0) (24);
      if currentstate(0) /= nextstate(0) then
        output(4) <= '1';
      else
       output(4) <= '0';
      end if;
    elsif (currentstate(1) = s4) then
      output(24) <= output_buffer(1) (24);
      if currentstate(1) /= nextstate(1) then
        output(4) <= '1';
      else
       output(4) <= '0';
      end if;
    elsif (currentstate(2) = s4) then
      output(24) <= output_buffer(2) (24);
      if currentstate(2) /= nextstate(2) then
        output(4) <= output_buffer(4) (3);
      else
        output(4) <= '0';
      end if;
    elsif (currentstate(3) = s4) then
      output(24) <= output_buffer(3) (24);
      if currentstate(3) /= nextstate(3) then
        output(4) <= '1';
      else
        output(4) <= '0';
      end if;
    elsif (currentstate(4) = s4) then
      output(24) <= output_buffer(4) (24);
      if currentstate(4) /= nextstate(4) then
        output(4) <= '1';
      else
        output(4) <= '0';
      end if;
    end if;
  end process output_wb;


  process (output_buffer)
  begin
    in_mux_pc                  <= output(29);
    id_regdest_mux             <= output(28 downto 27);
    id_regshift_mux            <= output(26 downto 25);
    id_enable_regs             <= output(24);
    exc_mux1                   <= output(23 downto 22);
    exc_mux2                   <= output(21 downto 20);
    alu_op                     <= output(19 downto 14);
    memstg_mux                 <= output(13);
    rd_mask                    <= output(12 downto 9);
    wr_mask                    <= output(8 downto 5);
    stage_control (4 downto 0) <= output(4 downto 0);
  end process;
end architecture structure_cpu_control;

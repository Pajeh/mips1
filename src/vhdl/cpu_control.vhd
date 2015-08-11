-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 10.08.2015     Patrick Appenheimer    entity
-- 11.08.2015     Patrick Appenheimer    main fsm
-- 11.08.2015     Patrick Appenheimer    5 instr fsm

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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

  signal currentstate  : std_logic_vector(4 downto 0, 3 downto 0) : ((others  => (others => '0')));
  signal nextstate     : std_logic_vector(4 downto 0, 3 downto 0) : ((others  => (others => '0')));
  signal output_buffer : std_logic_vector(29 downto 0, 3 downto 0) : ((others => (others => '0')));
  signal rst_fsm       : std_logic_vector(4 downto 0) : (others               => '1');
  
begin
  fsm1 : entity work.fsm(behavioral) port map(clk, rst_fsm(0), nextstate(4 downto 0, 4), nextstate(4 downto 0, 0),currentstate(4 downto 0, 0), instr, instr_stall, data_stall);
  fsm2 : entity work.fsm(behavioral) port map(clk, rst_fsm(1), nextstate(4 downto 0, 0), nextstate(4 downto 0, 1),currentstate(4 downto 0, 1), instr, instr_stall, data_stall);
  fsm3 : entity work.fsm(behavioral) port map(clk, rst_fsm(2), nextstate(4 downto 0, 1), nextstate(4 downto 0, 2),currentstate(4 downto 0, 2), instr, instr_stall, data_stall);
  fsm4 : entity work.fsm(behavioral) port map(clk, rst_fsm(3), nextstate(4 downto 0, 2), nextstate(4 downto 0, 3),currentstate(4 downto 0, 3), instr, instr_stall, data_stall);
  fsm5 : entity work.fsm(behavioral) port map(clk, rst_fsm(4), nextstate(4 downto 0, 3), nextstate(4 downto 0, 4),currentstate(4 downto 0, 4), instr, instr_stall, data_stall);


  init : process(rst, nextstate)
  begin
    if rst'event and rst = '0' then     -- reset condition forwarded
      rst_fsm(4 downto 0) <= others => '0';
    else
      -- if all nextstates are zero, we are at the initial condition
      if (nextstate(4 downto 0, 0) nor nextstate(4 downto 0, 1) nor nextstate(4 downto 0, 2) nor nextstate(4 downto 0, 3) nor nextstate(4 downto 0, 4)) = b"00000" then
        rst_fsm(4 downto 0) <= b"00001";
      elsif (nextstate(4 downto 0, 1) nor nextstate(4 downto 0, 2) nor nextstate(4 downto 0, 3) nor nextstate(4 downto 0, 4)) = b"00000" then
        rst_fsm(4 downto 0) <= b"00011";
      elsif (nextstate(4 downto 0, 2) nor nextstate(4 downto 0, 3) nor nextstate(4 downto 0, 4)) = b"00000" then
        rst_fsm(4 downto 0) <= b"00111";
      elsif (nextstate(4 downto 0, 3) nor nextstate(4 downto 0, 4)) = b"00000" then
        rst_fsm(4 downto 0) <= b"01111";
      else
        rst_fsm(4 downto 0) <= b"11111";
      end if;
    end if;
  end process init;

  outputs : process(output_buffer)
  begin
    case currentstate is
      when s0 =>
        id_regdest_mux  <= output_buffer1 (28 downto 27);
        id_regshift_mux <= output_buffer1 (26 downto 25);
      when s1 =>
        exc_mux1          <= output_buffer1 (23 downto 22);
        exc_mux2          <= output_buffer1 (21 downto 20);
        alu_op            <= output_buffer1 (19 downto 14);
        in_mux_pc         <= output_buffer1 (29);
        stage_control (2) <= output_buffer1 (2);
      when s2 =>
        memstg_mux        <= output_buffer1 (13);
        rd_mask           <= output_buffer1 (12 downto 9);
        wr_mask           <= output_buffer1 (8 downto 5);
        stage_control (3) <= output_buffer1 (3);
      when s3 =>
        stage_control (4) <= output_buffer1 (4);
      when s4 =>
        id_enable_regs <= output_buffer1 (24);
      when others =>
    --do nothing
    end case;
  end process fsm1_ctrl;
  
end architecture structure_cpu_control;

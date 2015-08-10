-- Revision history:
-- 10.08.2015   Patrick Appenheimer         created 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.all;

entity FSM is
  port (
    clk : in std_logic;
    rst : in std_logic;
    pc_mux : out std_logic;
    instr  : in  std_logic_vector(31 downto 0);
    id_regdest_mux  : out std_logic_vector (1 downto 0);
    id_regshift_mux : out std_logic_vector (1 downto 0);
    id_enable_regs               : out std_logic;
    exc_mux1                   : out std_logic_vector(1 downto 0);
    exc_mux2                   : out std_logic_vector(1 downto 0);
    alu_instruction        : out std_logic_vector(5 downto 0);
    ex_alu_zero : in std_logic_vector(0 downto 0);
    mux_decision : out std_logic;
    rd_mask     : out std_logic_vector(3 downto 0);
    wr_mask     : out std_logic_vector(3 downto 0);
    instr_stall : in  std_logic;
    data_stall  : in  std_logic;
    stage_control : out std_logic_vector(4 downto 0)
    );
end entity FSM;



architecture behavioral of FSM is


--      State Machine   --
  constant s0    : std_logic_vector(4 downto 0) := b"00000";
  constant s1    : std_logic_vector(4 downto 0) := b"00001";
  constant s2    : std_logic_vector(4 downto 0) := b"00010";
  constant s3    : std_logic_vector(4 downto 0) := b"00011";
  constant s4    : std_logic_vector(4 downto 0) := b"00100";

--      Arithmetic      --
  constant addiu : std_logic_vector(5 downto 0) := b"0010_01";  -- Type I
--      Data Transfer   --
  constant lui   : std_logic_vector(5 downto 0) := b"0011_11";  -- Type I       -Register access
  constant lbu   : std_logic_vector(5 downto 0) := b"1001_00";  -- Type I       -Memory access
  constant lw    : std_logic_vector(5 downto 0) := b"1000_11";  -- Type I       -Memory access
  constant sb    : std_logic_vector(5 downto 0) := b"101000";  -- Type I       -Memory access
  constant sw    : std_logic_vector(5 downto 0) := b"101011";  -- Type I       -Memory access
--      Logical --
  constant slti  : std_logic_vector(5 downto 0) := b"001010";  -- Type I
  constant andi  : std_logic_vector(5 downto 0) := b"0011_00";  -- Type I
  constant shift : std_logic_vector(5 downto 0) := b"0000_00";  -- Type R       -NOP is read as sll $0,$0,0
--      Conditional branch      --
  constant beqz  : std_logic_vector(5 downto 0) := b"000100";  -- Type I
  constant bnez  : std_logic_vector(5 downto 0) := b"000101";  -- Type I
--      Unconditional jump      --
  constant j     : std_logic_vector(5 downto 0) := b"0000_10";  -- Type J
  constant jalx  : std_logic_vector(5 downto 0) := b"0011_01";  -- Type J

  constant r_type : std_logic_vector(5 downto 0) := b"0000_00";  -- Type R      


-- output_buffer is a register with all control outputs of the state machine:
-- output_buffer (29 downto 29): pc_mux: out std_logic;
-- output_buffer (28 downto 27): regdest_mux, 
-- output_buffer (26 downto 25): regshift_mux: out std_logic_vector (1 downto 0);
-- output_buffer (24 downto 24): enable_regs: out std_logic;
-- output_buffer (23 downto 22): in_mux1               : out  std_logic_vector(1 downto 0);
-- output_buffer (21 downto 20): in_mux2               : out  std_logic_vector(1 downto 0);
-- output_buffer (19 downto 14): in_alu_instruction    : out  std_logic_vector(5 downto 0);
-- output_buffer (13 downto 13): mux_decision: out std_logic;   
-- output_buffer (12 downto 9):  rd_mask                 : out std_logic_vector(3  downto 0);
-- output_buffer (8 downto 5):   wr_mask                 : out std_logic_vector(3  downto 0);
-- output_buffer (4 downto 0):   stage_control : out std_logic_vector(4  downto 0);               
  signal output_buffer : std_logic_vector(29 downto 0) := (others => '0');
  signal opcode        : std_logic_vector(5 downto 0);
  signal currentstate  : std_logic_vector(4 downto 0)  := (others => '0');
  signal nextstate     : std_logic_vector(4 downto 0)  := (others => '0');
  signal instruction   : std_logic_vector(31 downto 0) := (others => '0');
begin

-- purpose: set output buffer on instruction input
-- type   : combinational
-- inputs : instr
-- outputs: output_buffer
output_buffer  process (instr, ex_alu_zero, currentstate, instr_stall, data_stall)
  begin
    opcode <= instr (31 downto 26);
    if (rst = '1') then                      -- if no reset
      case currentstate is
        when s0 =>                           -- Instruction fetch
          output_buffer <= (others => '0');  -- reinitialize all to zero

          if (instr_stall = '0') then  -- check if a instruction stall is required. Stall if 1.

            

            case instr (31 downto 26) is
              when lui    => output_buffer <= b"0_10_01_1_00_01_000100_0_0000_0000_11111";
              when addiu  => output_buffer <= b"0_10_00_1_10_01_100000_0_0000_0000_11111";
              when lbu    => output_buffer <= b"0_10_00_1_10_01_100000_1_0001_0000_11111";
              when lw     => output_buffer <= b"0_10_00_1_10_01_100000_1_1111_0000_11111";
              when sb     => output_buffer <= b"0_10_00_0_10_01_100000_0_0001_0000_11111";
              when sw     => output_buffer <= b"0_10_00_0_10_01_100000_0_1111_0000_11111";
              when slti   => output_buffer <= b"0_10_00_1_10_01_001000_0_0000_0000_11111";
              when andi   => output_buffer <= b"0_10_01_1_00_01_100100_0_0000_0000_11111";
              when shift  => output_buffer <= b"0_00_00_1_00_00_001000_0_0000_0000_11111";
              when beqz   => output_buffer <= b"0_10_00_0_00_00_000000_0_0000_0000_11111";
              when bnez   => output_buffer <= b"0_10_00_0_00_00_000000_0_0000_0000_11111";
              when j      => output_buffer <= b"1_10_00_1_00_00_000000_0_0000_0000_11000";
              when jalx   => output_buffer <= b"1_10_00_1_00_00_000000_0_0000_0000_11000";
              --when r_type => output_buffer <= b"0_00_00_0_00_00_000000_0_0000_0000_11111";
              when others => output_buffer <= b"0_00_00_0_00_00_000000_0_0000_0000_11111";
            end case;
            nextstate <= s1;            -- nextstate is the Instruction decode

          else                          -- instruction stall is required
            nextstate <= s0;  -- stay on this stage if stall is required

          end if;
          
        when s1 =>                      -- Instruction Decode / Register fetch
          nextstate <= s2;
        when s2 =>                      -- Execution
          nextstate <= s3;
        when s3 =>                      -- Memory
          nextstate <= s4;
        when others => nextstate <= s0;

      end case;

      
    else  -- if a  reset was activated, all outputs and internal registers are reseted
      output_buffer <= (others => '0');  -- reinitialize all to zero
      currentstate  <= b"00000";
      nextstate     <= b"00000";
    end if;
  end process;


-- purpose: this is a timed output for the state machine
-- type   : sequential
-- inputs : clk, rst, nextstate
-- outputs: pc_mux, regdest_mux, regshift_mux, enable_regs, in_mux1, in_mux2, in_alu_instruction, mux_decision, rd_mask, wr_mask, stage_control, currentstate
  ouput : process (clk, rst) is
  begin  -- process ouput
    if rst = '0' then                   -- asynchronous reset (active low)
      currentstate <= s0;  -- reset to first state - Instruction fetch
    elsif clk'event and clk = '1' then  -- rising clock edge

      -- output_buffer is outputed
      pc_mux             <= output_buffer (29);
      regdest_mux        <= output_buffer (28 downto 27);
      regshift_mux       <= output_buffer (26 downto 25);
      enable_regs        <= output_buffer (24);
      in_mux1            <= output_buffer (23 downto 22);
      in_mux2            <= output_buffer (21 downto 20);
      in_alu_instruction <= output_buffer (19 downto 14);
      mux_decision       <= output_buffer (13);
      rd_mask            <= output_buffer (12 downto 9);
      wr_mask            <= output_buffer (8 downto 5);
      stage_control      <= output_buffer (4 downto 0);

      currentstate <= nextstate;

    end if;
  end process ouput;




end architecture behavioral;

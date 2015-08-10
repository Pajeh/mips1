-- Revision history:
-- 07.08.2015   Carlos Minamisava Faria     created 
-- 07.08.2015   Carlos Minamisava Faria     entity 
-- 07.08.2015   Carlos Minamisava Faria     moore state machine states definition 
-- 10.08.2015   Carlos Minamisava Faria & Patrick Appenheimer     Instructions added 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.all;

-- --------------------------------------  --
-- FSM-Moore State Machine:                        --
-- --------------------------------------  --
--      current state
--      when 0 =>       -- Instruction fetch
--      when 1 =>       -- Instruction Decode / Register fetch
--      when 2 =>       -- Memory address computation
--      when 3 =>       -- Execution
--      when 4 =>       -- Branch completion
--      when 5 =>       -- Jump Completion
--      when 6 =>       -- Memory access read
--      when 7 =>       -- Memory access write
--      when 8 =>       -- Writeback
--      when 9 =>       -- R-Type completion
--      when 10 =>      -- R-Type completion - Overflow
--      when 11 =>      -- Others

-- --------------------------------------  --
-- FSM-signal-Howto:                       --
-- --------------------------------------  --

-- -------- Datapath -----------------
-- pc_mux:
-- 1: Branch logic
-- 0: old PC +4
-- -------- Instr. Decode  -----------------
-- regdest_mux:
-- 00: if instruction is of R-type
-- 01: if regdest must be set to 31 (JAL?)
-- 10: if instruction is of I-type
-- 11: NEVER EVER EVER!!!
--
-- regshift_mux:
-- 00: if instruction is of R-type
-- 01: if shift must be 16 (No idea, which instruction uses that...)
-- 10: if you like non-deterministic behaviour
-- 11: if you love non-deterministic behaviour
--
-- enable_regs:
-- 1: if the writeback-stage just finished an R-type- or I-type-instruction (except for JR)
-- 0: if the writeback-stage just finished a J-type-instruction or JR
-- 

-- -------- Execution -----------------
-- in_mux1 chooses the input of register A for the ALU
-- 00: Zero extend
-- 01: outputs x"0000_0004"
-- 10: in A from Decode
-- 11: others => 'X'
--
-- in_mux2 chooses the input of register B for the ALU:
-- 00: in_b
-- 01: immediate 16
-- 10: Instruction Pointer (IP)
-- 11: others => 'X'
-- in_alu_instruction:
-- 000000: 
-- 


-- -------- Memory Stage  -----------------
-- FSS decision for writeback output. ALU results or memory data can be forwarded to writeback
-- mux_decisions:
-- 0: to forward aluResult
-- 1: to forward memory data 
-- 
-- -- stage_control: --
-- to activate registers, set signal stage_control as follows:
-- stage0->stage1: xxxx1
-- stage1->stage2: xxx1x
-- stage2->stage3: xx1xx
-- stage3->stage4: x1xxx
-- stage4->stage5: 1xxxx

-- stage0: PC
-- stage1: Instruction Fetch
-- stage2: Instr. Decode 
-- stage3: Execution
-- stage4: Memory Stage 
-- stage5: Writeback




-- --------------------------------------  --
-- Instruction:                    --
-- --------------------------------------  --


-- The reference program needs the following assembly commands:
--      lui     -- Load upper immediate:        0011 11
--      addiu   -- Add immediate unsigned       0010 01
--      j       -- Jumps                        0000 10
--      lw      -- Load word                    1000 11
--      nop     -- Performs no operation.       0000 00
--      sb      -- Store byte                   1010 00
--      sw      -- Store word                   1010 11
--      slti    -- Set on less than immediate (signed)  0010 10
--      beqz    -- Branch on equal              0001 00
--      bnez    -- Branch on greater than or equal to zero      0001 01
--      lbu     -- Load byte unsigned           1001 00
--      andi    -- And Immediate                0011 00         
--      jalx    --  Jump and Link Exchange      0111 01





entity FSM is
  port (
    -- General Signals
    clk : in std_logic;
    rst : in std_logic;

    --rst_soft in std_logic:    -- Soft reset


    -- -------- Datapath -----------------
    pc_mux : out std_logic;
    -- -------- Instr. Fetch -----------------
    instr  : in  std_logic_vector(31 downto 0);  -- instruction

    -- -------- Instr. Decode  -----------------
    regdest_mux, regshift_mux : out std_logic_vector (1 downto 0);
    enable_regs               : out std_logic;
    -- -------- Execution -----------------
    in_mux1                   : out std_logic_vector(1 downto 0);
    in_mux2                   : out std_logic_vector(1 downto 0);
    in_alu_instruction        : out std_logic_vector(5 downto 0);

    ex_alu_zero : in std_logic_vector(0 downto 0);

    -- -------- Memory Stage  -----------------
    mux_decision : out std_logic;


    -- -------- Write Back -----------------

    -- -------- Memory  -----------------
    rd_mask     : out std_logic_vector(3 downto 0);
    wr_mask     : out std_logic_vector(3 downto 0);
    instr_stall : in  std_logic;
    data_stall  : in  std_logic;


    -- -------- Pipeline  -----------------
    stage_control : out std_logic_vector(4 downto 0)  -- next step in pipeline
    );
end entity FSM;



architecture behavioral of FSM is


--      State Machine   --
  constant s0    : std_logic_vector(5 downto 0) := b"00000";
  constant s1    : std_logic_vector(5 downto 0) := b"00000";
  constant s2    : std_logic_vector(5 downto 0) := b"00000";
  constant s3    : std_logic_vector(5 downto 0) := b"00000";
  constant s4    : std_logic_vector(5 downto 0) := b"00000";
  constant s5    : std_logic_vector(5 downto 0) := b"00000";
  constant s6    : std_logic_vector(5 downto 0) := b"00000";
  constant s7    : std_logic_vector(5 downto 0) := b"00000";
  constant s8    : std_logic_vector(5 downto 0) := b"00000";
  constant s9    : std_logic_vector(5 downto 0) := b"00000";
  constant s10   : std_logic_vector(5 downto 0) := b"00000";
  constant s11   : std_logic_vector(5 downto 0) := b"00000";
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
  constant nop   : std_logic_vector(5 downto 0) := b"0000_00";  -- Type R       -NOP is read as sll $0,$0,0
--      Bitwise Shift   --
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

  signal currentstate : std_logic_vector(4 downto 0)  := (others => '0');
  signal nextstate    : std_logic_vector(4 downto 0)  := (others => '0');
  signal instruction  : std_logic_vector(31 downto 0) := (others => '0');
begin

-- purpose: set output buffer on instruction input
-- type   : combinational
-- inputs : instr
-- outputs: output_buffer
  instruction : process (instr) is
  begin  -- process instruction
    case instr (31 downto 26) is
      when lui    => output_buffer <= 0b"0_10_01_1_00_01_000100_0_0000_0000_11111";
      when addiu  => output_buffer <= 0b"0_10_00_1_10_01_100000_0_0000_0000_11111";
      when lbu    => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when lw     => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when sb     => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when sw     => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when slti   => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when andi   => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when nop    => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when beqz   => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when bnez   => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
      when j      => output_buffer <= 0b"1_10_00_1_00_00_000000_0_0000_0000_11000";
      when jalx   => output_buffer <= 0b"1_10_00_1_00_00_000000_0_0000_0000_11000";
      when r_type => output_buffer <= 0b"0_00_00_0_00_00_000000_0_0000_0000_11111";
    end case;
  end process instruction;

  process (instr, ex_alu_zero, currentstate, instr_stall)
  begin
    if (rst = '1') then                      -- if no reset
      case currentstate is
        when s0 =>                           -- Instruction fetch
          output_buffer <= (others => '0');  -- reinitialize all to zero

          if (instr_stall = '0') then  -- check if a instruction stall is required. Stall if 1.

            
            
            nextstate <= s1;            -- nextstate is the Instruction decode

          else                          -- instruction stall is required
            nextstate <= s0;  -- stay on this stage if stall is required

          end if;
          
        when s1 =>                      -- Instruction Decode / Register fetch
          case opcode is  -- decide path depending on the opcode (6 MSB of instr)
            when lbu |lw|sb|sw =>       -- Memory accesses
              nextstate <= s2;
            when nop|r_type =>          -- Type R
              nextstate <= s3;
            when beqz|bnez =>           -- BEQ - branch on equal
              nextstate <= s4;
            when j|jalx =>              -- Type J
              nextstate <= s5;
            when others =>              -- Others
              nextstate <= s6;
          end case;
        when s2 =>                      -- Memory address computation
          case opcode is
            when lbu|lw =>              -- Memory load
              nextstate <= s6;
            when others =>              -- Memory store - sb|sw
              nextstate <= s7;
          end case;
        when s3 =>                      -- Execution
          nextstep <= s9;
        when s4 =>                      -- Branch completion
          nextstep <= s0;
        when s5 =>                      -- Jump Completion
          nextstep <= s0;
        when s6 =>                      -- Memory access read
          nextstep <= s8;
        when s7 =>                      -- Memory access write
          nextstep <= s0;
        when s8 =>                      -- Writeback
          nextstep <= s0;
        when s9 =>                      -- R-Type completion
          nextstep <= s0;
        when s10 =>                     -- R-Type completion - Overflow
          nextstep <= s0;
        when s11 =>                     -- Other opcode
          nextstep <= s0;
        when others => nextstate <= b"00000";

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


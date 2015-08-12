-- Revision history:
-- 10.08.2015   Patrick Appenheimer         created 
-- 10.08.2015   Carlos Minamisava Faria     moore state machine states definition 
-- 10.08.2015   Carlos Minamisava Faria & Patrick Appenheimer     Instructions added 
-- 11.08.2015   Patrick Appenheimer         added state_register and state_decode 
-- 12.08.2015   Patrick Appenheimer    minor changes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library WORK;
use WORK.all;

entity FSM is
  port (
    clk                     : in std_logic;
    rst                     : in std_logic;
    instr_in                : in  std_logic_vector(31 downto 0);
    instr_stall             : in  std_logic;
    data_stall              : in  std_logic;
    out_currentstate        : out std_logic_vector(4 downto 0);
    out_nextstate           : out std_logic_vector(4 downto 0);
    out_buffer              : out std_logic_vector(29 downto 0);
    out_busy                : out std_logic;
    in_go                   : in  std_logic
    );
end entity FSM;

architecture behavioral of FSM is

--      State Machine   --
  constant s0    : std_logic_vector(4 downto 0) := b"00000";
  constant s1    : std_logic_vector(4 downto 0) := b"00001";
  constant s2    : std_logic_vector(4 downto 0) := b"00010";
  constant s3    : std_logic_vector(4 downto 0) := b"00011";
  constant s4    : std_logic_vector(4 downto 0) := b"00100";
  constant sX    : std_logic_vector(4 downto 0) := b"11111";

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
-- output_buffer (29 downto 29): pc_mux             : out std_logic;
-- output_buffer (28 downto 27): id_regdest_mux     : out std_logic_vector (1 downto 0);
-- output_buffer (26 downto 25): id_regshift_mux    : out std_logic_vector (1 downto 0);
-- output_buffer (24 downto 24): id_enable_regs     : out std_logic;
-- output_buffer (23 downto 22): exc_mux1           : out  std_logic_vector(1 downto 0);
-- output_buffer (21 downto 20): exc_mux2           : out  std_logic_vector(1 downto 0);
-- output_buffer (19 downto 14): alu_instruction    : out  std_logic_vector(5 downto 0);
-- output_buffer (13 downto 13): mem_mux_decision   : out std_logic;   
-- output_buffer (12 downto 9):  rd_mask            : out std_logic_vector(3  downto 0);
-- output_buffer (8 downto 5):   wr_mask            : out std_logic_vector(3  downto 0);
-- output_buffer (4 downto 0):   stage_control      : out std_logic_vector(4  downto 0);               
  signal output_buffer : std_logic_vector(29 downto 0);
  
  signal currentstate  : std_logic_vector(4 downto 0);
  signal nextstate     : std_logic_vector(4 downto 0);

  
  
begin

  state_encode: process(currentstate, instr_stall, data_stall, in_go)
  begin
    case currentstate is
        when sX =>
        if (in_go = '1') then
          nextstate <= s0;
        else
          nextstate <= sX;
        end if;
        when s0 =>
        if (instr_stall = '0') then
            nextstate <= s1;
        else                          
            nextstate <= s0;
        end if;
        when s1 =>                     
        if (instr_stall = '0') then
            nextstate <= s2;
        else                          
            nextstate <= s1;
        end if;
        when s2 =>                      
        if (instr_stall = '0') then
            nextstate <= s3;
        else                          
            nextstate <= s2;
        end if;
        when s3 =>                     
        if (instr_stall = '0') then --and data_stall = '0'
            nextstate <= s4;
        else                          
            nextstate <= s3;
        end if;
        when s4 =>                     
        if (instr_stall = '0') then
            nextstate <= s0;
        else                          
            nextstate <= s4;
        end if;
        when others => nextstate <= sX;
    end case;
  end process state_encode;
  
  state_register: process(rst, clk)
  begin
    if (rst = '0') then
        currentstate <= sX;
    elsif (clk'event and clk = '1') then
      currentstate <= nextstate;
    end if;
  end process state_register;
  
  state_decode: process(currentstate)
  begin
    out_currentstate <= currentstate;
    out_nextstate <= nextstate;
    out_buffer <= output_buffer;
    case currentstate is
      when sX =>
        out_busy <= '0';
      when s0 =>
        out_busy <= '1';
      when s4 =>
        out_busy <= '0';
      when others =>
        -- do something
    end case;
  end process state_decode;
  
  out_buff_ctr: process(instr_in)
  begin
  case instr_in (31 downto 26) is
              when lui    => output_buffer <= b"0_10_01_1_00_01_000100_0_0000_0000_11111";
              when addiu  => output_buffer <= b"0_10_00_1_10_01_100000_0_0000_0000_11111";
              when lbu    => output_buffer <= b"0_10_00_1_10_01_100000_1_0001_0000_11111";
              when lw     => output_buffer <= b"0_10_00_1_10_01_100000_1_1111_0000_11111";
              when sb     => output_buffer <= b"0_10_00_0_10_01_100000_0_0000_0001_11111";
              when sw     => output_buffer <= b"0_10_00_0_10_01_100000_0_0000_1111_11111";
              when slti   => output_buffer <= b"0_10_00_1_10_01_001000_0_0000_0000_11111";
              when andi   => output_buffer <= b"0_10_01_1_00_01_100100_0_0000_0000_11111";
              when shift  => output_buffer <= b"0_00_00_1_00_00_001000_0_0000_0000_11111";
              when beqz   => output_buffer <= b"1_10_00_0_00_00_000001_0_0000_0000_11111";
              when bnez   => output_buffer <= b"1_10_00_0_00_00_000001_0_0000_0000_11111";
              when j      => output_buffer <= b"1_10_00_0_00_00_000001_0_0000_0000_11111";
              when jalx   => output_buffer <= b"1_10_00_0_00_00_000001_0_0000_0000_11111";
              --when r_type => output_buffer <= b"0_00_00_1_10_00_000000_0_0000_0000_11111";
              when others => output_buffer <= b"0_00_00_0_00_00_000000_0_0000_0000_11111";
        end case;
  end process;

end architecture behavioral;

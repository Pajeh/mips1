-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;

--pragma translate_off
   use IEEE.std_logic_textIO.ALL;

library STD;
  use STD.textio.ALL;
--pragma translate_on

library WORK;
  use WORK.mips_instruction_set.ALL;

package cpu_pack is
  -- ------------------------------------------------------------------------------------------------------------------
  --   _____ ______ _   _ ______ _____            _         _____ ____  _   _  _____ _______       _   _ _______ _____ 
  --  / ____|  ____| \ | |  ____|  __ \     /\   | |       / ____/ __ \| \ | |/ ____|__   __|/\   | \ | |__   __/ ____|
  -- | |  __| |__  |  \| | |__  | |__) |   /  \  | |      | |   | |  | |  \| | (___    | |  /  \  |  \| |  | | | (___  
  -- | | |_ |  __| | . ` |  __| |  _  /   / /\ \ | |      | |   | |  | | . ` |\___ \   | | / /\ \ | . ` |  | |  \___ \ 
  -- | |__| | |____| |\  | |____| | \ \  / ____ \| |____  | |___| |__| | |\  |____) |  | |/ ____ \| |\  |  | |  ____) |
  --  \_____|______|_| \_|______|_|  \_\/_/    \_\______|  \_____\____/|_| \_|_____/   |_/_/    \_\_| \_|  |_| |_____/ 
  -- ------------------------------------------------------------------------------------------------------------------
  --
  -- DATA AND ADDRESS WIDTH 
  --
  constant CPU_DATA_WIDTH              : natural         := 32;                    -- data width
  constant CPU_ADDR_WIDTH              : natural         := CPU_DATA_WIDTH;        -- address width equal data width

  --
  -- REGISTERS 
  --
  constant CPU_REG_ADDR_WIDTH          : natural         := 5;                     -- 2**5 = 32 registers

  --
  -- MEMORY
  --
  constant CPU_MEM_CELL_WIDTH          : natural         := 8;                     -- width of memory cell

  -- ------------------------------------------------------------------------------------------------------------------
  --  __  __ _____ _____   _____       _____ ____  _   _  _____ _______       _   _ _______ _____ 
  -- |  \/  |_   _|  __ \ / ____|     / ____/ __ \| \ | |/ ____|__   __|/\   | \ | |__   __/ ____|
  -- | \  / | | | | |__) | (___      | |   | |  | |  \| | (___    | |  /  \  |  \| |  | | | (___  
  -- | |\/| | | | |  ___/ \___ \     | |   | |  | | . ` |\___ \   | | / /\ \ | . ` |  | |  \___ \ 
  -- | |  | |_| |_| |     ____) |    | |___| |__| | |\  |____) |  | |/ ____ \| |\  |  | |  ____) |
  -- |_|  |_|_____|_|    |_____/      \_____\____/|_| \_|_____/   |_/_/    \_\_| \_|  |_| |_____/ 
  -- ------------------------------------------------------------------------------------------------------------------
  --
  -- SHIFTER WIDTH
  --
  constant CPU_SHIFTER_WIDTH           : natural         := 5;                     -- 2**5 = 32 is maximal number of possible shifts

  --
  -- READ/WRITE MASK
  --
  constant CPU_MASK_WIDTH              : natural         := 4;                     -- maks for byte, short und int

  -- ------------------------------------------------------------------------------------------------------------------
  ---  _____ ______ _   _ ______ _____            _        _________     _______  ______  _____ 
  --  / ____|  ____| \ | |  ____|  __ \     /\   | |      |__   __\ \   / /  __ \|  ____|/ ____|
  -- | |  __| |__  |  \| | |__  | |__) |   /  \  | |         | |   \ \_/ /| |__) | |__  | (___  
  -- | | |_ |  __| | . ` |  __| |  _  /   / /\ \ | |         | |    \   / |  ___/|  __|  \___ \ 
  -- | |__| | |____| |\  | |____| | \ \  / ____ \| |____     | |     | |  | |    | |____ ____) |
  --  \_____|______|_| \_|______|_|  \_\/_/    \_\______|    |_|     |_|  |_|    |______|_____/ 
  -- ------------------------------------------------------------------------------------------------------------------
  --
  -- MAIN DATA TYPE
  --
  subtype t_cpu_word                   is  std_logic_vector(CPU_DATA_WIDTH  - 1 downto 0);
  subtype t_cpu_dword                  is  std_logic_vector(2*CPU_DATA_WIDTH- 1 downto 0);

  --
  -- REGISTER BANK
  --
  type t_reg_bank                      is  array(2**CPU_REG_ADDR_WIDTH      - 1 downto 0)  of  t_cpu_word;

  --
  -- MASK FOR BYTE, SHORT AND INT
  --
  subtype t_cpu_mask                   is std_logic_vector(CPU_MASK_WIDTH   - 1 downto 0);

  --
  -- memory
  --
  subtype t_cpu_mem_word               is std_logic_vector(CPU_MEM_CELL_WIDTH    - 1 downto 0);

  -- --------------------------------------------------------------------
  -- _  _ ____ _  _ ____ ____ _   _    ____ ____ ___  _ _  _ ____ 
  -- |\/| |___ |\/| |  | |__/  \_/     |    |  | |  \ | |\ | | __ 
  -- |  | |___ |  | |__| |  \   |      |___ |__| |__/ | | \| |__] 
  --
  -- READ
  --
  constant CPU_MASK_READ32             : t_cpu_mask         := b"1111";
  constant CPU_MASK_READ16             : t_cpu_mask         := b"0011";
  constant CPU_MASK_READ8              : t_cpu_mask         := b"0001";
  constant CPU_MASK_ZERO               : t_cpu_mask         := b"0000";
  
  --
  -- WRITE
  --                                                           
  constant CPU_MASK_WRITE32            : t_cpu_mask         := b"1111";
  constant CPU_MASK_WRITE16            : t_cpu_mask         := b"0011";
  constant CPU_MASK_WRITE8             : t_cpu_mask         := b"0001";

  -- ------------------------------------------------------------------------------------------------------------------
  --   _____ ____  __  __ _____   ____  _   _ ______ _   _ _______ _____ 
  --  / ____/ __ \|  \/  |  __ \ / __ \| \ | |  ____| \ | |__   __/ ____|
  -- | |   | |  | | \  / | |__) | |  | |  \| | |__  |  \| |  | | | (___  
  -- | |   | |  | | |\/| |  ___/| |  | | . ` |  __| | . ` |  | |  \___ \ 
  -- | |___| |__| | |  | | |    | |__| | |\  | |____| |\  |  | |  ____) |
  --  \_____\____/|_|  |_|_|     \____/|_| \_|______|_| \_|  |_| |_____/ 
  -- ------------------------------------------------------------------------------------------------------------------
  -- ____ ___  _  _    ___ ____ ___  
  -- |    |__] |  |     |  |  | |__] 
  -- |___ |    |__|     |  |__| |    
  component cpu is
    port(
      clk                     : in  std_logic;
      rst                     : in  std_logic;
      instr_addr              : out std_logic_vector(31 downto 0);
      data_addr               : out std_logic_vector(31 downto 0);
      rd_mask                 : out std_logic_vector(3  downto 0);
      wr_mask                 : out std_logic_vector(3  downto 0);
      instr_stall             : in  std_logic;
      data_stall              : in  std_logic;
      instr_in                : in  std_logic_vector(31 downto 0);
      data_to_cpu             : in  std_logic_vector(31 downto 0);
      data_from_cpu           : out std_logic_vector(31 downto 0)
    );
  end component cpu;
                              
  -- ------------------------------------------------------------------------------------------------------------------
  --  _____  ______ ____  _    _  _____  _____ _____ _   _  _____ 
  -- |  __ \|  ____|  _ \| |  | |/ ____|/ ____|_   _| \ | |/ ____|
  -- | |  | | |__  | |_) | |  | | |  __| |  __  | | |  \| | |  __ 
  -- | |  | |  __| |  _ <| |  | | | |_ | | |_ | | | | . ` | | |_ |
  -- | |__| | |____| |_) | |__| | |__| | |__| |_| |_| |\  | |__| |
  -- |_____/|______|____/ \____/ \_____|\_____|_____|_| \_|\_____|
  -- ------------------------------------------------------------------------------------------------------------------
-- synthesis translate_off
  function sv2string( input : std_logic_vector ) return string;
  function sv2reg(    input : t_mips_reg_addr  ) return string;

  -- ____ ____ ____    ___  ____ _  _ _  _ 
  -- |__/ |___ | __    |__] |__| |\ | |_/  
  -- |  \ |___ |__]    |__] |  | | \| | \_ 
  type t_v is array(0 to 1) of t_cpu_word;
  type t_a is array(0 to 3) of t_cpu_word;
  type t_t is array(0 to 9) of t_cpu_word;
  type t_s is array(0 to 8) of t_cpu_word;
  type t_k is array(0 to 1) of t_cpu_word;

  type t_cpu_rf is
    record
      we    : std_logic;
      zero  : t_cpu_word;
      at    : t_cpu_word;
      v     : t_v;
      a     : t_a;
      t     : t_t;
      s     : t_s;
      k     : t_k;
      gp    : t_cpu_word;
      sp    : t_cpu_word;
      ra    : t_cpu_word;
    end record;

  signal cpu_rbank       : t_cpu_rf;

  -- ____ _ _  _    ____ ____ _  _ ___ ____ ____ _    
  -- [__  | |\/|    |    |  | |\ |  |  |__/ |  | |    
  -- ___] | |  |    |___ |__| | \|  |  |  \ |__| |___ 
  type t_sim_control is
    record
      sim_message           : std_logic;
      sim_finish            : std_logic;
  end record;

  signal i_sim_control      : t_sim_control;
-- synthesis translate_on
   
end package cpu_pack;


package body cpu_pack is

-- synthesis translate_off
  function sv2string( input : std_logic_vector ) return string 
  is
    variable l : line;
  begin
    hwrite( l, input, RIGHT, 6 );
    return l.all;
  end sv2string;

  function sv2reg( input : t_mips_reg_addr ) return string
  is
  begin
    case input is
      when "00000"  => return "zero";
      when "00001"  => return "at";
      when "00010"  => return "v0";
      when "00011"  => return "v1";
      when "00100"  => return "a0";
      when "00101"  => return "a1";
      when "00110"  => return "a2";
      when "00111"  => return "a3";
      when "01000"  => return "t0";
      when "01001"  => return "t1";
      when "01010"  => return "t2";
      when "01011"  => return "t3";
      when "01100"  => return "t4";
      when "01101"  => return "t5";
      when "01110"  => return "t6";
      when "01111"  => return "t7";
      when "10000"  => return "s0";
      when "10001"  => return "s1";
      when "10010"  => return "s2";
      when "10011"  => return "s3";
      when "10100"  => return "s4";
      when "10101"  => return "s5";
      when "10110"  => return "s6";
      when "10111"  => return "s7";
      when "11000"  => return "t8";
      when "11001"  => return "t9";
      when "11010"  => return "k0";
      when "11011"  => return "k1";
      when "11100"  => return "gp";
      when "11101"  => return "sp";
      when "11110"  => return "s8";
      when "11111"  => return "ra";
      when others   => return "unknown";
    end case;
  end sv2reg;
-- synthesis translate_on

end package body cpu_pack;
library IEEE;
   use IEEE.std_logic_1164.ALL;

library WORK;
   use WORK.cpu_pack.t_cpu_mem_word;
   use WORK.cpu_pack.t_cpu_mask;
   use WORK.cpu_pack.t_cpu_word;
  
package memory_pack is

-- synthesis translate_off
  constant CPU_MEM_SIZE            : natural    := 256;
  type t_cpu_memory                is array(CPU_MEM_SIZE                - 1 downto 0)   of  t_cpu_mem_word;
-- synthesis translate_on

  component memory is
  port(
    clk               : in  std_logic;
    rst               : in  std_logic;
    wr_mask           : in  t_cpu_mask;
    rd_mask           : in  t_cpu_mask;
    instr_stall       : out std_logic;
    data_stall        : out std_logic;
    prog_addr         : in  t_cpu_word;
    data_addr         : in  t_cpu_word;
    prog_out          : out t_cpu_word;
    data_in           : in  t_cpu_word;
    data_out          : out t_cpu_word;
    leds              : out std_logic_vector(7 downto 0)
  );
  end component memory;

end package memory_pack;


library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
   use WORK.cpu_pack.ALL;

library WORK;
  use WORK.memory_pack.ALL;

entity memory is
  port(
    clk               : in  std_logic;
    rst               : in  std_logic;
    wr_mask           : in  t_cpu_mask;
    rd_mask           : in  t_cpu_mask;
    instr_stall       : out std_logic;
    data_stall        : out std_logic;
    prog_addr         : in  t_cpu_word;
    data_addr         : in  t_cpu_word;
    prog_out          : out t_cpu_word;
    data_in           : in  t_cpu_word;
    data_out          : out t_cpu_word;
    leds              : out std_logic_vector(7 downto 0)
  );
end entity memory;

-- synthesis translate_off
architecture simulation_memory of memory is

  signal ram                      : t_cpu_memory:= (x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"84", x"00", x"00", x"00",
x"10", x"32", x"54", x"76",
x"00", x"00", x"00", x"00",
x"07", x"00", x"00", x"08",
x"00", x"00", x"62", x"a0",
x"ff", x"00", x"42", x"30",
x"01", x"00", x"42", x"24",
x"00", x"00", x"00", x"00",
x"00", x"00", x"62", x"90",
x"00", x"00", x"00", x"00",
x"10", x"80", x"83", x"8f",
x"00", x"00", x"00", x"00",
x"f8", x"ff", x"40", x"14",
x"10", x"00", x"42", x"28",
x"00", x"00", x"00", x"00",
x"0c", x"80", x"82", x"8f",
x"0c", x"80", x"82", x"af",
x"01", x"00", x"42", x"24",
x"00", x"00", x"00", x"00",
x"0c", x"80", x"82", x"8f",
x"00", x"00", x"00", x"00",
x"0a", x"00", x"40", x"10",
x"10", x"00", x"42", x"28",
x"00", x"00", x"00", x"00",
x"0c", x"80", x"82", x"8f",
x"0c", x"80", x"80", x"af",
x"00", x"00", x"40", x"a0",
x"00", x"00", x"00", x"00",
x"10", x"80", x"82", x"8f",
x"a2", x"00", x"1d", x"3c",
x"04", x"00", x"00", x"08",
x"70", x"80", x"9c", x"27",
x"01", x"00", x"1c", x"3c"
  );

begin

  memory_access:
  process( clk )
    variable    i_addr            : natural := 0;
    variable    d_addr            : natural := 0;
  begin
    if falling_edge( clk ) then
      i_addr := to_integer(unsigned(prog_addr(7 downto 0)));
      d_addr := to_integer(unsigned(data_addr(7 downto 0)));

      -- ########### READ INSTRUCTION ###################
      prog_out <= ram(i_addr) & ram(i_addr + 1) & ram(i_addr + 2) & ram(i_addr + 3);

      -- ########### READ DATA ##########################
      case rd_mask is
        when CPU_MASK_READ8   => data_out <= ram(d_addr) & ram(d_addr) & ram(d_addr) & ram(d_addr);
        when CPU_MASK_READ16  => data_out <= ram(d_addr) & ram(d_addr + 1) & ram(d_addr) & ram(d_addr + 1);
        when CPU_MASK_READ32  => data_out <= ram(d_addr) & ram(d_addr + 1) & ram(d_addr + 2) & ram(d_addr + 3);
        when others           => data_out <= (others => '0');
      end case;

      -- ########### WRITE DATA #########################
      case wr_mask is
        when CPU_MASK_WRITE8  => ram(d_addr)      <= data_in(31 downto 24);
        when CPU_MASK_WRITE16 => ram(d_addr)      <= data_in(31 downto 24);
                                 ram(d_addr + 1)  <= data_in(23 downto 16);
        when CPU_MASK_WRITE32 => ram(d_addr)      <= data_in(31 downto 24);
                                 ram(d_addr + 1)  <= data_in(23 downto 16);
                                 ram(d_addr + 2)  <= data_in(15 downto  8);
                                 ram(d_addr + 3)  <= data_in( 7 downto  0);
        when others           =>
      end case;

      leds      <= ram(132);
    end if;
  end process;

  instr_stall   <= '0';
  data_stall    <= '0';

end simulation_memory;
-- synthesis translate_on

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
   use WORK.cpu_pack.ALL;

library WORK;
  use WORK.memory_pack.ALL;

architecture fpga_memory of memory is
  --
  -- address types
  --
  subtype t_addr      is std_logic_vector(7 downto 0);
  type t_word_addr is
    record
      byte_0          : unsigned(7 downto 0);
      byte_1          : unsigned(7 downto 0);
      byte_2          : unsigned(7 downto 0);
      byte_3          : unsigned(7 downto 0);
    end record;

  --
  -- extract address type
  --
  alias cpu_i_addr    : t_addr is prog_addr(7 downto 0);
  alias cpu_d_addr    : t_addr is data_addr(7 downto 0);

  --
  -- instruction and data addresses
  --
  signal i_addr       : t_word_addr;
  signal d_addr       : t_word_addr;
  
  --
  -- ########## STATE MACHINE ################
  --
  type t_state  is (sONE, sTWO, sTHREE, sFOUR);

  signal i_state, n_i_state      : t_state;
  signal d_state, n_d_state      : t_state;

  --
  -- data access mask
  --
  signal mask         : std_logic_vector(3 downto 0);

  --
  -- ram component
  --
  component ram is
  port(
    clk         : in  std_logic;
    we          : in  std_logic;
    a           : in  std_logic_vector(7 downto 0);
    dpra        : in  std_logic_vector(7 downto 0);
    di          : in  std_logic_vector(7 downto 0);
    spo         : out std_logic_vector(7 downto 0);
    dpo         : out std_logic_vector(7 downto 0);
    leds        : out std_logic_vector(7 downto 0)
  );
  end component ram;

  --
  -- RAM unit interface
  --  
  signal ram_i_addr       : std_logic_vector(7 downto 0);
  signal ram_d_addr       : std_logic_vector(7 downto 0);
  signal i_data           : std_logic_vector(7 downto 0);
  signal d_data_in        : std_logic_vector(7 downto 0);
  signal d_data_out       : std_logic_vector(7 downto 0);

  --
  -- store read bytes
  --
  signal i_reg            : std_logic_vector(23 downto 0);
  signal d_reg            : std_logic_vector(23 downto 0);

  --
  -- detect instruction address change
  --
  signal prev_addr        : t_addr;
  signal new_addr         : std_logic;

begin
  -- _ _  _ ____ ___ ____ _  _ ____ ___ _ ____ _  _ 
  -- | |\ | [__   |  |__/ |  | |     |  | |  | |\ | 
  -- | | \| ___]  |  |  \ |__| |___  |  | |__| | \| 
  --
  -- for instruction address changes read new instruction
  -- 
  process( i_state, new_addr, i_addr )
  begin
    -- default values
    instr_stall     <= '1';
    ram_i_addr      <= std_logic_vector(i_addr.byte_3);

    n_i_state       <= sONE;

    -- state logic
    case i_state is
      when sONE   => 
        if new_addr = '1' then
          ram_i_addr    <= std_logic_vector(i_addr.byte_0);
          n_i_state     <= sTWO;
        else
          instr_stall   <= '0';
        end if;
      when sTWO   => n_i_state <= sTHREE; ram_i_addr <= std_logic_vector(i_addr.byte_1);
      when sTHREE => n_i_state <= sFOUR;  ram_i_addr <= std_logic_vector(i_addr.byte_2);
      when sFOUR  => n_i_state <= sONE;   ram_i_addr <= std_logic_vector(i_addr.byte_3); instr_stall <= '0'; 
    end case;
  end process;

  -- ___  ____ ___ ____ 
  -- |  \ |__|  |  |__| 
  -- |__/ |  |  |  |  | 
  --
  -- check mask
  --
  process( d_state, mask, wr_mask, d_addr )
  begin
    -- default values
    ram_d_addr        <= std_logic_vector(d_addr.byte_0);
    data_stall        <= '0';

    n_d_state         <= sONE;

    case d_state is
      when sONE   => 
        if mask(1) = '1' then
          data_stall  <= '1';
          n_d_state   <= sTWO;
        end if;

      when sTWO   =>
        ram_d_addr     <= std_logic_vector(d_addr.byte_1);

        if mask(2) = '1' then
          data_stall  <= '1';
          n_d_state   <= sTHREE;
        end if;

      when sTHREE =>
        ram_d_addr     <= std_logic_vector(d_addr.byte_2);
        data_stall     <= '1';
        n_d_state      <= sFOUR;

      when sFOUR  =>
        ram_d_addr     <= std_logic_vector(d_addr.byte_3);

    end case;
  end process;

  -- ____ ___  ___  ____ ____ ____ ____ ____ ____ 
  -- |__| |  \ |  \ |__/ |___ [__  [__  |___ [__  
  -- |  | |__/ |__/ |  \ |___ ___] ___] |___ ___] 
  --
  -- instruction addresses for whole word
  --
  i_addr.byte_0     <= unsigned(cpu_i_addr);
  i_addr.byte_1     <= unsigned(cpu_i_addr) + 1;
  i_addr.byte_2     <= unsigned(cpu_i_addr) + 2;
  i_addr.byte_3     <= unsigned(cpu_i_addr) + 3;

  --
  -- data addresses for whole word
  --
  d_addr.byte_0     <= unsigned(cpu_d_addr);
  d_addr.byte_1     <= unsigned(cpu_d_addr) + 1;
  d_addr.byte_2     <= unsigned(cpu_d_addr) + 2;
  d_addr.byte_3     <= unsigned(cpu_d_addr) + 3;

  --
  -- new instruction address detection
  --
  new_addr    <= '1' when prev_addr /= prog_addr(7 downto 0) else '0';

  -- ___  ____ ___ ____    _ _ _ ____ ____ ___  ____ 
  -- |  \ |__|  |  |__|    | | | |  | |__/ |  \ [__  
  -- |__/ |  |  |  |  |    |_|_| |__| |  \ |__/ ___] 
  --
  -- data mask
  --
  mask    <= wr_mask or rd_mask;

  --
  -- data to write
  --
  with d_state select
    d_data_in     <= data_in(23 downto 16) when sTWO,
                     data_in(15 downto  8) when sTHREE,
                     data_in( 7 downto  0) when sFOUR,
                     data_in(31 downto 24) when others;

  --
  -- read data
  --
  prog_out        <= i_reg & i_data;
  data_out        <= d_reg & d_data_out;


  process( clk )
  begin
    if rising_edge( clk ) then
      if rst = '1' then
        i_state     <= sONE;
        d_state     <= sONE;

        i_reg       <= (others => '0');
        d_reg       <= (others => '0');

        prev_addr   <= (others => '1');
      else
        --
        -- state variables
        --
        i_state     <= n_i_state;
        d_state     <= n_d_state;

        --
        -- read instruction bytes
        --
        case i_state is
          when sONE   => i_reg <= i_data & i_data & i_data;
          when sTWO   => i_reg <= i_reg(23 downto 16) & i_data & i_data;
          when sTHREE => i_reg <= i_reg(23 downto 8) & i_data;
          when sFOUR  => i_reg <= i_reg;
        end case;

        --
        -- read data bytes
        --
        case d_state is
          when sONE   => d_reg <= d_data_out & d_data_out & d_data_out;
          when sTWO   => d_reg <= d_reg(23 downto 16) & d_data_out & d_data_out;
          when sTHREE => d_reg <= d_reg(23 downto  8) & d_data_out;
          when sFOUR  => d_reg <= d_reg;
        end case;

        --
        -- store previous address
        --
        if i_state = sONE then
          prev_addr   <= prog_addr(7 downto 0);
        end if;
      end if;
    end if;
  end process;

  -- ____ ____ _  _ 
  -- |__/ |__| |\/| 
  -- |  \ |  | |  | 
  ram_unit: ram
  PORT MAP(
    clk     => clk,
    we      => wr_mask(0),
    a       => ram_d_addr,       dpra    => ram_i_addr,
    di      => d_data_in,
    spo     => d_data_out,       dpo     => i_data,
    leds    => leds
  );

end fpga_memory;

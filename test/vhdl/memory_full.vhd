library IEEE;
   use IEEE.std_logic_1164.ALL;
   use IEEE.numeric_std.ALL;

library WORK;
   use WORK.cpu_pack.ALL;
  
package memory_pack is

  constant CPU_MEM_RANGE           : natural         := 25;
  constant CPU_MEM_SIZE            : std_logic_vector(CPU_MEM_RANGE     - 1 downto 0) := '1' & x"a2_0014";
  constant CPU_MEM_SIZE_RANGE      : natural         := to_integer(unsigned(CPU_MEM_SIZE));

  type t_cpu_memory                is array(CPU_MEM_SIZE_RANGE          - 1 downto 0)   of  t_cpu_mem_word;

  subtype t_prog_addr              is std_logic_vector(CPU_MEM_RANGE    - 1 downto 0);
  subtype t_data_addr              is std_logic_vector(CPU_MEM_RANGE    - 1 downto 0);

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
    data_out          : out t_cpu_word
  );
  end component memory;


  procedure read_instr( signal  instr   : out t_cpu_word;
                                addr    : in  t_prog_addr;
                                memory  :     t_cpu_memory );
                               

  procedure read_heap( signal   data    : out t_cpu_word;
                       signal   data_in : in  t_cpu_word;
                                addr    : in  t_data_addr;
                                mask    : in  t_cpu_mask;
                                memory  :     t_cpu_memory );

  procedure write_heap(signal   data    : in  t_cpu_word;
                                addr    : in  t_data_addr;
                                mask    : in  t_cpu_mask;
                       variable memory  : out t_cpu_memory );
end package memory_pack;


package body memory_pack is

  procedure read_instr( signal instr  : out t_cpu_word;
                               addr   : in  t_prog_addr;
                               memory :     t_cpu_memory ) is
    variable i_addr   : natural := 0;
  begin
    i_addr := to_integer(unsigned(addr));

    instr(31 downto 24)  <= memory(i_addr    );
    instr(23 downto 16)  <= memory(i_addr + 1);
    instr(15 downto  8)  <= memory(i_addr + 2);
    instr( 7 downto  0)  <= memory(i_addr + 3);
  end procedure read_instr;

  procedure read_heap( signal data    : out t_cpu_word;
                       signal data_in : in  t_cpu_word;
                              addr    : in  t_data_addr;
                              mask    : in  t_cpu_mask;
                              memory  :     t_cpu_memory ) is
    variable i_addr    : natural := 0;
  begin
    i_addr := to_integer(unsigned(addr));

    case mask is
      when CPU_MASK_READ8   =>
        data(31 downto 24)  <= memory(i_addr  );
        data(23 downto 16)  <= memory(i_addr  );
        data(15 downto  8)  <= memory(i_addr  );
        data( 7 downto  0)  <= memory(i_addr  );

      when CPU_MASK_READ16  =>  
        data(31 downto 24)  <= memory(i_addr  );
        data(23 downto 16)  <= memory(i_addr + 1);
        data(15 downto  8)  <= memory(i_addr  );
        data( 7 downto  0)  <= memory(i_addr + 1);

      when CPU_MASK_READ32  =>  
        data(31 downto 24)  <= memory(i_addr  );
        data(23 downto 16)  <= memory(i_addr + 1);
        data(15 downto  8)  <= memory(i_addr + 2);
        data( 7 downto  0)  <= memory(i_addr + 3);

      when others     => 
        data                <= (others => '0');
    end case;
  end procedure read_heap;

  procedure write_heap(signal   data    : in  t_cpu_word;
                                addr    : in  t_data_addr;
                                mask    : in  t_cpu_mask;
                       variable memory  : out t_cpu_memory ) is
    variable i_addr     : natural := 0;
  begin
    i_addr := to_integer(unsigned(addr));

    case mask is
      when CPU_MASK_WRITE8   =>  
        memory(i_addr    ) := data( 7 downto  0);

      when CPU_MASK_WRITE16  =>  
        memory(i_addr + 1) := data( 7 downto  0);
        memory(i_addr    ) := data(15 downto  8);

      when CPU_MASK_WRITE32  =>  
        memory(i_addr + 3) := data( 7 downto  0);
        memory(i_addr + 2) := data(15 downto  8);
        memory(i_addr + 1) := data(23 downto 16);
        memory(i_addr    ) := data(31 downto 24);

      when others               => 
    end case;

  end procedure write_heap;

end package body memory_pack;


library IEEE;
  use IEEE.std_logic_1164.ALL;

library WORK;
   use WORK.cpu_pack.t_cpu_mask;
   use WORK.cpu_pack.t_cpu_word;

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
    data_out          : out t_cpu_word
  );
end entity memory;


architecture behav_memory of memory is

  shared variable ram             : t_cpu_memory;

  alias inst_addr                 : t_prog_addr is prog_addr(CPU_MEM_RANGE - 1 downto 0);
  alias heap_addr                 : t_data_addr is data_addr(CPU_MEM_RANGE - 1 downto 0);

begin

memory_access:
  process( clk )
  begin
    if falling_edge( clk ) then

      -- ########### READ INSTRUCTION ###################
      read_instr( prog_out,         inst_addr,          ram );

      -- ########### READ HEAP ##########################
      read_heap( data_out, data_in, heap_addr, rd_mask, ram );

      -- ########### WRITE HEAP #########################
      write_heap( data_in,          heap_addr, wr_mask, ram );

    end if;
  end process;

  instr_stall     <= '0';
  data_stall      <= '0';

end behav_memory;

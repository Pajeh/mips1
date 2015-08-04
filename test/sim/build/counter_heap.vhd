library IEEE;
  use IEEE.std_logic_1164.ALL;

library PLASMA;
  use PLASMA.plasma_pack.ALL;

entity heap_tracking is
  generic(
    CORE        : string(2 downto 1)
  );
  port (
    clk         : in std_logic;
    addr        : in t_plasma_word;
    we          : in std_logic;
    data        : in t_plasma_word
  );
end entity heap_tracking;


architecture behav_heap_tracking of heap_tracking is
begin
  process( clk )
  begin
    if rising_edge( clk ) then
      if we = '1' then
        end if;
      end if;
    end if;
  end process;
end architecture behav_heap_tracking;

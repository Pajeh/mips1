-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.std_logic_unsigned.ALL;

entity ram is
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
end entity ram;


architecture structure_ram of ram is

  type t_ram is array(255 downto 0) of std_logic_vector(7 downto 0);
  signal ram    : t_ram;

begin

  process( clk )
  begin
    if clk'event and clk = '1' then
      if we = '1' then
        ram( conv_integer(a))  <= di;
      end if;
    end if;
  end process;

  spo <= ram(conv_integer(a));
  dpo <= ram(conv_integer(dpra));

  leds  <= ram(127);

end architecture structure_ram;

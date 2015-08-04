library IEEE;
  use IEEE.std_logic_1164.ALL;

entity functions is
  generic (
    CORE        : string(2 downto 1);
    ADDR_LIMIT  : integer
  );
  port (
    addr      : in integer
  );
end entity functions;


architecture behav_functions of functions is

begin

  process( addr )
  begin
    if addr <= ADDR_LIMIT then
      case addr is
       when 16  => report CORE &" main_user";
       when others     => 
      end case;
    end if;
  end process;

end behav_functions;

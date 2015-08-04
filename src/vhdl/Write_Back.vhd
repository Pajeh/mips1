-- 03.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;


entity write_back is
port(

clk, rst: in std_logic;
Writeback_in, Regdest_in : in  std_logic_vector(31 downto 0);
Writeback_out, Regdest_out : out std_logic_vector(31 downto 0));



end entity write_back;


architecture behavior of write_back
begin


Writeback_out <= Writeback_in;
Regdesk_out <= Regdesk_in;


end architecture behavioral;





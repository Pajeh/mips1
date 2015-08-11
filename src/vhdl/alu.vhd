-- revision history:
-- 06.07.2015     Alex Schönberger      created
-- 04.08.2015     Patrick Appenheimer   added entity and architecture behave
-- 05.08.2015     Patrick Appenheimer   bugfixes
-- 05.08.2015     Patrick Appenheimer   subu, and, or added
-- 10.08.2015     Patrick Appenheimer   shift, slt added

library IEEE;
  use IEEE.std_logic_1164.ALL;
  USE IEEE.numeric_std.ALL;

library WORK;
  use WORK.all;
  
-- -- ALU FUNCTION CODES: -- --
-- ADD ==> 10_0000
-- SUB ==> 10_0010
-- AND ==> 10_0100
-- OR ==> 10_0101
-- result <= reg_a ==> 00_0001
-- result <= reg_b ==> 00_0010
-- shift ==> 00_0100
-- slt ==> 00_1000

entity alu is

    port(
      in_a                     : in  std_logic_vector(31 downto 0);
      in_b                     : in  std_logic_vector(31 downto 0);
      function_code            : in std_logic_vector(5 downto 0);
      result                   : out std_logic_vector(31 downto 0);
      zero                     : out std_logic_vector(0 downto 0)
    );

end entity alu;

architecture behave of alu is
begin
  process(in_a, in_b, function_code)
  -- declaration of variables
  variable a_uns : std_logic_vector(31 downto 0);
  variable b_uns : std_logic_vector(31 downto 0);
  variable r_uns : std_logic_vector(31 downto 0);
  variable z_uns : std_logic_vector(0 downto 0);
  begin
    -- initialize values
    a_uns := in_a;
    b_uns := in_b;
    r_uns := (others => '0');
    z_uns := b"0";
    -- select operation
    case function_code is
    -- add
    when b"10_0000" =>    
    r_uns := std_logic_vector(unsigned(a_uns) + unsigned(b_uns));
    -- sub
    when b"10_0010" =>    
    r_uns := std_logic_vector(unsigned(a_uns) - unsigned(b_uns));
    -- and
    when b"10_0100" =>    
    r_uns := in_a and in_b;--std_logic_vector(unsigned(a_uns) AND unsigned(b_uns));
    -- or
    when b"10_0101" =>    
    r_uns := std_logic_vector(unsigned(a_uns) OR unsigned(b_uns));
    -- out <= a
    when b"00_0001" =>    
    r_uns := a_uns;
     -- out <= b
    when b"00_0010" =>    
    r_uns := b_uns;
    -- shift
    when b"00_0100" =>    
    r_uns := std_logic_vector(SHIFT_LEFT(unsigned(b_uns),to_integer(unsigned(a_uns))));
    -- slt
    when b"00_1000" =>
    if (to_integer(signed(a_uns)) < to_integer(signed(b_uns))) then
      r_uns := x"0000_0001";
    end if;
    -- others
    when others => r_uns := (others => 'X');
    end case;
    if r_uns = x"0000_0000" then
    z_uns := b"1";
    else
    z_uns := b"0";
    end if;
    -- assign variables to output signals
    result <= r_uns;
    zero <= std_logic_vector(unsigned(z_uns));
end process;
end architecture behave;

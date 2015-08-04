-- revision history:
-- 06.07.2015     Alex Schönberger      created
-- 04.08.2015     Patrick Appenheimer   added entity and architecture behave

entity alu is

    port(
      in_a                     : in  std_logic_vector(31 downto 0);
      in_b                     : in  std_logic_vector(31 downto 0);
      function_code            : in std_logic_vector(5 downto 0);
      result                   : out std_logic_vector(31 downto 0);
      zero                     : out std_logic
    );

end entity alu;

architecture behave of alu is
begin
  process(a, b, function_code)
  -- declaration of variables
  variable a_uns : unsigned(31 downto 0);
  variable b_uns : unsigned(31 downto 0);
  variable r_uns : unsigned(31 downto 0);
  variable z_uns : unsigned(0 downto 0);
  begin
    -- initialize values
    a_uns := unsigned(in_a);
    b_uns := unsigned(in_b);
    r_uns := (others => '0');
    z_uns := '0';
    -- select operation
    case function_code is
    -- add
    when MIPS_FUNC_ADD =>
    r_uns := a_uns + b_uns;
    -- others
    when others => r_uns := (others => 'X');
    end case;
    if to_integer(r_uns) = 0 then
    z_uns := '1';
    else
    z_uns := '0':
    end if;
    -- assign variables to output signals
    result <= r_uns;
    zero <= z_uns;
end process;
end architecture behave;



architecture structure_alu of alu is

begin

end architecture structure_alu;

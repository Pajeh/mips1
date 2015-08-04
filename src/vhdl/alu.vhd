-- revision history:
-- 06.07.2015     Alex Schönberger    created

entity alu is

    port(
      in_a                     : in  std_logic_vector(31 downto 0);
      in_b                     : in  std_logic_vector(31 downto 0);
      instruction              : in std_logic_vector(31 downto 0);
      result                   : out std_logic_vector(31 downto 0);
      zero                     : out std_logic
    );

end entity alu;

architecture behave of alu is
begin
  process(a, b, instruction)
  -- declaration of variables
  variable a_uns : unsigned(31 downto 0);
  variable b_uns : unsigned(31 downto 0);
  variable r_uns : unsigned(31 downto 0);
  variable z_uns : unsigned(0 downto 0);
  begin
    -- initialize values
    a_uns := unsigned(a);
    b_uns := unsigned(b);
    r_uns := (others => '0');
    z_uns := '0';

end architecture behave;



architecture structure_alu of alu is

begin

end architecture structure_alu;

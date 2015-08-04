library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

package uart_pack is

  -- constant  BIT_HALFTIME        : unsigned(15 downto 0) := x"0014";       -- test
  constant  BIT_HALFTIME        : unsigned(15 downto 0) := x"0364";       -- 868: 115200 bit/s @ 200 MHz
  -- constant  BIT_HALFTIME        : unsigned(15 downto 0) := x"0283";       -- 643: 115200 bit/s @ 150 MHz
  -- constant  BIT_HALFTIME        : unsigned(15 downto 0) := x"01AD";       -- 429:  115200 bit/s @ 100 MHz
  -- constant  BIT_HALFTIME        : unsigned(15 downto 0) := x"00D6";       -- 214:  115200 bit/s @ 50 MHz


  component uart is
  port(
    -- general
    clk                 : in  std_logic;
    rst                 : in  std_logic;
    -- intern control
    t_req               : in  std_logic;    -- write request
    t_ack               : out std_logic;    -- write acknowledge
    t_data              : in  std_logic_vector(7 downto 0);
    r_req               : out std_logic;    -- read request
    r_ack               : in  std_logic;    -- read acknowledge
    r_data              : out std_logic_vector(7 downto 0);
    -- external interface
    rx                  : in  std_logic;
    tx                  : out std_logic
  );
  end component uart;

end package uart_pack;
-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

entity tb_hdllab is
end entity tb_hdllab;


architecture behav_tb_hdllab of tb_hdllab is

  component hdllab is
  port(
    -- general: CLK and RESET
    clk_p                     : in  std_logic;
    clk_n                     : in  std_logic;
    rst                       : in  std_logic;
    -- UART interface
    rx                        : in  std_logic;
    tx                        : out std_logic;
    -- LED indication
    leds                      : out std_logic_vector(7 downto 0)
  );
  end component hdllab;

  signal clk_p                : std_logic   := '0';
  signal clk_n                : std_logic;
  signal rst                  : std_logic;

  signal rx                   : std_logic;
  signal tx                   : std_logic;

  signal leds                 : std_logic_vector(7 downto 0);

begin

  clk_p   <= not clk_p after 2500 ps;
  clk_n   <= not clk_p;

  rst     <= '1', '0' after 10 ns;

  uut: hdllab
  PORT MAP(
    clk_p => clk_p, clk_n => clk_n,
    rst   => rst,
    rx    => rx,    tx    => tx,
    leds  => leds
  );

  process
  begin
    rx    <= '1';
    wait for 100 ns;      -- wait for PLL is locked

       -- send 0x3c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x1c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x01 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x27 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x9c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x70 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x08 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x04 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x3c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x1d over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xa2 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x8f over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x82 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xa0 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x40 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xaf over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x8f over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x82 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x28 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x42 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x40 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0a over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x8f over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x82 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x24 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x42 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x01 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xaf over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x82 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x8f over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x82 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x0c over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x28 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x42 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x14 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x40 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xff over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xf8 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x8f over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x83 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x80 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x90 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x62 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x24 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x42 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x01 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x30 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x42 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xff over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0xa0 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x62 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x08 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x07 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x76 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x54 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x32 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x10 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x84 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '1';  wait for 205 ns;       -- '1'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    -- send 0x00 over UART
    rx    <= '0';  wait for 205 ns;       -- start bit
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    rx    <= '0';  wait for 205 ns;       -- '0'
    
    rx    <= '1';  wait for 205 ns;       -- stop bit
                   wait for 20  ns;
    
    wait;
  end process;

end architecture behav_tb_hdllab;
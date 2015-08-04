-- --------------------------------------------------------------------------
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- --------------------------------------------------------------------------
-- TITLE:       UART module
-- AUTHOR:      Alex Schoenberger (Alex.Schoenberger@ies.tu-darmstadt.de)
-- COMMENT:     
--
-- www.ies.tu-darmstadt.de
-- TU Darmstadt
-- Institute for Integrated Systems
-- Merckstr. 25
-- 
-- 64283 Darmstadt - GERMANY
-- --------------------------------------------------------------------------
-- PROJECT:       Plasma CPU core with FPU
-- FILENAME:      uart.vhd
-- --------------------------------------------------------------------------
-- COPYRIGHT: 
--  This project is distributed by GPLv2.0
--  Software placed into the public domain by the author.
--  Software 'as is' without warranty.  Author liable for nothing.
-- --------------------------------------------------------------------------
-- DESCRIPTION:
--    implementation of send and receive logic
--
--    SYNTHESIZABLE
--
----------------------------------------------------------------------------
-- Revision History
-- --------------------------------------------------------------------------
-- Revision   Date    Author     CHANGES
-- 1.0      7/2015    AS         initial
-- --------------------------------------------------------------------------
library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.uart_pack.BIT_HALFTIME;

entity uart is
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
end entity uart;


architecture structure_uart of uart is
  --
  -- ################ BAUD CONSTANTS ##########
  --
  constant BAUD_CNT_ZERO   : unsigned(15 downto 0)        := (others => '0');
  constant DATA_CNT_ZERO   : std_logic_vector(6 downto 0) := (others => '0');

  --
  -- ################ SAMPLE THRES ############
  --
  constant SAMPLE_THRES    : unsigned(3 downto 0)         := x"4";

  --
  -- ################ STATE MACHINE ###########
  --
  type t_state is (sIDLE,                     -- wait for input
                   sSTART,                    -- start bit
                   sDATA,                     -- data sending/receiving
                   sSTOP                      -- stop bit
                  );

  type t_flags_in is
    record
      baud_tick            : std_logic;       -- baud clock tick
      data_full            : std_logic;       -- send/received all data bits
    end record;

  type t_flags_out is
    record
      data_store           : std_logic;       -- store input/output data
      data_shift           : std_logic;       -- get next bit
      data_cnt_load        : std_logic;       -- load data counter
    end record;

  subtype t_data_counter   is std_logic_vector(6 downto 0);
  subtype t_baud_counter   is unsigned(15 downto 0);
  subtype t_uart_data      is std_logic_vector(7 downto 0);

  --
  -- ################## SEND LOGIC ##############
  --
  signal tx_state, 
            n_tx_state       : t_state;

  signal tx_flags_in         : t_flags_in;
  signal tx_flags_out        : t_flags_out;

  signal tx_data_cnt         : t_data_counter;
  signal tx_baud_cnt         : t_baud_counter;
  signal tx_data             : t_uart_data;

  --
  -- send specific signals
  --
  signal tx_bit              : std_logic;                   -- current tx wire level
  alias  data_bit            : std_logic is tx_data(7);     -- current bit to send

  --
  -- ################### RECEIVE LOGIC ###########
  --
  signal rx_state,
            n_rx_state       : t_state;

  signal rx_flags_in         : t_flags_in;
  signal rx_flags_out        : t_flags_out;

  signal rx_baud_cnt         : t_baud_counter;
  signal rx_data_cnt         : t_data_counter;
  signal rx_data             : t_uart_data;

  --
  -- upper level interface
  --
  signal n_r_req             : std_logic;

  --
  -- sampling
  --
  signal rx_wire             : std_logic;
  signal rx_bit              : std_logic;
  signal rx_sample_en        : std_logic;
  signal rx_sample_wait      : std_logic;
  signal rx_sample_cnt       : t_baud_counter;
  signal rx_sample_tick      : std_logic;
  signal rx_sample_nr        : unsigned(3 downto 0);
  signal rx_sample_val       : unsigned(3 downto 0);

begin   ---------- BEGIN -------------------- BEGIN --------------------- BEGIN -------------------
  -- ----------------------------------------------------------------------------------------------
  --   _____ ______ _   _ _____    _      ____   _____ _____ _____ 
  --  / ____|  ____| \ | |  __ \  | |    / __ \ / ____|_   _/ ____|
  -- | (___ | |__  |  \| | |  | | | |   | |  | | |  __  | || |     
  --  \___ \|  __| | . ` | |  | | | |   | |  | | | |_ | | || |     
  --  ____) | |____| |\  | |__| | | |___| |__| | |__| |_| || |____ 
  -- |_____/|______|_| \_|_____/  |______\____/ \_____|_____\_____|
  -- ----------------------------------------------------------------------------------------------
  -- ____ ___ ____ ___ ____    _    ____ ____ _ ____ 
  -- [__   |  |__|  |  |___    |    |  | | __ | |    
  -- ___]  |  |  |  |  |___    |___ |__| |__] | |___ 
  --
  -- wait for request from upper level
  --
  tx_state_logic:
  process(  tx_state,
            t_req,
            tx_flags_in,
            data_bit
          )
  begin
    --
    -- <<<<<<<<<< DEFAULT VALUES >>>>>>>>>>>>>>>>
    --
    t_ack             <= '0';                   -- acknowledge to upper level

    --
    -- output flags
    --
    tx_flags_out      <= (data_store => '0',    -- no data input
                          data_shift => '0',    -- no data shift
                          data_cnt_load => '0'  -- no load of data count
                          );

    --
    -- TX wire
    --
    tx_bit            <= '1';                   -- drive '1' to wire

    --
    -- default state
    --
    n_tx_state        <= sIDLE;                 -- wait for request

    --
    -- <<<<<<<<<<< STATE LOGIC >>>>>>>>>>>>>>>>>>
    --
    case tx_state is
      -- <<<<<<<<<<<<<<< WAIT FOR REQUEST >>>>>>
      when sIDLE  =>
        if t_req = '1' then
          tx_flags_out.data_store       <= '1';     -- store data to send
          n_tx_state                    <= sSTART;  -- send start bit
        end if;

      -- <<<<<<<<<<<<<<< START BIT >>>>>>>>>>>>>>
      when sSTART =>
        tx_bit                          <= '0';     -- start bit

        if tx_flags_in.baud_tick = '1' then         -- start with data bits
          tx_flags_out.data_cnt_load    <= '1';     -- load data counter
          n_tx_state                    <= sDATA;
        else
          n_tx_state                    <= sSTART;
        end if;

      -- <<<<<<<<<<<<<<< SEND DATA BITS >>>>>>>>>>
      when sDATA  =>
        tx_bit                          <= data_bit;-- current data bit

        if tx_flags_in.baud_tick = '1' then         -- next bit
          tx_flags_out.data_shift       <= '1';     -- shift to next bit
          if tx_flags_in.data_full = '1' then       -- all bits sended
            n_tx_state                  <= sSTOP;
          else                                      -- there are still bits left
            n_tx_state                  <= sDATA; 
          end if;
        else
          n_tx_state                    <= sDATA;
        end if;

      -- <<<<<<<<<<<<<<<< STOP BIT >>>>>>>>>>>>>>>>
      when sSTOP  =>
        if tx_flags_in.baud_tick = '1' then
          t_ack                         <= '1';     -- acknowledge data sending
        else
          n_tx_state                    <= sSTOP;   -- remain for BIT_TIME in this state
        end if;

      when others =>
    end case;
  end process;

  -- ___ _  _    ____ ____ ____ _ ____ ___ ____ ____ ____ 
  --  |   \/     |__/ |___ | __ | [__   |  |___ |__/ [__  
  --  |  _/\_    |  \ |___ |__] | ___]  |  |___ |  \ ___] 
  tx_regs:
  process( clk )
  begin
    if rising_edge( clk ) then
      if rst = '1' then
        tx_state              <= sIDLE;
        tx_baud_cnt           <= (others => '0');
        tx_data_cnt           <= (others => '0');
        tx_data               <= (others => '0');
      else
        tx_state              <= n_tx_state;

        --
        -- TX BAUD COUNTER
        --
        if tx_flags_out.data_store = '1' then
          tx_baud_cnt         <= to_unsigned(2*to_integer(BIT_HALFTIME), 16);
        elsif tx_flags_in.baud_tick = '1' then
          tx_baud_cnt         <= to_unsigned(2*to_integer(BIT_HALFTIME), 16);
        else
          tx_baud_cnt         <= tx_baud_cnt - 1;
        end if;

        --
        -- TX DATA BIT COUNTER
        --
        if tx_flags_out.data_cnt_load = '1' then
          tx_data_cnt         <= (others => '1');
        elsif tx_flags_out.data_shift = '1' then
          tx_data_cnt         <= '0' & tx_data_cnt(6 downto 1);
        else
          tx_data_cnt         <= tx_data_cnt;
        end if;

        --
        -- TX DATA REGISTER
        --
           if tx_flags_out.data_store = '1' then
              tx_data         <= t_data;
        elsif tx_flags_out.data_shift = '1' then
              tx_data         <= tx_data(6 downto 0) & '0';
        else
              tx_data         <= tx_data;
        end if;
      end if;
    end if;
  end process;

  -- ___ _  _    ___ _ ____ _  _ ____ 
  --  |   \/      |  | |    |_/  [__  
  --  |  _/\_     |  | |___ | \_ ___] 
  tx_flags_in.baud_tick   <= '1' when tx_baud_cnt = BAUD_CNT_ZERO else '0';
  tx_flags_in.data_full   <= '1' when tx_data_cnt = DATA_CNT_ZERO else '0';

  -- ___ _  _    _ _ _ _ ____ ____ 
  --  |   \/     | | | | |__/ |___ 
  --  |  _/\_    |_|_| | |  \ |___ 
  tx                      <= tx_bit;

  -- ----------------------------------------------------------------------------------------------
  --  _____  ______ _____ ______ _______      ________   _      ____   _____ _____ _____ 
  -- |  __ \|  ____/ ____|  ____|_   _\ \    / /  ____| | |    / __ \ / ____|_   _/ ____|
  -- | |__) | |__ | |    | |__    | |  \ \  / /| |__    | |   | |  | | |  __  | || |     
  -- |  _  /|  __|| |    |  __|   | |   \ \/ / |  __|   | |   | |  | | | |_ | | || |     
  -- | | \ \| |___| |____| |____ _| |_   \  /  | |____  | |___| |__| | |__| |_| || |____ 
  -- |_|  \_\______\_____|______|_____|   \/   |______| |______\____/ \_____|_____\_____|
  -- ----------------------------------------------------------------------------------------------
  -- ____ ___ ____ ___ ____    _    ____ ____ _ ____ 
  -- [__   |  |__|  |  |___    |    |  | | __ | |    
  -- ___]  |  |  |  |  |___    |___ |__| |__] | |___ 
  --
  -- wait for start bit on rx wire
  --
  rx_state_logic:
  process(  rx_state,
            rx_wire,
            rx_flags_in
          )
  begin  
    --
    -- <<<<<<<<<< DEFAULT VALUES >>>>>>>>>>>>>>>>
    --
    n_r_req           <= '0';                   -- request flag for upper level

    --
    -- output flags
    --
    rx_flags_out      <= (data_store => '0',    -- no data input
                          data_shift => '0',    -- no data shift
                          data_cnt_load => '0'  -- no load of data count
                          );

    --
    -- default state
    --
    n_rx_state        <= sIDLE;                 -- wait for request

    --
    -- <<<<<<<<<<< STATE LOGIC >>>>>>>>>>>>>>>>>>
    --
    case rx_state is
      -- <<<<<<<<<<<<<<< WAIT FOR START BIT >>>>
      when sIDLE  =>
        if rx_wire = '0' then
          rx_flags_out.data_store       <= '1';     -- trigger baud counter
          n_rx_state                    <= sSTART;  -- get start bit
        end if;

      -- <<<<<<<<<<<<<<< START BIT >>>>>>>>>>>>>>
      when sSTART =>
        if rx_flags_in.baud_tick = '1' then         -- start with data bits
          rx_flags_out.data_cnt_load    <= '1';     -- load data counter
          n_rx_state                    <= sDATA;
        else
          n_rx_state                    <= sSTART;
        end if;

      -- <<<<<<<<<<<<<<< SEND DATA BITS >>>>>>>>>>
      when sDATA  =>
        if rx_flags_in.baud_tick = '1' then         -- next bit
          rx_flags_out.data_shift       <= '1';     -- shift to next bit
          if rx_flags_in.data_full = '1' then       -- all bits sended
            n_rx_state                  <= sSTOP;
          else                                      -- there are still bits left
            n_rx_state                  <= sDATA; 
          end if;
        else
          n_rx_state                    <= sDATA;
        end if;

      -- <<<<<<<<<<<<<<<< STOP BIT >>>>>>>>>>>>>>>>
      when sSTOP  =>
        if rx_flags_in.baud_tick = '1' then
          n_r_req                       <= '1';     -- indicate read data for upper level
        else
          n_rx_state                    <= sSTOP;   -- remain for BIT_TIME in this state
        end if;

      when others =>
    end case;
  end process;

  -- ____ _  _    ____ ____ ____ _ ____ ___ ____ ____ ____ 
  -- |__/  \/     |__/ |___ | __ | [__   |  |___ |__/ [__  
  -- |  \ _/\_    |  \ |___ |__] | ___]  |  |___ |  \ ___] 
  rx_regs:
  process( clk )
  begin
    if rising_edge( clk ) then
      if rst = '1' then
        rx_state              <= sIDLE;
        rx_wire               <= '1';
        rx_baud_cnt           <= (others => '0');
        rx_data_cnt           <= (others => '0');
        rx_data               <= (others => '0');
        r_req                 <= '0';
      else
        rx_state              <= n_rx_state;
        rx_wire               <= rx;                      -- synchronise RX wire value

        --
        -- TX BAUD COUNTER
        --
        if rx_flags_out.data_store = '1' then
          rx_baud_cnt         <= to_unsigned(2*to_integer(BIT_HALFTIME), 16);
        elsif rx_flags_in.baud_tick = '1' then
          rx_baud_cnt         <= to_unsigned(2*to_integer(BIT_HALFTIME), 16);
        else
          rx_baud_cnt         <= rx_baud_cnt - 1;
        end if;

        --
        -- TX DATA BIT COUNTER
        --
        if rx_flags_out.data_cnt_load = '1' then
          rx_data_cnt         <= (others => '1');
        elsif rx_flags_out.data_shift = '1' then
          rx_data_cnt         <= '0' & rx_data_cnt(6 downto 1);
        else
          rx_data_cnt         <= rx_data_cnt;
        end if;

        --
        -- TX DATA REGISTER
        --
           if rx_flags_out.data_store = '1' then
              rx_data         <= (others => '0');
        elsif rx_flags_out.data_shift = '1' then
              rx_data         <= rx_data(6 downto 0) & rx_bit;
        else
              rx_data         <= rx_data;
        end if;

        --
        -- UPPER LEVEL
        --
        if n_r_req = '1' then
          r_req               <= '1';
        elsif r_ack = '1' then
          r_req               <= '0';
        end if;

      end if;
    end if;
  end process;

  -- ____ _  _    ___ _ ____ _  _ ____ 
  -- |__/  \/      |  | |    |_/  [__  
  -- |  \ _/\_     |  | |___ | \_ ___] 
  rx_flags_in.baud_tick   <= '1' when rx_baud_cnt = BAUD_CNT_ZERO else '0';
  rx_flags_in.data_full   <= '1' when rx_data_cnt = DATA_CNT_ZERO else '0';

  -- ____ _  _    ____ ____ _  _ ___  _    _ _  _ ____ 
  -- |__/  \/     [__  |__| |\/| |__] |    | |\ | | __ 
  -- |  \ _/\_    ___] |  | |  | |    |___ | | \| |__] 
  rx_sampling:
  process( clk )
  begin
    if rising_edge( clk ) then
      if rst = '1' then
        rx_bit          <= '0';
        rx_sample_cnt   <= (others => '0');
        rx_sample_en    <= '0';
        rx_sample_nr    <= (others => '0');
        rx_sample_val   <= (others => '0');
      else
        --
        -- sample tick counter
        --
        if rx_flags_in.baud_tick = '1' then
          rx_sample_cnt <= BIT_HALFTIME;
          rx_sample_en  <= '1';
        else
          if rx_sample_wait = '1' then
            rx_sample_cnt   <= rx_sample_cnt - 1;
          else
            rx_sample_en    <= '0';
          end if;
        end if;

        --
        -- sample bit counter
        --
        if rx_sample_en = '1' then
          rx_sample_nr      <= (others => '1');
        else
          if rx_sample_tick = '1' then
            rx_sample_nr    <= rx_sample_nr - 1;
          end if;
        end if;

        --
        -- <<<<<<<<<< SAMPLING >>>>>>>>>>
        --
        if rx_flags_in.baud_tick = '1' then
          rx_sample_val    <= (others => '0');
        else
          if (rx_sample_tick = '1') and (rx_sample_en = '0') then
            if rx_wire = '1' then
              rx_sample_val   <= rx_sample_val + 1;
            end if;
          end if;
        end if;

        -- ____ _  _    ___  _ ___ 
        -- |__/  \/     |__] |  |  
        -- |  \ _/\_    |__] |  |  
        --
        -- compare rx_sample_value with threshold value
        --
        if rx_sample_val > SAMPLE_THRES then
          rx_bit        <= '1';
        else
          rx_bit        <= '0';
        end if;
      end if;
    end if;
  end process;

  --
  -- sampling flags
  --
  rx_sample_wait  <= '0' when rx_sample_cnt = BAUD_CNT_ZERO        else '1';
  rx_sample_tick  <= '0' when rx_sample_nr  = b"0000"              else '1';

  -- ____ _  _    ___  ____ ___ ____ 
  -- |__/  \/     |  \ |__|  |  |__| 
  -- |  \ _/\_    |__/ |  |  |  |  | 
  r_data          <= rx_data;

end architecture structure_uart;
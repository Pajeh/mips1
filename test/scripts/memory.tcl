if { ! [info exists FPGA]      } { set FPGA    0 }

# #################################################################################################
# _    ____ ____ ___     _  _ ____ _  _ ____ ____ _   _ 
# |    |  | |__| |  \    |\/| |___ |\/| |  | |__/  \_/  
# |___ |__| |  | |__/    |  | |___ |  | |__| |  \   |   
#
# write content of a extern file to memory
#
proc load_memory { } {

  global FPGA

  #
  # generic memory model
  #
  if { $FPGA == 0 } {
    mem load -infile memory_in.mem -format hex -filltype value -filldata 8'h00  /tb_cpu/u2_memory/ram
  } else {
    mem load -infile memory_in.mem -format hex -filltype value -filldata 8'h00  /tb_cpu/u2_memory/ram_unit/ram
  }
}

# #################################################################################################
# ____ ___ ____ ____ ____    _  _ ____ _  _ ____ ____ _   _ 
# [__   |  |  | |__/ |___    |\/| |___ |\/| |  | |__/  \_/  
# ___]  |  |__| |  \ |___    |  | |___ |  | |__| |  \   |   
#
# write content of memory to extern file
#
proc store_memory { } {

  # 0x8D_0000
  set OUTPUT_START_ADDR      9240576
  # 0x8D_0000 + 0xD_0000 = 0x9A_0000
  set OUTPUT_END_ADDR       10092544

  #
  # generic memory model
  #
  mem save -format hex -wordsperline 32 -st $OUTPUT_START_ADDR -end $OUTPUT_END_ADDR -outfile memory_out.mem /tb_cpu/u2_memory/ram
}

# #################################################################################################
# _ _  _ _ ___ _ ____ _    _ ____ ____ ___ _ ____ _  _ 
# | |\ | |  |  | |__| |    | [__  |__|  |  | |  | |\ | 
# | | \| |  |  | |  | |___ | ___] |  |  |  | |__| | \| 
#
# triggered on "init" signal
#
when { init = 1 } {

  echo "Memory initialisation start"
  load_memory
  echo "Memory initialisation done"
}

# #################################################################################################
# ____ _ _  _ _  _ _    ____ ___ _ ____ _  _    ____ _  _ _ ___ 
# [__  | |\/| |  | |    |__|  |  | |  | |\ |    |___  \/  |  |  
# ___] | |  | |__| |___ |  |  |  | |__| | \|    |___ _/\_ |  |  
#
when { sim_finish = 1 } {
    stop
    store_memory
    exit -f
}

# #################################################################################################
# ____ ___  ____ _  _    ____ ____ ____ ____ ____ ____ _  _ ____ ____ 
# |  | |__] |___ |\ |    |__/ |___ |___ |___ |__/ |___ |\ | |    |___ 
# |__| |    |___ | \|    |  \ |___ |    |___ |  \ |___ | \| |___ |___ 
proc open_ref { {name counter.wlf} } {

  global FPGA

  #
  # create new pane
  #
  quietly WaveActivateNextPane

  #
  # open dataset
  #
  dataset open $name reference

  #
  # add signals
  #
  add wave -noupdate -radix sym -label clk {reference:/tb_cpu/clk}
  add wave -noupdate -radix sym -label rst {reference:/tb_cpu/rst}
  add wave -noupdate -divider REFERENCE_DESIGN
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label instr_addr {reference:/tb_cpu/instr_addr}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label instr_stall {reference:/tb_cpu/instr_stall}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label instr_in {reference:/tb_cpu/instr_in}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label data_addr {reference:/tb_cpu/data_addr}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label data_stall {reference:/tb_cpu/data_stall}
  add wave -noupdate  -group REFERENCE_CPU -radix bin -label wr_mask {reference:/tb_cpu/wr_mask}
  add wave -noupdate  -group REFERENCE_CPU -radix bin -label rd_mask {reference:/tb_cpu/rd_mask}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label data_to_cpu {reference:/tb_cpu/data_to_cpu}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label data_from_cpu {reference:/tb_cpu/data_from_cpu}
  add wave -noupdate  -group REFERENCE_CPU -radix hex -label reg_bank {reference:/plasma_pack/plasma_rbank(0)}

  if { $FPGA == 1 } { 
    add wave -noupdate                       -radix hex -label memory {reference:/tb_cpu/u2_memory/ram_unit/ram}
  } else {
    add wave -noupdate                       -radix hex -label memory {reference:/tb_cpu/u2_memory/ram}
  }
}


# #################################################################################################
# ____ ____ ____    ____ ____ _  _ _  _ ___ ____ ____ 
# |__/ |___ |___    |    |  | |  | |\ |  |  |___ |__/ 
# |  \ |___ |       |___ |__| |__| | \|  |  |___ |  \ 
# 
# simulation test
#
proc open_counter {} {open_ref counter.wlf}

#
# FPGA test
#
proc open_counter_fpga {} {open_ref counter_fpga.wlf}


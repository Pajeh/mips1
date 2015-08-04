// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:  Dipl.-Ing. Alex Schoenberger
// Email:   Alex.Schoenberger@ies.tu-darmstadt.de
// Purpose: counts human noticable for FPGA test

#define N 32

volatile unsigned char * addr   = 0x84;        // address of counter
volatile int i                  = 0x76543210;  //marker in .bss field

main_user() {
  *addr = 0;

  while(1){
    for(i = 0; i < 16; i++)            // simulation test
    //for(i = 0; i < 200000000; i++)   // fpga test
      ;

    *addr = *addr + 1;
  }
  return 0;
}
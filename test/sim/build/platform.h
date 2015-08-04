#ifndef PLATFORM_H
#define PLATFORM_H

// //////////////////////////////////////////////////////////////////////////////////////
// ____ ____ _  _ ____ ____ ____ _       _ _  _ ____ ____ ____ _  _ ____ ___ _ ____ _  _ 
// | __ |___ |\ | |___ |__/ |__| |       | |\ | |___ |  | |__/ |\/| |__|  |  | |  | |\ | 
// |__] |___ | \| |___ |  \ |  | |___    | | \| |    |__| |  \ |  | |  |  |  | |__| | \| 
//
// GENERAL INFORMATION ABOUT HARDWARE SIMULATION PLATFORM
//

//
// NUMBER OF CORES
//
#define NOC_INFO_CORE_NUMBER          1                       // number of cores in the noc

//
// DRAM EMULATION
//
// 0 - disabled
// 1 - enabled
//
#define NOC_INFO_DRAM                 0

//
// 3D DRAM EMULATION
//
// 0 - disabled
// 1 - enabled
//
#define NOC_INFO_3D_DRAM              0

// //////////////////////////////////////////////////////////////////////////////////////
// ____ ____ ____ ____    ____ ___  ____ ____ _ ____ _ ____ 
// |    |  | |__/ |___    [__  |__] |___ |    | |___ | |    
// |___ |__| |  \ |___    ___] |    |___ |___ | |    | |___ 

//
// //////////// CORE 0 ////////////////////////
//
// start function
#define NOC_CORE0_START           "main_user"

// initial stack pointer value
#define NOC_CORE0_STACK_INIT                      0xA20000

// //////////////////////////////////////////////////////////////////////////////////////
#endif /* PLATFORM_H */
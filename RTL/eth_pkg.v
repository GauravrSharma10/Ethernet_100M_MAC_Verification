

  // -------------------------------------------------------------------
  // Global Definitions & Timing
  // -------------------------------------------------------------------
  `include "ethmac_defines.v"

  // -------------------------------------------------------------------
  // Memory & Primitive Blocks
  // -------------------------------------------------------------------
  `include "eth_spram_256x32.v"
  `include "xilinx_dist_ram_16x32.v"
  `include "eth_fifo.v"
  `include "eth_shiftreg.v"

  // -------------------------------------------------------------------
  // Utility & Common Logic
  // -------------------------------------------------------------------
  `include "eth_clockgen.v"
  `include "eth_crc.v"
  `include "eth_random.v"

  // -------------------------------------------------------------------
  // Receive Path
  // -------------------------------------------------------------------
  `include "eth_receivecontrol.v"
  `include "eth_rxaddrcheck.v"
  `include "eth_rxcounters.v"
  `include "eth_rxstatem.v"
  `include "eth_rxethmac.v"

  // -------------------------------------------------------------------
  // Transmit Path
  // -------------------------------------------------------------------
  `include "eth_transmitcontrol.v"
  `include "eth_txcounters.v"
  `include "eth_txstatem.v"
  `include "eth_txethmac.v"

  // -------------------------------------------------------------------
  // MAC Control & Status
  // -------------------------------------------------------------------
  `include "eth_outputcontrol.v"
  `include "eth_maccontrol.v"
  `include "eth_macstatus.v"

  // -------------------------------------------------------------------
  // Bus Interface & Registers
  // -------------------------------------------------------------------
  `include "eth_wishbone.v"
  `include "eth_miim.v"
  `include "eth_register.v"
  `include "eth_registers.v"

  // -------------------------------------------------------------------
  // Top-Level Integration
  // -------------------------------------------------------------------
  `include "eth_cop.v"
//   `include "eth_top.v"
//   `include "ethmac.v"


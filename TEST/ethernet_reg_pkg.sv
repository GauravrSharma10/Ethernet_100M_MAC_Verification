package eth_reg_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Registers
  `include "eth_moder_reg.sv"
  `include "eth_int_source_reg.sv"
  `include "eth_int_mask_reg.sv"
  `include "eth_ipgt_reg.sv"
  `include "eth_ipgr1_reg.sv"
  `include "eth_ipgr2_reg.sv"
  `include "eth_packetlen_reg.sv"
  `include "eth_collconf_reg.sv"
  `include "eth_tx_bd_num_reg.sv"
  `include "eth_mac_addr0_reg.sv"
  `include "eth_mac_addr1_reg.sv"
  `include "eth_ctrlmoder_reg.sv"
  // Block
  `include "eth_reg_block.sv"
endpackage

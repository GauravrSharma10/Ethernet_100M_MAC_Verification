///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_test_pkg.sv
//
// Author:
// Date: 12/12/2025
// Revision: 1
//
// Company: Scaledge Technology Pvt.
//
// Copyright (c) 2025 Scaledge Technology Pvt. All rights reserved.
//
// This file is part of the Ethernet_MAC_VIP project.
//
// Description: Test package.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_TEST_PKG_SV
`define ETHERNET_MAC_TEST_PKG_SV


`include "mac_interface.sv"
`include "wishbone_master_interface.sv"
`include "wishbone_slave_interface.sv"
`include "phy_tx_interface.sv"
`include "phy_rx_interface.sv"
`include "miim_interface.sv"
`include "assertions.sv"
package ethernet_mac_test_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;


    // sequence_items and sequences 
  `include "wishbone_memory.sv"
  `include "wishbone_seq_item.sv"
  `include "phy_seq_item.sv"

  `include "phy_rx_sequence.sv"
 //  `include "phy_tx_sequence.sv"

  // Config Objects
  `include "port_config.sv"
  `include "system_config.sv"
 

  // Agents
  // Wishbone Master
 
   
 `include "wishbone_master_sequencer.sv"
 `include "wishbone_master_driver.sv"
  `include "wishbone_master_monitor.sv"
  `include "wishbone_master_agent.sv"

  // Wishbone Slave
   `include "wishbone_slave_sequencer.sv"
  `include "wishbone_slave_driver.sv"
  `include "wishbone_slave_monitor.sv"
  `include "wishbone_slave_agent.sv"
  `include "reg_wishbone_adapter.sv"
  `include "wishbone_slave_sequence.sv"

  // Tx Phy
  `include "tx_phy_driver.sv"
  `include "tx_phy_monitor.sv"
  `include "tx_phy_sequencer.sv"
  `include "tx_phy_agent.sv"

  // Rx Phy
  `include "rx_phy_driver.sv"
  `include "rx_phy_monitor.sv"
  `include "rx_phy_sequencer.sv"
  `include "rx_phy_agent.sv"

  // MIIM
  `include "miim_driver.sv"
  `include "miim_monitor.sv"
  `include "miim_sequencer.sv"
  `include "miim_agent.sv"

  // Environment Components

  `include "ethernet_mac_scoreboard.sv"
  `include "ethernet_mac_cov_collector.sv"
  `include "ethernet_mac_checker.sv"
  `include "ethernet_mac_virtual_sequencer.sv"

  //RAL FILES
  `include "eth_collconf_reg.sv"
	`include "eth_hash0_reg.sv"
	`include "eth_hash1_reg.sv"
  `include "eth_int_mask_reg.sv"
  `include "eth_int_source_reg.sv"
  `include "eth_ipgr1_reg.sv"
  `include "eth_ipgr2_reg.sv"
  `include "eth_ipgt_reg.sv"
  `include "eth_mac_addr0_reg.sv"
  `include "eth_mac_addr1_reg.sv"
	`include "eth_miiaddress_reg.sv"
	`include "eth_miicommand_reg.sv"
	`include "eth_miimoder_reg.sv"
	`include "eth_miirx_data_reg.sv"
	`include "eth_miistatus_reg.sv"
	`include "eth_miitx_data_reg.sv"
	`include "eth_moder_reg.sv"
  `include "eth_packetlen_reg.sv"
	`include "eth_rx_bd_reg.sv"
	`include "eth_tx_bd_reg.sv"
	`include "eth_tx_bd_num_reg.sv"
	`include "eth_txctrl_reg.sv"
    `include "eth_ctrlmoder_reg.sv"
  // Block
  `include "eth_reg_block.sv"


	`include "tx_phy_base_sequence.sv"



  `include "ethernet_mac_env.sv"
  `include "reg_seq.sv"
  // Tests
  `include "ethernet_mac_base_test.sv"
  `include "reg_test.sv"

endpackage

`endif

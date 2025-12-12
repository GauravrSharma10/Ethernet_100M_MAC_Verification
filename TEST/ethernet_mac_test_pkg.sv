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

package ethernet_mac_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

//   // Forward declarations
//   typedef class wishbone_master_agent;
//   typedef class wishbone_slave_agent;
//   typedef class tx_phy_agent;
//   typedef class rx_phy_agent;
//   typedef class miim_agent;
//   typedef class ethernet_mac_scoreboard;
//   typedef class ethernet_mac_cov_collector;
//   typedef class ethernet_mac_checker;
//   typedef class ethernet_mac_virtual_sequencer;
//   typedef class ethernet_mac_env;
//   typedef class ethernet_mac_base_test;
//   typedef class system_config;
//   typedef class port_config;

  // Config Objects
  `include "port_config.sv"
  `include "system_config.sv"

  // Agents
  // Wishbone Master
  `include "wishbone_master_driver.sv"
  `include "wishbone_master_monitor.sv"
  `include "wishbone_master_sequencer.sv"
  `include "wishbone_master_agent.sv"

  // Wishbone Slave
  `include "wishbone_slave_driver.sv"
  `include "wishbone_slave_monitor.sv"
  `include "wishbone_slave_sequencer.sv"
  `include "wishbone_slave_agent.sv"

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
  `include "ethernet_mac_env.sv"

  // Tests
  `include "ethernet_mac_base_test.sv"


endpackage

`endif


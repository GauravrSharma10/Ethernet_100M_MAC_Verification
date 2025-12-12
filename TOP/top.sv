///////////////////////////////////////////////////////////////////////////////////
// Filename: top.sv
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
// Description: Top level testbench module.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`include "ethernet_mac_test_pkg.sv"

module top;
  import uvm_pkg::*;
  import ethernet_mac_test_pkg::*;

  logic clk;
  logic rst_n;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // Interface Instantiation
  mac_interface intf(clk, rst_n);

  initial begin
    // Pass interfaces to config_db
    uvm_config_db#(virtual wishbone_master_interface)::set(null, "*.wb_mst_agent_h.*", "vif", intf.wb_master_if);
    uvm_config_db#(virtual wishbone_slave_interface)::set(null, "*.wb_slv_agent_h.*", "vif", intf.wb_slave_if);
    uvm_config_db#(virtual phy_tx_interface)::set(null, "*.tx_phy_agent_h.*", "vif", intf.phy_tx_if);
    uvm_config_db#(virtual phy_rx_interface)::set(null, "*.rx_phy_agent_h.*", "vif", intf.phy_rx_if);
    uvm_config_db#(virtual miim_interface)::set(null, "*.miim_agent_h.*", "vif", intf.miim_if);

    run_test("ethernet_mac_base_test");
  end

endmodule


///////////////////////////////////////////////////////////////////////////////////
// Filename: rx_phy_monitor.sv
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
// Description: rx Phy Monitor component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef RX_PHY_MONITOR_SV
`define RX_PHY_MONITOR_SV

class rx_phy_monitor extends uvm_monitor;
  `uvm_component_utils(rx_phy_monitor)

  virtual phy_rx_interface vif;
  uvm_analysis_port #(uvm_sequence_item) ap;
  
  bit enable_preamble = 1;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "rx_phy_monitor", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "rx_phy_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual phy_rx_interface)::get(this, "", "r_vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for rx_phy_monitor")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for monitoring signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
  endtask

endclass

`endif


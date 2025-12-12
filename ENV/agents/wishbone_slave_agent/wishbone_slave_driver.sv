///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_slave_driver.sv
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
// Description: Wishbone Slave Driver component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_SLAVE_DRIVER_SV
`define WISHBONE_SLAVE_DRIVER_SV

class wishbone_slave_driver extends uvm_driver #(uvm_sequence_item);
  `uvm_component_utils(wishbone_slave_driver)

  virtual wishbone_slave_interface vif;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_slave_driver", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wishbone_slave_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for wishbone_slave_driver")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for driving signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    // Driver logic
  endtask

endclass

`endif


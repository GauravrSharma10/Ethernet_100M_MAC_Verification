///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_master_agent.sv
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
// Description: Wishbone Master Agent component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_MASTER_AGENT_SV
`define WISHBONE_MASTER_AGENT_SV

class wishbone_master_agent extends uvm_agent;
  `uvm_component_utils(wishbone_master_agent)

  wishbone_master_driver    driver;
  wishbone_master_monitor   monitor;
  wishbone_master_sequencer sequencer;
  port_config               cfg;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_master_agent", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_master_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to create components
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = wishbone_master_monitor::type_id::create("monitor", this);
    if(get_is_active() == UVM_ACTIVE) begin
      driver = wishbone_master_driver::type_id::create("driver", this);
      sequencer = wishbone_master_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : connect_phase
  // argument : uvm_phase phase
  // description : Connect phase to connect driver and sequencer
  ////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif


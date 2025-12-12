///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_slave_sequencer.sv
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
// Description: Wishbone Slave Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_SLAVE_SEQUENCER_SV
`define WISHBONE_SLAVE_SEQUENCER_SV

class wishbone_slave_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(wishbone_slave_sequencer)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_slave_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_slave_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif


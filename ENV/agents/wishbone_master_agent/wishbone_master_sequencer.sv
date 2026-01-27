///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_master_sequencer.sv
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
// Description: Wishbone Master Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_MASTER_SEQUENCER_SV
`define WISHBONE_MASTER_SEQUENCER_SV

class wishbone_master_sequencer extends uvm_sequencer #(wishbone_seq_item);
  `uvm_component_utils(wishbone_master_sequencer)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_master_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_master_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif

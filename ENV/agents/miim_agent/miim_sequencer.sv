///////////////////////////////////////////////////////////////////////////////////
// Filename: miim_sequencer.sv
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
// Description: MIIM Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef MIIM_SEQUENCER_SV
`define MIIM_SEQUENCER_SV

class miim_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(miim_sequencer)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "miim_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "miim_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif


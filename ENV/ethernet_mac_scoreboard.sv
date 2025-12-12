///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_scoreboard.sv
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
// Description: Scoreboard component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_SCOREBOARD_SV
`define ETHERNET_MAC_SCOREBOARD_SV

class ethernet_mac_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ethernet_mac_scoreboard)

  uvm_analysis_imp #(uvm_sequence_item, ethernet_mac_scoreboard) item_imp;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_scoreboard", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    item_imp = new("item_imp", this);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : write
  // argument : uvm_sequence_item item
  // description : Analysis implementation write function
  ////////////////////////////////////////////////////////////////////////
  function void write(uvm_sequence_item item);
    // Scoreboard logic
  endfunction

endclass

`endif


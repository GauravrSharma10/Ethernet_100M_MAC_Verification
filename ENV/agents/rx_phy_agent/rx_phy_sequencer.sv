///////////////////////////////////////////////////////////////////////////////////
// Filename: rx_phy_sequencer.sv
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
// Description: Rx Phy Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef RX_PHY_SEQUENCER_SV
`define RX_PHY_SEQUENCER_SV

class rx_phy_sequencer extends uvm_sequencer #(phy_seq_item);
  `uvm_component_utils(rx_phy_sequencer)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "rx_phy_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "rx_phy_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif

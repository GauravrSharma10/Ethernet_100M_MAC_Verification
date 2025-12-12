///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_virtual_sequencer.sv
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
// Description: Virtual sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_VIRTUAL_SEQUENCER_SV
`define ETHERNET_MAC_VIRTUAL_SEQUENCER_SV

class ethernet_mac_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(ethernet_mac_virtual_sequencer)

  wishbone_master_sequencer wb_mst_seqr_h;
  wishbone_slave_sequencer  wb_slv_seqr_h;
  tx_phy_sequencer          tx_phy_seqr_h;
  rx_phy_sequencer          rx_phy_seqr_h;
  miim_sequencer            miim_seqr_h;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_virtual_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif


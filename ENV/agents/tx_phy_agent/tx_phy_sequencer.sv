///////////////////////////////////////////////////////////////////////////////////
// Filename: tx_phy_sequencer.sv
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
// Description: Tx Phy Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef TX_PHY_SEQUENCER_SV
`define TX_PHY_SEQUENCER_SV

class tx_phy_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(tx_phy_sequencer)

  virtual phy_tx_interface vif;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "tx_phy_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "tx_phy_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);

    if(!uvm_config_db#(virtual phy_tx_interface)::get(this, "", "vif", vif))
      `uvm_fatal(get_name(), "Virtual interface not set for tx_phy_monitor")	
  endfunction

  endclass

`endif

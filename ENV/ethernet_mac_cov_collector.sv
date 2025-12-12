///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_cov_collector.sv
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
// Description: Coverage collector component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_COV_COLLECTOR_SV
`define ETHERNET_MAC_COV_COLLECTOR_SV

class ethernet_mac_cov_collector extends uvm_subscriber #(uvm_sequence_item);
  `uvm_component_utils(ethernet_mac_cov_collector)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_cov_collector", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_cov_collector", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : write
  // argument : uvm_sequence_item t
  // description : Subscriber write function
  ////////////////////////////////////////////////////////////////////////
  function void write(uvm_sequence_item t);
    // Coverage logic
  endfunction

endclass

`endif


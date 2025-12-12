///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_checker.sv
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
// Description: Checker component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_CHECKER_SV
`define ETHERNET_MAC_CHECKER_SV

class ethernet_mac_checker extends uvm_component;
  `uvm_component_utils(ethernet_mac_checker)

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_checker", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_checker", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

`endif


///////////////////////////////////////////////////////////////////////////////////
// Filename: system_config.sv
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
// Description: System configuration object.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef SYSTEM_CONFIG_SV
`define SYSTEM_CONFIG_SV

class system_config extends uvm_object;
  `uvm_object_utils(system_config)

  rand int num_masters;
  rand int num_slaves;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "system_config"
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "system_config");
    super.new(name);
  endfunction

endclass

`endif


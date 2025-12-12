///////////////////////////////////////////////////////////////////////////////////
// Filename: port_config.sv
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
// Description: Port configuration object.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef PORT_CONFIG_SV
`define PORT_CONFIG_SV

class port_config extends uvm_object;
  `uvm_object_utils(port_config)

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "port_config"
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "port_config");
    super.new(name);
  endfunction

endclass

`endif


 ///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_seq_item.sv
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
// Description: Wishbone Sequence item..
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

class wishbone_seq_item extends uvm_sequence_item;

  // --- Physical Signals ---
  rand logic [31:0] addr;   // Address
  rand logic [31:0] data_q[$];   // Data (Write data_q if we=1, Read data_q if we=0)
  rand logic        we;     // Write Enable (1=Write, 0=Read)

  `uvm_object_utils_begin(wishbone_seq_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_queue_int(data_q, UVM_ALL_ON)
    `uvm_field_int(we,   UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "wishbone_seq_item");
    super.new(name);
  endfunction

endclass

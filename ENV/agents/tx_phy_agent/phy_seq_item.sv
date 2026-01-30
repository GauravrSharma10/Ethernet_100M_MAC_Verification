///////////////////////////////////////////////////////////////////////////////////
// Filename: phy_seq_item.sv
//
// Author: Gaurav
// Date: 15/12/2025
// Revision: 1
//
// Company: Scaledge Technology Pvt.
//
// Copyright (c) 2025 Scaledge Technology Pvt. All rights reserved.
//
// This file is part of the Ethernet_MAC_VIP project.
//
// Description: Physical Layer Sequence Item, that will be used by both TX and RX Phy agent.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef PHY_SEQ_ITEM
`define PHY_SEQ_ITEM

class phy_seq_item extends uvm_sequence_item;
  rand bit preamble_received;
  rand bit sfd_received;
  rand byte dest_addr [$];
  rand byte src_addr  [$];
  rand bit[15:0] length_type;
  rand byte payload   [$];
  rand byte crc       [$];
 
  `uvm_object_utils_begin(phy_seq_item)
  `uvm_field_int(preamble_received, UVM_ALL_ON)
  `uvm_field_int(sfd_received, UVM_ALL_ON)
  `uvm_field_queue_int(dest_addr, UVM_ALL_ON)
  `uvm_field_queue_int(src_addr, UVM_ALL_ON)
  `uvm_field_int(length_type, UVM_ALL_ON)
  `uvm_field_queue_int(payload, UVM_ALL_ON)
  `uvm_field_queue_int(crc, UVM_ALL_ON) 
  `uvm_object_utils_end


  function new(string name = "phy_seq_item");
    super.new(name);
  endfunction



  constraint payload_c{
    payload.size() > 46;
    payload.size() < 270;
  }
  constraint mac_size_c {
    dest_addr.size() == 6;
    src_addr.size()  == 6;
    crc.size()       == 4;
    length_type == payload.size();
  }

endclass

`endif

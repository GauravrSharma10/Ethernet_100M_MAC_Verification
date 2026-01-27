///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_slave_sequencer.sv
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
// Description: Wishbone Slave Sequencer component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////
 
`ifndef WISHBONE_SLAVE_SEQUENCER_SV
`define WISHBONE_SLAVE_SEQUENCER_SV
 
class wishbone_slave_sequencer extends uvm_sequencer #(wishbone_seq_item);
  `uvm_component_utils(wishbone_slave_sequencer)
  uvm_analysis_export #(wishbone_seq_item) request_export; 
  uvm_tlm_analysis_fifo#(wishbone_seq_item)request_fifo;
  
  // Storage model
 wishbone_storage wb_storage;
 
  

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_slave_sequencer", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_slave_sequencer", uvm_component parent = null);
    super.new(name, parent);
     request_fifo=new("request_fifo",this);
    request_export = new("request_export",this);
    wb_storage=new("wb_storage",this);
  endfunction
 
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   `uvm_info("Inside connect","Wb_slave_sequencer connect_phase",UVM_LOW)
     request_export.connect(request_fifo.analysis_export); 
  endfunction

endclass
`endif
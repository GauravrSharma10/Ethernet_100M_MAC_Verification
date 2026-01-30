///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_master_monitor.sv
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
// Description: Wishbone Master Monitor component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_MASTER_MONITOR_SV
`define WISHBONE_MASTER_MONITOR_SV

class wishbone_master_monitor extends uvm_monitor;
  `uvm_component_utils(wishbone_master_monitor)

  virtual wishbone_master_interface m_vif;
  uvm_analysis_port #(wishbone_seq_item) ap;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_master_monitor", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_master_monitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wishbone_master_interface)::get(this, "", "m_vif", m_vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for wishbone_master_monitor")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for monitoring signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    // Monitor logic would go here
		/*forever begin
      @(`dsvif);
      if (`dsvif.cyc && `dsvif.stb ) begin

        req = wishbone_seq_item::type_id::create("req");
        
        req.we   = `dsvif.we;
        req.addr = `dsvif.adr; 
        
        
        if(`dsvif.we)begin    
          req.data  = `dsvif.dat_w;
      
        end
         
        `uvm_info(get_name(),$sformatf("monitored transaction : %s",req.sprint()),UVM_NONE)
        transaction_aport.write(req);
        request_aport.write(req);
        `uvm_info(get_type_name(), "After sending req to slave sequencer",UVM_HIGH)
         fork
           begin
             do begin
               @(`dsvif);
             end while (!`dsvif.ack); // and because if one is false then condition is true
						 @(`dsvif iff(`dsvif.ack));
           end
           begin
             #100;
             `uvm_error(get_full_name,"not recieving ack");
           end
         join_any
         disable fork;
      end
			else
        @(`dsvif);
			  
    end*/
  endtask

endclass

`endif

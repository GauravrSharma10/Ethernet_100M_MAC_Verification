 ///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_slave_monitor.sv
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
// Description: Wishbone Slave Monitor component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////
 
`ifndef WISHBONE_SLAVE_MONITOR_SV
`define WISHBONE_SLAVE_MONITOR_SV

 `define dsvif s_vif.mon_cb

 typedef eth_reg_block;

class wishbone_slave_monitor extends uvm_monitor;
  `uvm_component_utils(wishbone_slave_monitor)
 
  eth_reg_block         reg_blk_h;
  virtual wishbone_slave_interface s_vif;
  uvm_analysis_port #(wishbone_seq_item) transaction_aport;
  uvm_analysis_port #(wishbone_seq_item) request_aport;
  uvm_reg_data_t read_data;
  
  wishbone_seq_item req;
  
   
  
  ////////////////////////////////////////////////////////////////////////
  // function nameor", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_slave_monitor", uvm_component parent = null);
    super.new(name, parent);
    request_aport = new("request_aport", this);
    transaction_aport = new("transaction_aport", this);
  endfunction
 
  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wishbone_slave_interface)::get(this, "", "s_vif", s_vif))
      `uvm_fatal("NO vif", "Virtual interface not set for wishbone_master_driver")
  endfunction
  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for monitoring signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
	  fork
      forever begin
      @(`dsvif);
      read_data = reg_blk_h.tx_bd[0].get_mirrored_value();
      $display($time,"mirrored value monitor: %0h",read_data);
			if(read_data[15] == 1'b1)begin
			  $display($time,"started slave transaction");
			end
			end
		join_none
		fork 
      forever begin
        @(`dsvif);
        if (`dsvif.cyc && `dsvif.stb ) begin

          req = wishbone_seq_item::type_id::create("req");
        
          req.we   = `dsvif.we;
          req.addr = `dsvif.adr; 
        
        
          if(`dsvif.we)begin    
            req.data_q.push_back(`dsvif.dat_w);
      
          end
         
          `uvm_info(get_name(),$sformatf("monitored transaction : %s",req.sprint()),UVM_NONE)
          transaction_aport.write(req);
          request_aport.write(req);
          `uvm_info(get_type_name(), "After sending req to slave sequencer",UVM_HIGH)
          fork
            begin
              /*do begin
                @(`dsvif);
             end while (!`dsvif.ack); // and because if one is false then condition is true*/
						 @(`dsvif iff(`dsvif.ack));
            end
            begin
              #100;
              `uvm_error(get_full_name,"not recieving ack");
            end
          join_any
          disable fork;
			 	  req.data_q.push_back(`dsvif.dat_r);
          `uvm_info(get_name(),$sformatf("monitored transaction complete: %s",req.sprint()),UVM_NONE)
        end
			  //else
          //@(`dsvif);
			  
      end 

			forever begin
        @(`dsvif);
        /*if(read_data[15] == 1'b1)begin
				  if (`dsvif.cyc && `dsvif.stb ) begin

            req = wishbone_seq_item::type_id::create("req");
        
            req.we   = `dsvif.we;
            req.addr = `dsvif.adr; 
        
        
            if(`dsvif.we)begin    
              req.data_q  = `dsvif.dat_w;
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
			 	    req.data_q = `dsvif.dat_r;
            `uvm_info(get_name(),$sformatf("monitored transaction complete: %s",req.sprint()),UVM_NONE)
        end*/
			end

	  join
  endtask

endclass

`endif

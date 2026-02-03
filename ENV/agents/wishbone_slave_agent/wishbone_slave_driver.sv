///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_slave_driver.sv
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
// Description: Wishbone Slave Driver component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////
 
`ifndef WISHBONE_SLAVE_DRIVER_SV
`define WISHBONE_SLAVE_DRIVER_SV
 
class wishbone_slave_driver extends uvm_driver #(wishbone_seq_item);
  `uvm_component_utils(wishbone_slave_driver)
 
  virtual wishbone_slave_interface s_vif;
  
  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_slave_driver", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_slave_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wishbone_slave_interface)::get(this, "", "s_vif", s_vif))
      `uvm_fatal("NO vif", "Virtual interface not set for wishbone_slave_driver")
  endfunction
 
  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for driving signals
  ////////////////////////////////////////////////////////////////////////
 task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Slave driver started", UVM_LOW)
		wait_for_rst_assert();
    forever begin
      @(s_vif.drv_cb iff(!s_vif.rst_n));
		  fork 
        forever begin
          seq_item_port.get_next_item(req);
          `uvm_info(get_name(),$sformatf("sequence item : %s",req.sprint()),UVM_HIGH) 
          drive_response(req);
          seq_item_port.item_done();
        end
		    wait_for_rst_assert();
			join_any
		  disable fork;
		end
  endtask

    task drive_response(wishbone_seq_item tr);
       @(s_vif.drv_cb);
       s_vif.drv_cb.ack   <= 1'b0;
       s_vif.drv_cb.dat_r <= '0;

       case (tr.we)
         1: begin
              //@(s_vif.drv_cb);
              if (s_vif.drv_cb.cyc && s_vif.drv_cb.stb && s_vif.drv_cb.we) begin
                s_vif.drv_cb.ack <= 1'b1;
                @(s_vif.drv_cb);
                s_vif.drv_cb.ack <= 1'b0;
                `uvm_info("SLAVE DRIVER","ACKED BLOCK WRITE BEAT", UVM_LOW)
              end
         end
         0: begin
              //@(s_vif.drv_cb);
              if (s_vif.drv_cb.cyc && s_vif.drv_cb.stb && !s_vif.drv_cb.we) begin
                s_vif.drv_cb.dat_r <= tr.data_q.pop_front();
                s_vif.drv_cb.ack   <= 1'b1;
                @(s_vif.drv_cb);
                s_vif.drv_cb.ack  <= 1'b0;
              end
         end
        default: begin
          `uvm_error("WB_SLAVE_DRV","Unsupported transaction type")
        end
      endcase
    `uvm_info("SLAVE DRIVER", "DRIVE RESPONSE TASK IS EXECUTED", UVM_LOW)
  endtask

	task wait_for_rst_assert();
	  @(posedge s_vif.rst_n);
    s_vif.drv_cb.dat_r <= 'd0;
    s_vif.drv_cb.ack  <= 1'b0;
  endtask

endclass
`endif

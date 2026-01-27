///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_master_driver.sv
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
// Description: Wishbone Master Driver component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_MASTER_DRIVER_SV
`define WISHBONE_MASTER_DRIVER_SV

`define dvif m_vif.drv_cb

class wishbone_master_driver extends uvm_driver #(wishbone_seq_item);
  `uvm_component_utils(wishbone_master_driver)

  virtual wishbone_master_interface m_vif;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "wishbone_master_driver", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "wishbone_master_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wishbone_master_interface)::get(this, "", "m_vif", m_vif))
      `uvm_fatal("NO vif", "Virtual interface not set for wishbone_master_driver")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : task for driver logic
  ////////////////////////////////////////////////////////////////////////
  virtual task run_phase(uvm_phase phase);
    wait_for_reset_assert();
    forever begin
      @(`dvif iff(!m_vif.rst));
      fork
        forever begin
          seq_item_port.get_next_item(req);
          drive_item(req);
          `uvm_info(get_full_name(),$sformatf("seq item : %s",req.sprint()),UVM_HIGH)
          seq_item_port.item_done();
        end
        wait_for_reset_assert();
      join_any
      disable fork;
    end
  endtask

  ////////////////////////////////////////////////////////////////////////
  // function name : drive_item
  // argument : wishbone_seq_item
  // description : Run phase for driving signals
  ////////////////////////////////////////////////////////////////////////
  virtual task drive_item(wishbone_seq_item item);
    
    // Set Address and Control
    `dvif.adr <= item.addr;
    `dvif.we  <= item.we;
    `dvif.cyc <= 1'b1; // Start of cycle
    `dvif.stb <= 1'b1; // Assert strobe
    `dvif.sel <= 4'hF;

    if (item.we) begin
      `dvif.dat_w <= item.data; // Driving write data
      `uvm_info("WB_DRV", $sformatf("Writing ADDR=%h DATA=%h", item.addr, item.data), UVM_HIGH)
    end else begin
      `dvif.dat_w <= 32'hz;    // Floating data bus for reads
    end

    // --- Wait for Acknowledge (Handshake) ---
    // The protocol requires waiting for ack_i from the slave
    fork
      begin
        do begin
          @(`dvif);
        end while (!`dvif.ack && !`dvif.err); // and because if one is false then condition is true
      end
      begin
        #100;
        `uvm_error(get_full_name,"not recieving ack");
      end
    join_any
    disable fork;
    
    // If it's a READ, capture the data from the bus at the moment of ACK
    if (!item.we) begin
      item.data = `dvif.dat_r;
      `uvm_info("WB_DRV", $sformatf("Read ADDR=%h DATA=%h", item.addr, item.data), UVM_HIGH)
    end

    // End the cycle (Return to Idle)
    `dvif.stb <= 1'b0;
    `dvif.cyc <= 1'b0;
    `dvif.we  <= 1'b0;
    `dvif.sel <= 1'b0;
  endtask

  ////////////////////////////////////////////////////////////////////////
  // function name : wait_for_reset_assert
  // argument : 
  // description : waits for reset to be asserted
  ////////////////////////////////////////////////////////////////////////
  task wait_for_reset_assert();
    @(posedge m_vif.rst);
    `dvif.adr <= 32'h0;
    `dvif.dat_w <= 32'h0;
    `dvif.we  <= 1'b0;
    `dvif.stb <= 1'b0;
    `dvif.cyc <= 1'b0;
    `dvif.sel <= 1'b0;
  endtask
    
endclass

`endif

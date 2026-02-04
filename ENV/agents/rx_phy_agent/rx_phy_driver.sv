///////////////////////////////////////////////////////////////////////////////////
// Filename: rx_phy_driver.sv
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
// Description: Rx Phy Driver component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef RX_PHY_DRIVER_SV
`define RX_PHY_DRIVER_SV

class rx_phy_driver extends uvm_driver #(phy_seq_item);
  `uvm_component_utils(rx_phy_driver)
  phy_seq_item txn;
  virtual phy_rx_interface vif;
  byte temp_byte;
  
  byte ethernet_pkt[$];

  task ethernet_pkt_function(phy_seq_item txn);
    ethernet_pkt.delete();
    
    if(txn.preamble_received)begin
      for (int i = 0; i < 6; i++)
        ethernet_pkt.push_back(8'h55);   // Preamble
    end
    if(txn.sfd_received)begin
      ethernet_pkt.push_back(8'hd5);     // SFD
    end
    foreach (txn.dest_addr[i])
      ethernet_pkt.push_back({<<{txn.dest_addr[i]}}); //DA
    foreach (txn.src_addr[i])
      ethernet_pkt.push_back({<<{txn.src_addr[i]}}); //SA
    ethernet_pkt.push_back({<<{txn.length_type[7:0]}});
    ethernet_pkt.push_back({<<{txn.length_type[15:8]}});
    foreach (txn.payload[i])
      ethernet_pkt.push_back({<<{txn.payload[i]}}); //Payload
    foreach (txn.crc[i])
      ethernet_pkt.push_back({<<{txn.crc[i]}}); //CRC
  endtask
  
  ///////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "rx_phy_driver", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "rx_phy_driver", uvm_component parent = null);
    super.new(name, parent);
    txn = phy_seq_item::type_id::create("txn");
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual phy_rx_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for rx_phy_driver")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for driving signals
  ////////////////////////////////////////////////////////////////////////
 virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "RX PHY DRIVER run phase started", UVM_LOW)  
     wait_for_reset_assert();
    forever begin
      @(vif.drv_cb iff(!vif.rst_n));
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
        
  //////////////////////////////////////////////////////////////////////
  //function name : drive_item
  //argument : 
  //description : Logic for driving data
  //////////////////////////////////////////////////////////////////////
  virtual task drive_item(phy_seq_item txn);
    
     vif.drv_cb.rx_dv <= 1;
     vif.drv_cb.rx_er <= 0;
     vif.drv_cb.col   <= 0;
     vif.drv_cb.crs   <= 0; // IDLE
     ethernet_pkt_function(txn);
       for(int i=0; i< ethernet_pkt.size(); i++)begin
         temp_byte <= ethernet_pkt[i]; 
         vif.drv_cb.rxd <= temp_byte[3:0];
         @(vif.drv_cb);   // wait 1 RX clock
         vif.drv_cb.rxd <= temp_byte[7:4];
        @(vif.drv_cb);   // wait 1 RX clock
       end
     @(vif.drv_cb);
     vif.drv_cb.rx_dv <= 0;
     vif.drv_cb.rx_er <= 0;
     vif.drv_cb.col   <= 0;
     vif.drv_cb.crs   <= 0; // IDLE
     vif.drv_cb.rxd   <= 0;
     `uvm_info(get_type_name(), "RX PHY DRIVER EXECUTED", UVM_NONE)
  endtask

        
   task wait_for_reset_assert();
     @(posedge vif.rst_n);
     vif.drv_cb.rxd<=0;
     vif.drv_cb.rx_er<=0;
     vif.drv_cb.rx_dv<=0;
     vif.drv_cb.col<=0;
     vif.drv_cb.crs<=0;
  endtask 
    
endclass
   
`endif

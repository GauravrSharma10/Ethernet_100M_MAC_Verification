///////////////////////////////////////////////////////////////////////////////////
// Filename: tx_phy_monitor.sv
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
// Description: Tx Phy Monitor component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef TX_PHY_MONITOR_SV
`define TX_PHY_MONITOR_SV

class tx_phy_monitor extends uvm_monitor;
  `uvm_component_utils(tx_phy_monitor)

  virtual phy_tx_interface vif;
  uvm_analysis_port #(uvm_sequence_item) ap;
  phy_seq_item tr;
  
  bit enable_preamble = 1;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "tx_phy_monitor", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "tx_phy_monitor", uvm_component parent = null);
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
    if(!uvm_config_db#(virtual phy_tx_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for tx_phy_monitor")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for monitoring signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    byte txd_q[$];   // temp storage to collect frame bytes
    bit [7:0]assembled_byte ; // temp variable for byte alignment
    bit in_frame,nibble_phase;
    forever begin
      @(posedge vif.clk);

      // Detect start of frame
      if (vif.tx_en && !in_frame) begin
        in_frame   = 1;
        txd_q.delete();
      end

     // Collect nibbles while tx_en is high
      if (vif.tx_en && in_frame) begin
        if (!nibble_phase) begin
          // Lower nibble
          assembled_byte[3:0] = {<<{vif.txd}};
          nibble_phase = 1;
        end
        else begin
          // Upper nibble 
          assembled_byte[7:4] = {<<{vif.txd}};
          txd_q.push_back(assembled_byte);
          nibble_phase = 0;
        end
      end

      // Detect end of frame
      if (!vif.tx_en && in_frame) begin
        in_frame = 0;
        if(process_frame(txd_q))
          $display("reception complete");
        else
          $display("frame droped");// process frame will segragate all the fields of packet structure 
      end
    end
  endtask

  function bit process_frame(byte txd_q[$]);
    int idx;

    tr = phy_seq_item::type_id::create("tr");

    // Minimum check: preamble(8) + 64 bytes min packet size
    if (txd_q.size() < 72) begin
      `uvm_error(get_name(),"Frame too short, dropping")
      return 0;
    end// if(txd_q.size())


    // Check 7-byte preamble
    if(enable_preamble)begin
      for (int i = 0; i < 7; i++) begin
        if (txd_q[i] != 8'h55) begin
//           $display("[MON] Invalid preamble at byte %0d: %02x", i, txd_q[i]);
          foreach(txd_q[i])begin
            $display("%0d    %0h",i,txd_q[i]);
          end
          `uvm_error(get_name(),$sformatf("Invalid preamble at byte %0d: %02x",i,txd_q[i]))
//           return 0;
        end//if(txd_q[i] != 55)
      end// for loop
      tr.preamble_received = 1;
      
    // Check SFD
      if (txd_q[7] != 8'hd5) begin
//       $display("[MON] Invalid SFD: %02x", txd_q[7]);
//           $display("%p",txd_q);
      foreach(txd_q[i])begin
        $display("%0d    %0h",i,txd_q[i]);
      end
       `uvm_error(get_name(),$sformatf("Invalid SFD: %02x", txd_q[7]))
      return 0;
    end//if(txd_q[7] != 57)
      
     tr.sfd_received = 1;
    end// if(enable_preamble)

    idx = 8; // move past SFD

    // ------------------------------------------------
    // Destination Address (6 bytes)
    // ------------------------------------------------
    for (int i = 0; i < 6; i++)
      tr.dest_addr[i] = txd_q[idx++];

    // ------------------------------------------------
    // Source Address (6 bytes)
    // ------------------------------------------------
    for (int i = 0; i < 6; i++)
        tr.src_addr[i] = txd_q[idx++];


    // ------------------------------------------------
    // Payload (exclude last 4 bytes = CRC)
    // ------------------------------------------------
    for (int i = idx; i < txd_q.size() - 4; i++)
      tr.payload.push_back(txd_q[i]);

    // ------------------------------------------------
    // CRC / FCS (last 4 bytes of frame)
    // ------------------------------------------------
    for (int i = 0; i < 4; i++)
      tr.crc[i] = txd_q[txd_q.size() - 4 + i];
    
    // ------------------------------------------------
    // write
    // ------------------------------------------------
//       analysis_port.write(tr);
  endfunction

endclass

`endif


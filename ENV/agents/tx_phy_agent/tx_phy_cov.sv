///////////////////////////////////////////////////////////////////////////////////
// Filename: tx_phy_cov.sv
//
// Author: Tanmaya Rout
// Date: 12/12/2025
// Revision: 1
//
// Company: Scaledge Technology Pvt.
//
// Copyright (c) 2025 Scaledge Technology Pvt. All rights reserved.
//
// This file is part of the Ethernet_MAC_VIP project.
//
// Description: Coverage collector component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETH_PHY_COV_SV
`define ETH_PHY_COV_SV

class eth_tx_phy_cov extends uvm_subscriber #(phy_seq_item);

  `uvm_component_utils(eth_tx_phy_cov)

  phy_seq_item tx;

  //------------------------------------------------------
  // Covergroup
  //------------------------------------------------------
  covergroup phy_cg;
    option.per_instance = 1;

    //------------------------------------------------------
    // Preamble detection
    //------------------------------------------------------
    cp_preamble : coverpoint tx.preamble_received {
      bins detected     = {1};
      bins not_detected = {0};
    }

    //------------------------------------------------------
    // SFD detection
    //------------------------------------------------------
    cp_sfd : coverpoint tx.sfd_received {
      bins detected     = {1};
      bins not_detected = {0};
    }

    //------------------------------------------------------
    // Destination address type
    //------------------------------------------------------
    cp_da_type : coverpoint tx.dest_addr[0] {
      bins unicast   = {0};
      bins multicast = {1};
    }

    //------------------------------------------------------
    // Payload size coverage
    //------------------------------------------------------
    cp_payload_size : coverpoint tx.payload.size() {
      bins min_frame 	 = {[46:46]};
      bins small_pld     = {[47:127]};
      bins medium_pld    = {[128:511]};
      bins large_pld     = {[512:1499]};
      bins max_frame	 = {[1500:1500]};
    }

    //------------------------------------------------------
    // Length/Type field coverage
    //------------------------------------------------------
    cp_length_type : coverpoint tx.length_type {
      bins length_mode = {[1:1500]};
      bins type_mode   = {[16'h0600:16'hFFFF]};
    }

    //------------------------------------------------------
    // CRC coverage
    //------------------------------------------------------
    cp_crc_present : coverpoint tx.crc.size() {
      bins valid_crc = {4};
    }

    //------------------------------------------------------
    // Cross coverage
    //------------------------------------------------------
    cross_frame_validity :
    cross cp_preamble, cp_sfd, cp_payload_size;

  endgroup

 

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_cov_collector", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "eth_phy_cov", uvm_component parent = null);
    super.new(name, parent);
    phy_cg = new();
  endfunction

/*
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    $display("\n================ ETH PHY COVERAGE REPORT ================");
    $display(" TOTAL COVERAGE               = %0.2f%%", phy_cg.get_coverage());
    $display("---------------------------------------------------------");
    $display(" COVERPOINTS:");
    $display("  PREAMBLE DETECTION          = %0.2f%%", phy_cg.cp_preamble.get_coverage());
    $display("  SFD DETECTION               = %0.2f%%", phy_cg.cp_sfd.get_coverage());
    $display("  DESTINATION ADDR TYPE       = %0.2f%%", phy_cg.cp_da_type.get_coverage());
    $display("  PAYLOAD SIZE                = %0.2f%%", phy_cg.cp_payload_size.get_coverage());
    $display("  LENGTH/TYPE FIELD           = %0.2f%%", phy_cg.cp_length_type.get_coverage());
    $display("  CRC PRESENCE                = %0.2f%%", phy_cg.cp_crc_present.get_coverage());
    $display("=========================================================\n");
  endfunction

*/
  
  ////////////////////////////////////////////////////////////////////////
  // function name : write
  // argument : phy_seq_item t
  // description : Subscriber write function
  ////////////////////////////////////////////////////////////////////////
  function void write(phy_seq_item t);
    // Coverage logic

    if (t == null) 
      begin
        `uvm_warning(get_type_name(), "Received null phy_seq_item")
        return;
      end

    tx = t;
    phy_cg.sample();
  endfunction

endclass

`endif


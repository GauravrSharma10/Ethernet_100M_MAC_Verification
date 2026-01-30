///////////////////////////////////////////////////////////////////////////////////
// Filename: top.sv
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
// Description: Top level testbench module.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////
`include "ethernet_mac_test_pkg.sv"
`include "uvm_macros.svh"
module top;
  import uvm_pkg::*;
  import ethernet_mac_test_pkg::*;

  logic clk;
  logic rst;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst = 0;
    #40 rst = 1;
    #20 rst = 0;
    
  end

  // Interface Instantiation
  mac_interface intf(clk, rst);
  
  ethmac dut (
    // --------------------------------------------------
    // Wishbone common
    // --------------------------------------------------
    .wb_clk_i (clk),
    .wb_rst_i (rst),

    .wb_dat_i (intf.wb_master_if.dat_w),
    .wb_dat_o (intf.wb_master_if.dat_r),

    // --------------------------------------------------
    // Wishbone SLAVE (CPU → MAC)
    // --------------------------------------------------
    .wb_adr_i (intf.wb_master_if.adr),
    .wb_sel_i (intf.wb_master_if.sel),
    .wb_we_i  (intf.wb_master_if.we),
    .wb_cyc_i (intf.wb_master_if.cyc),
    .wb_stb_i (intf.wb_master_if.stb),
    .wb_ack_o (intf.wb_master_if.ack),
    .wb_err_o (intf.wb_master_if.err),

    // --------------------------------------------------
    // Wishbone MASTER (MAC → Memory)
    // --------------------------------------------------
    .m_wb_adr_o (intf.wb_slave_if.adr),
    .m_wb_sel_o (intf.wb_slave_if.sel),
    .m_wb_we_o  (intf.wb_slave_if.we),
    .m_wb_dat_o (intf.wb_slave_if.dat_w),
    .m_wb_dat_i (intf.wb_slave_if.dat_r),
    .m_wb_cyc_o (intf.wb_slave_if.cyc),
    .m_wb_stb_o (intf.wb_slave_if.stb),
    .m_wb_ack_i (intf.wb_slave_if.ack),
    .m_wb_err_i (intf.wb_slave_if.err),

    // (Optional – if used)
    .m_wb_cti_o (),
    .m_wb_bte_o (),

    // --------------------------------------------------
    // PHY TX
    // --------------------------------------------------
    .mtx_clk_pad_i (clk),
    .mtxd_pad_o    (intf.phy_tx_if.txd),
    .mtxen_pad_o   (intf.phy_tx_if.tx_en),
    .mtxerr_pad_o  (intf.phy_tx_if.tx_er),
    .mcoll_pad_i   (intf.phy_tx_if.col),
    .mcrs_pad_i    (intf.phy_tx_if.crs),

    // --------------------------------------------------
    // PHY RX 
    // --------------------------------------------------
    .mrx_clk_pad_i (clk),
    .mrxd_pad_i    (intf.phy_rx_if.rxd),
    .mrxdv_pad_i   (intf.phy_rx_if.rx_dv),
    .mrxerr_pad_i  (intf.phy_rx_if.rx_er),

    // --------------------------------------------------
    // MIIM
    // --------------------------------------------------
    .mdc_pad_o   (intf.miim_if.mdc),
    .md_pad_i    (intf.miim_if.mdi),
    .md_pad_o    (intf.miim_if.mdo),
    .md_padoe_o  (intf.miim_if.mdoe),

    // --------------------------------------------------
    // Interrupt
    // --------------------------------------------------
    .int_o ()
  );

  initial begin
    $dumpfile(".vcd");
    $dumpvars();
  end

  initial begin
    $fsdbDumpfile("test_top");
    $fsdbDumpvars;
	end
  
  initial begin
 //   uvm_top.finish_on_completion = 0  ;
    // Pass interfaces to config_db
    uvm_config_db#(virtual wishbone_master_interface)::set(null, "*.wb_mst_agent_h.*", "m_vif", intf.wb_master_if);
    uvm_config_db#(virtual wishbone_slave_interface)::set(null, "*.wb_slv_agent_h.*", "s_vif", intf.wb_slave_if);
    uvm_config_db#(virtual phy_tx_interface)::set(null, "*.tx_phy_agent_h.*", "vif", intf.phy_tx_if);
    uvm_config_db#(virtual phy_rx_interface)::set(null, "*.rx_phy_agent_h.*", "vif", intf.phy_rx_if);
    uvm_config_db#(virtual miim_interface)::set(null, "*.miim_agent_h.*", "vif", intf.miim_if);

   //  run_test("ethernet_mac_base_test");
   run_test("reg_test");

    
   $finish;
  end

endmodule

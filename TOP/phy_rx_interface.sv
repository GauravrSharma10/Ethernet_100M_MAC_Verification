///////////////////////////////////////////////////////////////////////////////////
// Filename: phy_rx_interface.sv
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
// Description: PHY Rx Interface.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef PHY_RX_INTERFACE_SV
`define PHY_RX_INTERFACE_SV

interface phy_rx_interface(input logic clk, input logic rst_n);
  logic [3:0] rxd;
  logic       rx_dv;
  logic       rx_er;
  logic       col;
  logic       crs;
  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output rxd, rx_dv, rx_er,col,crs;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input rxd, rx_dv, rx_er;
  endclocking

  modport driver (clocking drv_cb, input clk, rst_n);
  modport monitor (clocking mon_cb, input clk, rst_n);

endinterface

`endif


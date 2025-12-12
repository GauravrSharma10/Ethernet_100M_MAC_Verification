///////////////////////////////////////////////////////////////////////////////////
// Filename: phy_tx_interface.sv
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
// Description: PHY Tx Interface.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef PHY_TX_INTERFACE_SV
`define PHY_TX_INTERFACE_SV

interface phy_tx_interface(input logic clk, input logic rst_n);
  logic [3:0] txd;
  logic       tx_en;
  logic       tx_er;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output txd, tx_en, tx_er;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input txd, tx_en, tx_er;
  endclocking

  modport driver (clocking drv_cb, input clk, rst_n);
  modport monitor (clocking mon_cb, input clk, rst_n);

endinterface

`endif


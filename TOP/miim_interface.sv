///////////////////////////////////////////////////////////////////////////////////
// Filename: miim_interface.sv
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
// Description: MIIM Interface.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef MIIM_INTERFACE_SV
`define MIIM_INTERFACE_SV

interface miim_interface(input logic clk, input logic rst_n);
  logic       mdc;
  logic       mdo;
  logic       mdi;
  logic       mdoe;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output mdc, mdo, mdoe;
    input  mdi;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input mdc, mdo, mdi, mdoe;
  endclocking

  modport driver (clocking drv_cb, input clk, rst_n);
  modport monitor (clocking mon_cb, input clk, rst_n);

endinterface

`endif


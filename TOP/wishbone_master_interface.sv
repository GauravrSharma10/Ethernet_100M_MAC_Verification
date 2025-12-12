///////////////////////////////////////////////////////////////////////////////////
// Filename: wishbone_master_interface.sv
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
// Description: Wishbone Master Interface.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef WISHBONE_MASTER_INTERFACE_SV
`define WISHBONE_MASTER_INTERFACE_SV

interface wishbone_master_interface(input logic clk, input logic rst_n);
  logic [31:0] adr;
  logic [31:0] dat_w;
  logic [31:0] dat_r;
  logic        we;
  logic        sel;
  logic        stb;
  logic        cyc;
  logic        ack;
  logic        err;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output adr, dat_w, we, sel, stb, cyc;
    input  dat_r, ack, err;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1 output #1;
    input adr, dat_w, dat_r, we, sel, stb, cyc, ack, err;
  endclocking

  modport driver (clocking drv_cb, input clk, rst_n);
  modport monitor (clocking mon_cb, input clk, rst_n);

endinterface

`endif


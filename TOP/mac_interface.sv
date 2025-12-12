///////////////////////////////////////////////////////////////////////////////////
// Filename: mac_interface.sv
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
// Description: MAC Top Interface.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef MAC_INTERFACE_SV
`define MAC_INTERFACE_SV

interface mac_interface(input logic clk, input logic rst_n);

  // Sub-interfaces
  wishbone_master_interface wb_master_if(clk, rst_n);
  wishbone_slave_interface  wb_slave_if(clk, rst_n);
  phy_tx_interface          phy_tx_if(clk, rst_n);
  phy_rx_interface          phy_rx_if(clk, rst_n);
  miim_interface            miim_if(clk, rst_n);

endinterface

`endif


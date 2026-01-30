///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_env.sv
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
// Description: Top-level environment component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_ENV_SV
`define ETHERNET_MAC_ENV_SV
//   `include "ral_pkg.sv"

class ethernet_mac_env extends uvm_env;
  `uvm_component_utils(ethernet_mac_env)

  wishbone_master_agent wb_mst_agent_h;
  wishbone_slave_agent  wb_slv_agent_h;
  tx_phy_agent          tx_phy_agent_h;
  rx_phy_agent          rx_phy_agent_h;
  miim_agent            miim_agent_h;
  eth_reg_block         reg_blk_h;
  reg_wishbone_adapter  adptr_h;

  ethernet_mac_scoreboard        sb_h;
  ethernet_mac_cov_collector     cov_h;
  ethernet_mac_checker           chk_h;
  ethernet_mac_virtual_sequencer v_seqr_h;
  system_config     sys_cfg_h;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_env", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to create components
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create Agents
    wb_mst_agent_h = wishbone_master_agent::type_id::create("wb_mst_agent_h", this);
    wb_slv_agent_h = wishbone_slave_agent::type_id::create("wb_slv_agent_h", this);
    tx_phy_agent_h = tx_phy_agent::type_id::create("tx_phy_agent_h", this);
    rx_phy_agent_h = rx_phy_agent::type_id::create("rx_phy_agent_h", this);
    miim_agent_h   = miim_agent::type_id::create("miim_agent_h", this);

    // Create Analysis Components
    sb_h  = ethernet_mac_scoreboard::type_id::create("sb_h", this);
    cov_h = ethernet_mac_cov_collector::type_id::create("cov_h", this);
    chk_h = ethernet_mac_checker::type_id::create("chk_h", this);
    
    // Create Virtual Sequencer
    v_seqr_h = ethernet_mac_virtual_sequencer::type_id::create("v_seqr_h", this);

    //create reg block 
    reg_blk_h = eth_reg_block::type_id::create("reg_blk_h");
    adptr_h = reg_wishbone_adapter::type_id::create("adptr_h");
    
    reg_blk_h.build();
    reg_blk_h.reset();
    reg_blk_h.lock_model();
    reg_blk_h.print();
    
    uvm_config_db#(eth_reg_block)::set(null,"*","reg_model",reg_blk_h);
    
    // Get System Config
    if(!uvm_config_db#(system_config)::get(this, "", "sys_cfg", sys_cfg_h)) begin
       `uvm_info(get_name(), "System config not found, creating default", UVM_LOW)
       sys_cfg_h = system_config::type_id::create("sys_cfg_h");
    end

    wb_slv_agent_h.reg_blk_h = this.reg_blk_h;
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : connect_phase
  // argument : uvm_phase phase
  // description : Connect phase to connect components
  ////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect Virtual Sequencer
    v_seqr_h.wb_mst_seqr_h = wb_mst_agent_h.sequencer;
    v_seqr_h.wb_slv_seqr_h = wb_slv_agent_h.sequencer;
    v_seqr_h.tx_phy_seqr_h = tx_phy_agent_h.sequencer;
    v_seqr_h.rx_phy_seqr_h = rx_phy_agent_h.sequencer;
    v_seqr_h.miim_seqr_h   = miim_agent_h.sequencer;

    // Connect Analysis Ports (Example connections)
//     wb_mst_agent_h.monitor.ap.connect(sb_h.item_imp);
//     wb_mst_agent_h.monitor.ap.connect(cov_h.analysis_export);
    
    // Connect other agents similarly....
    
    reg_blk_h.wb_map.set_sequencer(.sequencer(wb_mst_agent_h.sequencer),.adapter(adptr_h));
    
    reg_blk_h.wb_map.set_base_addr('h0);
    reg_blk_h.wb_map.set_auto_predict(1);

  endfunction

endclass

`endif


///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_base_test.sv
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
// Description: Base test component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_BASE_TEST_SV
`define ETHERNET_MAC_BASE_TEST_SV

class ethernet_mac_base_test extends uvm_test;
  `uvm_component_utils(ethernet_mac_base_test)

  ethernet_mac_env env_h;
	system_config cfg_h;

// wb_master_sequence wb_master_seq;
 // wb_slave_sequence wb_slave_seq;
  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_base_test", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to create environment
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = ethernet_mac_env::type_id::create("env_h", this);
		cfg_h = system_config::type_id::create("cfg_h");
		uvm_config_db#(system_config)::set(this,"env_h","sys_cfg",cfg_h);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : end_of_elaboration_phase
  // argument : uvm_phase phase
  // description : End of elaboration phase to print topology
  ////////////////////////////////////////////////////////////////////////
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    /*`uvm_info("Inside run_phase","Base test run_phase",UVM_LOW)
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting Ethernet Mac Base Test", UVM_LOW)
     wb_master_seq =   wb_master_sequence::type_id::create("wb_master_seq");
     wb_slave_seq = wb_slave_sequence::type_id::create("wb_slave_seq");

   fork
    
      wb_master_seq.start(env_h.wb_mst_agent_h.sequencer);
     wb_slave_seq.start(env_h.wb_slv_agent_h.sequencer);
   join_none
   
    phase.phase_done.set_drain_time(this, 6000);
    phase.drop_objection(this);  
*/
  endtask

endclass

`endif


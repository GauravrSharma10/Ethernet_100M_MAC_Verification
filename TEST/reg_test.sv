class reg_test extends ethernet_mac_base_test;
  `uvm_component_utils(reg_test)
  
  reg_seq seq;
  wb_slave_sequence wb_slave_seq;
  rx_phy_sequence rpseq;
  function new(string name = "reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    seq = reg_seq::type_id::create("seq");
    $display("starting the reg sequence");
    wb_slave_seq = wb_slave_sequence::type_id::create("wb_slave_seq");
    rpseq = rx_phy_sequence::type_id::create("rpseq");
    phase.raise_objection(this);
     fork
    seq.start(env_h.v_seqr_h.wb_mst_seqr_h);
    wb_slave_seq.start(env_h.wb_slv_agent_h.sequencer);
    //rpseq.start(env_h.rx_phy_agent_h.sequencer);
        join_none
    phase.phase_done.set_drain_time(this, 6000);
    phase.drop_objection(this);

  endtask
endclass

`ifndef TX_PHY_BASE_SEQUENCE_SV
`define TX_PHY_BASE_SEQUENCE_SV

class tx_phy_base_sequence extends uvm_sequence;

	`uvm_object_utils(tx_phy_base_sequence)
	`uvm_declare_p_sequencer(tx_phy_sequencer)

	function new(string name="tx_phy_base_sequence");
	  super.new(name);
  endfunction

  virtual task body();
    p_sequencer.vif.col = 1'b0;
    p_sequencer.vif.crs = 1'b0;
	  //@(posedge p_sequencer.vif.tx_en);
		 
		`uvm_info(get_name(),"started the phy transaction",UVM_NONE)

	   /*repeat(200)
		 @(posedge p_sequencer.vif.clk);
		 p_sequencer.vif.crs <= 1;
*/

		//@(negedge p_sequencer.vif.tx_en);
		`uvm_info(get_name(),"finished the phy transaction",UVM_NONE)

  endtask

endclass

`endif

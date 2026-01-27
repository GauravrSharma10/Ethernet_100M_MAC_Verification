
`ifndef RX_PHY_SEQUENCE_SV
`define RX_PHY_SEQUENCE_SV

class rx_phy_sequence extends uvm_sequence#(phy_seq_item);

 /** UVM Object Utility macro */
 `uvm_object_utils(rx_phy_sequence)
  
 /** Class Constructor */
  function new(string name="rx_phy_sequence");
    super.new(name);
  endfunction
  
 
  
  virtual task body();
    `uvm_info("body", "Entered ...", UVM_LOW)
//     repeat(20)begin
    `uvm_do_with(req, {req.preamble_received==1;
                  req.sfd_received==1;
                  })
    `uvm_info(get_type_name(),"PRINTING TRANSACTIONS FROM RX PHY SEQUENCE",UVM_NONE)
    req.print();
  //  end
    `uvm_info("body", "Exiting...", UVM_LOW)
    
  endtask: body
  
 
  

endclass// RX_PHY_SEQUENCE_SV
`endif

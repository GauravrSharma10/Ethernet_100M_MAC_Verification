 class eth_ctrlmoder_reg extends uvm_reg;
    `uvm_object_utils(eth_ctrlmoder_reg)

    uvm_reg_field passall;
    uvm_reg_field rxflow;
    uvm_reg_field txflow;

    function new(string name="eth_ctrlmoder_reg");
      super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
      passall = uvm_reg_field::type_id::create("passall");
      passall.configure(this,1,0,"RW",0,1'b0,1,0,0);
      rxflow = uvm_reg_field::type_id::create("rxflow");
      rxflow.configure(this,1,1,"RW",0,1'b0,1,0,0);
      txflow = uvm_reg_field::type_id::create("txflow");
      txflow.configure(this,1,2,"RW",0,1'b0,1,0,0);
    endfunction
  endclass

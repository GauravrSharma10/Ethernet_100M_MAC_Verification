class eth_int_source_reg extends uvm_reg;
  `uvm_object_utils(eth_int_source_reg)

  uvm_reg_field txb, txe, rxb, rxe, busy, txc, rxc;

  function new(string name="eth_int_source_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    txb  = uvm_reg_field::type_id::create("txb");  txb.configure(this,1,0,"W1C",0,0,1,0,0);
    txe  = uvm_reg_field::type_id::create("txe");  txe.configure(this,1,1,"W1C",0,0,1,0,0);
    rxb  = uvm_reg_field::type_id::create("rxb");  rxb.configure(this,1,2,"W1C",0,0,1,0,0);
    rxe  = uvm_reg_field::type_id::create("rxe");  rxe.configure(this,1,3,"W1C",0,0,1,0,0);
    busy = uvm_reg_field::type_id::create("busy"); busy.configure(this,1,4,"W1C",0,0,1,0,0);
    txc  = uvm_reg_field::type_id::create("txc");  txc.configure(this,1,5,"W1C",0,0,1,0,0);
    rxc  = uvm_reg_field::type_id::create("rxc");  rxc.configure(this,1,6,"W1C",0,0,1,0,0);
  endfunction
endclass


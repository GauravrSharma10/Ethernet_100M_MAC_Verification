class eth_int_mask_reg extends uvm_reg;
  `uvm_object_utils(eth_int_mask_reg)
  uvm_reg_field txb_m, txe_m, rxb_m, rxe_m, busy_m, txc_m, rxc_m;

  function new(string name="eth_int_mask_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    txb_m  = uvm_reg_field::type_id::create("txb_m");  txb_m.configure(this,1,0,"RW",0,0,1,0,0);
    txe_m  = uvm_reg_field::type_id::create("txe_m");  txe_m.configure(this,1,1,"RW",0,0,1,0,0);
    rxb_m  = uvm_reg_field::type_id::create("rxb_m");  rxb_m.configure(this,1,2,"RW",0,0,1,0,0);
    rxe_m  = uvm_reg_field::type_id::create("rxe_m");  rxe_m.configure(this,1,3,"RW",0,0,1,0,0);
    busy_m = uvm_reg_field::type_id::create("busy_m"); busy_m.configure(this,1,4,"RW",0,0,1,0,0);
    txc_m  = uvm_reg_field::type_id::create("txc_m");  txc_m.configure(this,1,5,"RW",0,0,1,0,0);
    rxc_m  = uvm_reg_field::type_id::create("rxc_m");  rxc_m.configure(this,1,6,"RW",0,0,1,0,0);
  endfunction
endclass

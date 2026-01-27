class eth_hash0_reg extends uvm_reg;
  `uvm_object_utils(eth_hash0_reg)
  uvm_reg_field hash0;
  function new(string n="eth_hash0_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    hash0 = uvm_reg_field::type_id::create("hash0");
    hash0.configure(this,32,0,"RW",0,0,1,0,0);
  endfunction
endclass

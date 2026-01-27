class eth_hash1_reg extends uvm_reg;
  `uvm_object_utils(eth_hash1_reg)
  uvm_reg_field hash1;
  function new(string n="eth_hash1_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    hash1 = uvm_reg_field::type_id::create("hash1");
    hash1.configure(this,32,0,"RW",0,0,1,0,0);
  endfunction
endclass

class eth_ipgr1_reg extends uvm_reg;
  `uvm_object_utils(eth_ipgr1_reg)
  uvm_reg_field ipgr1;
  function new(string n="eth_ipgr1_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    ipgr1 = uvm_reg_field::type_id::create("ipgr1");
    ipgr1.configure(this,7,0,"RW",0,7'h0C,1,0,0);
  endfunction
endclass

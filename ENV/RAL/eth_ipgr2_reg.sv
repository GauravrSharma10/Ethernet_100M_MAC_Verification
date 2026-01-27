class eth_ipgr2_reg extends uvm_reg;
  `uvm_object_utils(eth_ipgr2_reg)
  uvm_reg_field ipgr2;
  function new(string n="eth_ipgr2_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    ipgr2 = uvm_reg_field::type_id::create("ipgr2");
    ipgr2.configure(this,7,0,"RW",0,7'h12,1,0,0);
  endfunction
endclass

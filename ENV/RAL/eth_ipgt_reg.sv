class eth_ipgt_reg extends uvm_reg;
  `uvm_object_utils(eth_ipgt_reg)
  uvm_reg_field ipgt;
  function new(string n="eth_ipgt_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    ipgt = uvm_reg_field::type_id::create("ipgt");
    ipgt.configure(this,7,0,"RW",0,7'h12,1,0,0);
  endfunction
endclass

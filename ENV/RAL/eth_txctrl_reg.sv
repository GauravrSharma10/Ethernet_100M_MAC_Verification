class eth_txctrl_reg extends uvm_reg;
  `uvm_object_utils(eth_txctrl_reg)
  uvm_reg_field txpauserq;
  function new(string n="eth_txctrl_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    txpauserq = uvm_reg_field::type_id::create("txpauserq");
    txpauserq.configure(this,1,0,"RW",0,0,1,0,0);
  endfunction
endclass

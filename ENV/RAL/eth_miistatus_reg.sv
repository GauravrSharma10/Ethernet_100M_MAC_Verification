class eth_miistatus_reg extends uvm_reg;
  `uvm_object_utils(eth_miistatus_reg)
  uvm_reg_field busy, nvalid;
  function new(string n="eth_miistatus_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    busy   = uvm_reg_field::type_id::create("busy");
    busy.configure(this,1,0,"RO",0,0,1,0,0);
    nvalid = uvm_reg_field::type_id::create("nvalid");
    nvalid.configure(this,1,1,"RO",0,0,1,0,0);
  endfunction
endclass

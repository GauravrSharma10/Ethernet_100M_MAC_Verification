class eth_miicommand_reg extends uvm_reg;
  `uvm_object_utils(eth_miicommand_reg)
  uvm_reg_field scan, read, write;
  function new(string n="eth_miicommand_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    scan  = uvm_reg_field::type_id::create("scan");  scan.configure(this,1,0,"RW",0,0,1,0,0);
    read  = uvm_reg_field::type_id::create("read");  read.configure(this,1,1,"RW",0,0,1,0,0);
    write = uvm_reg_field::type_id::create("write"); write.configure(this,1,2,"RW",0,0,1,0,0);
  endfunction
endclass

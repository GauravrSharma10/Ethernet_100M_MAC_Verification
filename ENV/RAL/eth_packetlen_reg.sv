class eth_packetlen_reg extends uvm_reg;
  `uvm_object_utils(eth_packetlen_reg)
  uvm_reg_field minfl, maxfl;
  function new(string n="eth_packetlen_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    minfl = uvm_reg_field::type_id::create("minfl");
    minfl.configure(this,16,0,"RW",0,16'd64,1,0,0);
    maxfl = uvm_reg_field::type_id::create("maxfl");
    maxfl.configure(this,16,16,"RW",0,16'd1518,1,0,0);
  endfunction
endclass

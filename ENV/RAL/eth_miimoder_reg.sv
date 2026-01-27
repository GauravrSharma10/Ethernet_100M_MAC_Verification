class eth_miimoder_reg extends uvm_reg;
  `uvm_object_utils(eth_miimoder_reg)
  uvm_reg_field clkdiv, nopre;
  function new(string n="eth_miimoder_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    clkdiv = uvm_reg_field::type_id::create("clkdiv");
    clkdiv.configure(this,8,0,"RW",0,8'd64,1,0,0);
    nopre = uvm_reg_field::type_id::create("nopre");
    nopre.configure(this,1,8,"RW",0,0,1,0,0);
  endfunction
endclass

class eth_collconf_reg extends uvm_reg;
  `uvm_object_utils(eth_collconf_reg)
  uvm_reg_field collvalid, maxret;
  function new(string n="eth_collconf_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    collvalid = uvm_reg_field::type_id::create("collvalid");
    collvalid.configure(this,6,0,"RW",0,6'd63,1,0,0);
    maxret = uvm_reg_field::type_id::create("maxret");
    maxret.configure(this,4,16,"RW",0,4'd15,1,0,0);
  endfunction
endclass

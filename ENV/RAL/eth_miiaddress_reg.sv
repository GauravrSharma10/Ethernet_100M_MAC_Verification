class eth_miiaddress_reg extends uvm_reg;
  `uvm_object_utils(eth_miiaddress_reg)
  uvm_reg_field fiad, rgad;
  function new(string n="eth_miiaddress_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    rgad = uvm_reg_field::type_id::create("rgad");
    rgad.configure(this,5,0,"RW",0,0,1,0,0);
    fiad = uvm_reg_field::type_id::create("fiad");
    fiad.configure(this,5,8,"RW",0,0,1,0,0);
  endfunction
endclass

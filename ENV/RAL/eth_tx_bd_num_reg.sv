class eth_tx_bd_num_reg extends uvm_reg;
  `uvm_object_utils(eth_tx_bd_num_reg)
  uvm_reg_field tx_bd_num;
  function new(string n="eth_tx_bd_num_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    tx_bd_num = uvm_reg_field::type_id::create("tx_bd_num");
    tx_bd_num.configure(this,8,0,"RW",0,8'd64,1,0,0);
  endfunction
endclass

class eth_miitx_data_reg extends uvm_reg;
  `uvm_object_utils(eth_miitx_data_reg)
  uvm_reg_field tx_data;
  function new(string n="eth_miitx_data_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    tx_data = uvm_reg_field::type_id::create("tx_data");
    tx_data.configure(this,16,0,"RW",0,0,1,0,0);
  endfunction
endclass

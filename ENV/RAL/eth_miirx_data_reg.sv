class eth_miirx_data_reg extends uvm_reg;
  `uvm_object_utils(eth_miirx_data_reg)
  uvm_reg_field rx_data;
  function new(string n="eth_miirx_data_reg"); super.new(n,32,UVM_NO_COVERAGE); endfunction
  function void build();
    rx_data = uvm_reg_field::type_id::create("rx_data");
    rx_data.configure(this,16,0,"RO",0,0,1,0,0);
  endfunction
endclass

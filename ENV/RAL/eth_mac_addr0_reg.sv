class eth_mac_addr0_reg extends uvm_reg;
  `uvm_object_utils(eth_mac_addr0_reg)
  uvm_reg_field macaddr0;

  function new(string name="eth_mac_addr0_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    macaddr0 = uvm_reg_field::type_id::create("macaddr0");
    macaddr0.configure(this, 1, 0, "RW", 0, 0, 1, 0, 0);
  endfunction
endclass

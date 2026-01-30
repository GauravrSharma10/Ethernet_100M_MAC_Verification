class reg_wishbone_adapter extends uvm_reg_adapter;
  `uvm_object_utils(reg_wishbone_adapter)

  function new(string name = "reg_wishbone_adapter");
    super.new(name);
  endfunction

  // 1. Convert RAL operation to Wishbone Sequence Item
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    wishbone_seq_item wb_item = wishbone_seq_item::type_id::create("wb_item");

    wb_item.addr = rw.addr;
    wb_item.we   = (rw.kind == UVM_WRITE);
    
    if (rw.kind == UVM_WRITE) begin
      wb_item.data_q.push_back(rw.data);
    end

     `uvm_info(get_type_name, $sformatf("reg2bus: addr = %0h, data = %0h,rd_or_wr = %0h", wb_item.addr, wb_item.data_q[0], wb_item.we), UVM_LOW);
    return wb_item;
  endfunction

  // 2. Convert Wishbone Sequence Item back to RAL operation
  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    wishbone_seq_item wb_item;

    if (!$cast(wb_item, bus_item)) begin
      `uvm_fatal("ADAPT_CAST_ERR", "Provided bus_item is not of type wishbone_seq_item")
      return;
    end

    rw.kind = (wb_item.we) ? UVM_WRITE : UVM_READ;
    rw.addr = wb_item.addr;
    rw.data = wb_item.data_q.pop_front();
    `uvm_info(get_type_name, $sformatf("bus2reg: addr = %0h, data = %0h, rd_or_wr = %0p", rw.addr, rw.data, rw.kind), UVM_LOW);
  endfunction

endclass

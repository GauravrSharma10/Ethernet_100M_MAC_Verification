`ifndef WB_SLAVE_SEQUENCE_SV
`define WB_SLAVE_SEQUENCE_SV

class wb_slave_sequence extends uvm_sequence #(wishbone_seq_item);

  `uvm_object_utils(wb_slave_sequence)
  `uvm_declare_p_sequencer(wishbone_slave_sequencer)

  wishbone_seq_item req;
  wishbone_seq_item rsp;

  function new(string name="wb_slave_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Reactive slave sequence started", UVM_LOW)

    forever begin
      // ------------------------------------------------------------
      // 1. Get request from slave monitor (via sequencer FIFO)
      // ------------------------------------------------------------
      p_sequencer.request_fifo.get(req);

      `uvm_info(get_type_name(),$sformatf("Received request: addr=0x%08x we=%0d data=0x%08x",req.addr, req.we, req.data),UVM_MEDIUM)

      // ------------------------------------------------------------
      // 2. Create response
      // ------------------------------------------------------------
      rsp = wishbone_seq_item::type_id::create("rsp");
      rsp.copy(req);

      // ------------------------------------------------------------
      // 4. READ / WRITE handling
      // ------------------------------------------------------------
      if (req.we) begin
        // ---------------- WRITE ----------------
//         `uvm_do_with(req, { req.data == $urandom; })   // for 8-bit
        p_sequencer.wb_storage.write_word(req.addr, req.data);

        `uvm_info(get_type_name(),$sformatf("WRITE: addr=0x%08x data=0x%08x",req.addr, req.data),UVM_MEDIUM)

      end else begin
        // ---------------- READ -----------------
        rsp.data = p_sequencer.wb_storage.read_word(req.addr);

        `uvm_info(get_type_name(),$sformatf("READ: addr=0x%08x data=0x%08x",req.addr, rsp.data),UVM_MEDIUM)
      end

      // ------------------------------------------------------------
      // 5. Send response to slave driver
      // ------------------------------------------------------------
      `uvm_send(rsp)
    end
  endtask

endclass

`endif

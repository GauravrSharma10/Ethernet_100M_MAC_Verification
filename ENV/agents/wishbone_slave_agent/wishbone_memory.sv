class wishbone_storage extends uvm_component;
  `uvm_component_utils(wishbone_storage)

  typedef bit [31:0] addr_t;
  typedef bit [31:0] word_t;

  // Sparse, unbounded word-addressable memory
  word_t mem_words [addr_t];

  function new (string name="wishbone_storage",uvm_component parent);
    super.new(name,parent);
  endfunction

  // Write a 32-bit word at a word address
  function void write_word(addr_t addr, word_t data);
    mem_words[addr] = data;
    `uvm_info(get_type_name(),$sformatf("addr = %0h data = %0h for write method",addr,data), UVM_NONE)
  endfunction

  // Read a 32-bit word at a word address (returns 0 if not written)
  //   function word_t read_word(addr_t addr);
  //     `uvm_info(get_type_name(),$sformatf("addr = %0h data = %0h for read method",addr,mem_words[addr]), UVM_NONE)
  //     return mem_words.exists(addr) ? mem_words[addr] : '0;
  //   endfunction

  function word_t read_word(addr_t addr);
    word_t data;

    if (!mem_words.exists(addr)) begin
      data = $urandom;
      mem_words[addr] = data;

      `uvm_info(get_type_name(),$sformatf("READ-ALLOCATE: addr = %0h initialized with %0h",addr, data),UVM_LOW)
    end
    else begin
      data = mem_words[addr];

      `uvm_info(get_type_name(),$sformatf("READ: addr = %0h data = %0h",addr, data),UVM_LOW)
    end

    return data;
  endfunction


endclass

class eth_rx_bd_reg extends uvm_reg;
  rand uvm_reg_field LEN, E, IRQ, WRAP, CF, M, OR, IS, DN, TL, SF, CRC, LC, RXPNT;

  `uvm_object_utils(eth_rx_bd_reg)

  function new(string name = "rx_bd_reg");
    super.new(name, 64, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Status/Length word (bits 31:0)
    LEN   = uvm_reg_field::type_id::create("LEN");
    LEN.configure(this, 16, 16, "RW", 0, 0, 1, 0,0);

    E     = uvm_reg_field::type_id::create("E");
    E.configure(this, 1, 15, "RW", 0, 0, 1, 0,0);

    IRQ   = uvm_reg_field::type_id::create("IRQ");
    IRQ.configure(this, 1, 14, "RW", 0, 0, 1, 0,0);

    WRAP  = uvm_reg_field::type_id::create("WRAP");
    WRAP.configure(this, 1, 13, "RW", 0, 0, 1, 0,0);

    CF    = uvm_reg_field::type_id::create("CF");
    CF.configure(this, 1, 8, "RW", 0, 0, 1, 0,0);

    M     = uvm_reg_field::type_id::create("M");
    M.configure(this, 1, 7, "RW", 0, 0, 1, 0,0);

    OR    = uvm_reg_field::type_id::create("OR");
    OR.configure(this, 1, 6, "RW", 0, 0, 1, 0,0);

    IS    = uvm_reg_field::type_id::create("IS");
    IS.configure(this, 1, 5, "RW", 0, 0, 1, 0,0);

    DN    = uvm_reg_field::type_id::create("DN");
    DN.configure(this, 1, 4, "RW", 0, 0, 1, 0,0);

    TL    = uvm_reg_field::type_id::create("TL");
    TL.configure(this, 1, 3, "RW", 0, 0, 1, 0,0);

    SF    = uvm_reg_field::type_id::create("SF");
    SF.configure(this, 1, 2, "RW", 0, 0, 1, 0,0);

    CRC   = uvm_reg_field::type_id::create("CRC");
    CRC.configure(this, 1, 1, "RW", 0, 0, 1, 0,0);

    LC    = uvm_reg_field::type_id::create("LC");
    LC.configure(this, 1, 0, "RW", 0, 0, 1, 0,0);

    // Pointer word (bits 63:32)
    RXPNT = uvm_reg_field::type_id::create("RXPNT");
    RXPNT.configure(this, 32, 32, "RW", 0, 0, 1, 0,0);
  endfunction
endclass

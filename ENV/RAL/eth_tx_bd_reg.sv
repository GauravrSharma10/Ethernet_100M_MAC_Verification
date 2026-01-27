class eth_tx_bd_reg extends uvm_reg;
  rand uvm_reg_field LEN, RD, IRQ, WR, PAD, CRC, UR, RTRY, RL, LC, DF, CS, TXPNT;

  `uvm_object_utils(eth_tx_bd_reg)

  function new(string name = "tx_bd_reg");
    super.new(name, 64, UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    LEN  = uvm_reg_field::type_id::create("LEN");
    LEN.configure(this, 16, 16, "RW", 0, 0, 1, 0,0);

    RD   = uvm_reg_field::type_id::create("RD");
    RD.configure(this, 1, 15, "RW", 0, 0, 1, 0,0);

    IRQ  = uvm_reg_field::type_id::create("IRQ");
    IRQ.configure(this, 1, 14, "RW", 0, 0, 1, 0,0);

    WR   = uvm_reg_field::type_id::create("WR");
    WR.configure(this, 1, 13, "RW", 0, 0, 1, 0,0);

    PAD  = uvm_reg_field::type_id::create("PAD");
    PAD.configure(this, 1, 12, "RW", 0, 0, 1, 0,0);

    CRC  = uvm_reg_field::type_id::create("CRC");
    CRC.configure(this, 1, 11, "RW", 0, 0, 1, 0,0);

    UR   = uvm_reg_field::type_id::create("UR");
    UR.configure(this, 1, 8, "RW", 0, 0, 1, 0,0);

    RTRY = uvm_reg_field::type_id::create("RTRY");
    RTRY.configure(this, 4, 4, "RW", 0, 0, 1, 0,0);

    RL   = uvm_reg_field::type_id::create("RL");
    RL.configure(this, 1, 3, "RW", 0, 0, 1, 0,0);

    LC   = uvm_reg_field::type_id::create("LC");
    LC.configure(this, 1, 2, "RW", 0, 0, 1, 0,0);

    DF   = uvm_reg_field::type_id::create("DF");
    DF.configure(this, 1, 1, "RW", 0, 0, 1, 0,0);

    CS   = uvm_reg_field::type_id::create("CS");
    CS.configure(this, 1, 0, "RW", 0, 0, 1, 0,0);

    TXPNT = uvm_reg_field::type_id::create("TXPNT");
    TXPNT.configure(this, 32, 32, "RW", 0, 0, 1, 0,0);
  endfunction
endclass

class eth_reg_block extends uvm_reg_block;
  
  localparam int unsigned MAX_BD = 128;
  local int unsigned TX_BD_NUM = 64;
  local int unsigned RX_BD_NUM;
  
  `uvm_object_utils(eth_reg_block)

  eth_moder_reg       moder;
  eth_int_source_reg  int_source;
  eth_int_mask_reg    int_mask;
  eth_ipgt_reg        ipgt;
  eth_ipgr1_reg       ipgr1;
  eth_ipgr2_reg       ipgr2;
  eth_packetlen_reg   packetlen;
  eth_collconf_reg    collconf;
  eth_tx_bd_num_reg   tx_bd_num;
  eth_miimoder_reg    miimoder;
  eth_miicommand_reg  miicommand;
  eth_miiaddress_reg  miiaddress;
  eth_miitx_data_reg  miitx_data;
  eth_miirx_data_reg  miirx_data;
  eth_miistatus_reg   miistatus;
  eth_mac_addr0_reg   mac_addr0;
  eth_mac_addr1_reg   mac_addr1;
  eth_hash0_reg       hash0;
  eth_hash1_reg       hash1;
  eth_txctrl_reg      txctrl;
  eth_tx_bd_reg 	  tx_bd[];
  eth_rx_bd_reg		  rx_bd[];


  uvm_reg_map wb_map;

  function new(string name="eth_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  function void build();
    
    const uvm_reg_addr_t BD_BASE = 'h100;
    RX_BD_NUM = MAX_BD - TX_BD_NUM;
    
    // Map Tx area
    tx_bd.delete();
    tx_bd = new [TX_BD_NUM];
    
//     default_map = create_map("", `UVM_REG_ADDR_WIDTH'h0, 4, UVM_LITTLE_ENDIAN, 1);
    wb_map = create_map("wb_map", 'h0, 4, UVM_LITTLE_ENDIAN , 0);

    foreach (tx_bd[i]) begin
      tx_bd[i] = eth_tx_bd_reg::type_id::create($sformatf("tx_bd_%0d", i));
      tx_bd[i].build();
      tx_bd[i].configure(this);
      this.wb_map.add_reg(tx_bd[i], BD_BASE + (i*2), "RW");
    end
    rx_bd.delete();

    rx_bd = new [RX_BD_NUM];
    // Map Rx area
    foreach (rx_bd[i]) begin
      rx_bd[i] = eth_rx_bd_reg::type_id::create($sformatf("rx_bd_%0d", i));
      rx_bd[i].build();
      rx_bd[i].configure(this);
      this.wb_map.add_reg(rx_bd[i], BD_BASE + TX_BD_NUM*2 + i*2, "RW");
    end
 
    // IMPORTANT: create all register objects before using them
    moder       = eth_moder_reg      ::type_id::create("moder",        , get_full_name());
    int_source  = eth_int_source_reg ::type_id::create("int_source",   , get_full_name());
    int_mask    = eth_int_mask_reg   ::type_id::create("int_mask",     , get_full_name());
    ipgt        = eth_ipgt_reg       ::type_id::create("ipgt",         , get_full_name());
    ipgr1       = eth_ipgr1_reg      ::type_id::create("ipgr1",        , get_full_name());
    ipgr2       = eth_ipgr2_reg      ::type_id::create("ipgr2",        , get_full_name());
    packetlen   = eth_packetlen_reg  ::type_id::create("packetlen",    , get_full_name());
    collconf    = eth_collconf_reg   ::type_id::create("collconf",     , get_full_name());
    tx_bd_num   = eth_tx_bd_num_reg  ::type_id::create("tx_bd_num",    , get_full_name());
    miimoder    = eth_miimoder_reg   ::type_id::create("miimoder",     , get_full_name());
    miicommand  = eth_miicommand_reg ::type_id::create("miicommand",   , get_full_name());
    miiaddress  = eth_miiaddress_reg ::type_id::create("miiaddress",   , get_full_name());
    miitx_data  = eth_miitx_data_reg ::type_id::create("miitx_data",   , get_full_name());
    miirx_data  = eth_miirx_data_reg ::type_id::create("miirx_data",   , get_full_name());
    miistatus   = eth_miistatus_reg  ::type_id::create("miistatus",    , get_full_name());
    mac_addr0   = eth_mac_addr0_reg  ::type_id::create("mac_addr0",    , get_full_name());
    mac_addr1   = eth_mac_addr1_reg  ::type_id::create("mac_addr1",    , get_full_name());
    hash0       = eth_hash0_reg      ::type_id::create("hash0",        , get_full_name());
    hash1       = eth_hash1_reg      ::type_id::create("hash1",        , get_full_name());
    txctrl      = eth_txctrl_reg     ::type_id::create("txctrl",       , get_full_name());

    // Create map

    // Build & configure regs, add to map
    moder.build();        moder.configure(this);        wb_map.add_reg(moder,       'h00, "RW");
    int_source.build();   int_source.configure(this);   wb_map.add_reg(int_source,  'h01, "RW");
    int_mask.build();     int_mask.configure(this);     wb_map.add_reg(int_mask,    'h02, "RW");
    ipgt.build();         ipgt.configure(this);         wb_map.add_reg(ipgt,        'h03, "RW");
    ipgr1.build();        ipgr1.configure(this);        wb_map.add_reg(ipgr1,       'h04, "RW");
    ipgr2.build();        ipgr2.configure(this);        wb_map.add_reg(ipgr2,       'h05, "RW");
    packetlen.build();    packetlen.configure(this);    wb_map.add_reg(packetlen,   'h06, "RW");
    collconf.build();     collconf.configure(this);     wb_map.add_reg(collconf,    'h07, "RW");
    tx_bd_num.build();    tx_bd_num.configure(this);    wb_map.add_reg(tx_bd_num,   'h08, "RW");
    miimoder.build();     miimoder.configure(this);     wb_map.add_reg(miimoder,    'h0A, "RW");
    miicommand.build();   miicommand.configure(this);   wb_map.add_reg(miicommand,  'h0B, "RW");
    miiaddress.build();   miiaddress.configure(this);   wb_map.add_reg(miiaddress,  'h0C, "RW");
    miitx_data.build();   miitx_data.configure(this);   wb_map.add_reg(miitx_data,  'h0D, "RW");
    miirx_data.build();   miirx_data.configure(this);   wb_map.add_reg(miirx_data,  'h0E, "RO");
    miistatus.build();    miistatus.configure(this);    wb_map.add_reg(miistatus,   'h0F, "RO");
    mac_addr0.build();    mac_addr0.configure(this);    wb_map.add_reg(mac_addr0,   'h10, "RW");
    mac_addr1.build();    mac_addr1.configure(this);    wb_map.add_reg(mac_addr1,   'h11, "RW");
    hash0.build();        hash0.configure(this);        wb_map.add_reg(hash0,       'h12, "RW");
    hash1.build();        hash1.configure(this);        wb_map.add_reg(hash1,       'h13, "RW");
    txctrl.build();       txctrl.configure(this);       wb_map.add_reg(txctrl,      'h14, "RW");

    lock_model();
  endfunction
endclass

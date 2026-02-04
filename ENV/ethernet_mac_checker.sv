///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_checker.sv
//
// Author:
// Date: 12/12/2025
// Revision: 1
//
// Company: Scaledge Technology Pvt.
//
// Copyright (c) 2025 Scaledge Technology Pvt. All rights reserved.
//
// This file is part of the Ethernet_MAC_VIP project.
//
// Description: Checker component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_CHECKER_SV
`define ETHERNET_MAC_CHECKER_SV
 
// import eth_reg_pkg::*;

class ethernet_mac_checker extends uvm_component;
  `uvm_component_utils(ethernet_mac_checker)

  virtual wishbone_master_interface m_vif;
  virtual wishbone_slave_interface  s_vif;
  virtual phy_rx_interface          r_vif;
  virtual phy_tx_interface          t_vif;

  eth_reg_block reg_model;

  int unsigned tx_bd_num_value;
  int unsigned tx_bd_idx;
  int unsigned rx_bd_idx;
  int unsigned prev_bd;

  bit          wrap;
  int          rd_bit;
  bit          odd_nibble;
  bit          dn_bit;
  int          collvalid;
  bit          lc_bit;
  bit          rl_bit;
  bit          cf_bit;

  int tx_nibble_cnt;
  int tx_byte_cnt;
 
  int rx_nibble_cnt;
  int rx_byte_cnt;
  int tx_len;
  int maxfl;
  int minfl;
  int retry_cnt;
  int maxret;

  realtime last_tx_end_time;

  function new(string name="ethernet_mac_checker", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual wishbone_master_interface)::get(this,"","m_vif",m_vif))
      `uvm_fatal("NO_VIF","wishbone master vif not set")

    if (!uvm_config_db#(virtual wishbone_slave_interface)::get(this,"","s_vif",s_vif))
      `uvm_fatal("NO_VIF","wishbone slave vif not set")

    if (!uvm_config_db#(virtual phy_rx_interface)::get(this,"","r_vif",r_vif))
      `uvm_fatal("NO_VIF","phy rx vif not set")

    if (!uvm_config_db#(virtual phy_tx_interface)::get(this,"","t_vif",t_vif))
      `uvm_fatal("NO_VIF","phy tx vif not set")

    if (!uvm_config_db#(eth_reg_block)::get(this,"","reg_model",reg_model))
      `uvm_fatal("NO_RAL","RAL model not found for checker")
  endfunction

  task run_phase(uvm_phase phase);
    tx_bd_idx = 0;
    rx_bd_idx = 0;
    tx_nibble_cnt = 0;
    tx_byte_cnt   = 0;
    rx_nibble_cnt = 0;
    rx_byte_cnt   = 0;
 

    fork
     check_padding_behavior();
      check_loopback_data_match();
      check_tx_crc_append();
      check_dlycrc_mode_cfg();
      check_rx_crc_error_flag();
      check_duplex_rules();
      check_excess_deferral();
      check_backoff_rule();
      check_rxflow_rxc_rule();
      check_txflow_txc_rule();
      check_pause_full_duplex_only();
      check_txbd_num_zero_tx_disable();
      check_txbd_num_max_rx_disable();
      check_nopre();
      check_rx_starts_when_empty_bit_set();     
      check_tx_enable();
      check_rx_enable();
      check_tx_bd_ready();
      check_ipg_hd_fd();
      check_tx_only_when_media_idle();
      check_collision_handling();
      check_wrap_tx_bd();
      check_wrap_rx_bd();
      check_rx_short_frame_and_crc();
      check_rx_too_long_frame();
      check_tx_min_frame_length_via_BD_LEN_field();
      check_rx_dribble_nibble();
      check_tx_late_collision_lc_bit();
      check_tx_retry_limit_and_rl_bit();
      check_rx_pause_frame_rxc_interrupt();
       
    join_none
  endtask
    
    
   task tx_nibble_byte_cnt_task();
      `uvm_info("TX_NIBBLE_BYTE_CNT_TASK","INSIDE TX_NIBBLE_BYTE_CNT_TASK",UVM_LOW)
 
      tx_nibble_cnt = 0;
      tx_byte_cnt   = 0;
         
       while (t_vif.tx_en) begin
        @(posedge t_vif.clk);
        tx_nibble_cnt++;
      //  $display("tx_nibble_cnt = %0d",tx_nibble_cnt);
         if (tx_nibble_cnt % 2 != 0)
          tx_byte_cnt++;
      //  $display("tx_byte_cnt = %0d",tx_byte_cnt);
 
      end
       
        
         `uvm_info("TX_NIBBLE_BYTE_CNT_TASK",$sformatf("[%0t] WHEN TX_ENABLE IS HIGH :: NIBBLE_COUNT = %0d nibbles  BYTE_COUNT = %0d bytes",$time, tx_nibble_cnt,tx_byte_cnt),UVM_LOW)
         
       
      
    endtask
    
    task rx_nibble_byte_cnt_task();
      `uvm_info("RX_NIBBLE_BYTE_CNT_TASK","INSIDE RX_NIBBLE_BYTE_CNT_TASK",UVM_LOW)
 
      rx_nibble_cnt = 0;
      rx_byte_cnt   = 0;
         
         while (r_vif.rx_dv) begin
        @(posedge t_vif.clk);
          rx_nibble_cnt++;
          // $display("rx_nibble_cnt = %0d",rx_nibble_cnt);
           if (rx_nibble_cnt % 2 != 0)
          rx_byte_cnt++;
          // $display("rx_byte_cnt = %0d",rx_byte_cnt);
      end
         `uvm_info("RX_NIBBLE_BYTE_CNT_TASK",$sformatf(" [%0t] WHEN RX_DV IS HIGH :: NIBBLE_COUNT = %0d nibbles  BYTE_COUNT = %0d bytes",$time, rx_nibble_cnt,rx_byte_cnt),UVM_LOW)
    
    endtask
   
    
// checkers ::
  task check_padding_behavior();
    
    int minfl;
 `uvm_info("CHECK_PADDING_BEHAVIOR"," INSIDE CHECK_PADDING_BEHAVIOR TASK",UVM_LOW)
    
    forever begin
      @(posedge t_vif.tx_en);
      minfl = reg_model.packetlen.minfl.get_mirrored_value();
       tx_nibble_byte_cnt_task();
      `uvm_info("CHECK_PADDING_BEHAVIOR",
        $sformatf("TX frame started — MINFL = %0d bytes", minfl),
        UVM_LOW)
    
      
      if (tx_byte_cnt < minfl) begin
        if (!reg_model.moder.pad.get_mirrored_value()) begin
          `uvm_error("CHECK_PADDING_BEHAVIOR",
            $sformatf("Frame length = %0d < MINFL (%0d) but PAD disabled",
                      tx_byte_cnt, minfl))
        end
        else begin
          `uvm_info("CHECK_PADDING_BEHAVIOR",
            $sformatf("Short frame padded correctly (%0d bytes) for mon frma lrength = %0d",
                      tx_byte_cnt, minfl),
            UVM_LOW)
        end
      end
      else
        `uvm_info("CHECK_PADDING_BEHAVIOR",
          $sformatf("NO PADDING REQUIRED AS BYTE_CNT = %0d AND MINFL= %0d ",
                    tx_byte_cnt, minfl),
          UVM_LOW)
    end
  endtask

  
task check_loopback_data_match();
      bit [3:0] tx_q[$];    
  int idx;
 `uvm_info("CHECK_LOOPBACK_DATA_MATCH"," INSIDE CHECK_LOOPBACK_DATA_MATCH TASK",UVM_LOW)

  forever begin

    
    @(posedge t_vif.tx_en);

    if (!reg_model.moder.loopbck.get_mirrored_value())
      
    `uvm_info("CHECK_LOOPBACK_DATA_MATCH",
      "Loopback disabled :: captured RX data is not same as TX data",
      UVM_LOW)

      continue;

    `uvm_info("CHECK_LOOPBACK_DATA_MATCH",
      "Loopback enabled — capturing TX data",
      UVM_LOW)

    tx_q.delete();

     
    while (t_vif.tx_en) begin
      @(posedge t_vif.clk);
      tx_q.push_back(t_vif.txd);
    end

    `uvm_info("CHECK_LOOPBACK_DATA_MATCH",
      $sformatf("Captured %0d TX nibbles", tx_q.size()),
      UVM_LOW)

    
    @(posedge r_vif.rx_dv);

     
    idx = 0;

    while (r_vif.rx_dv) begin
      @(posedge r_vif.clk);

      if (idx >= tx_q.size()) begin
        `uvm_error("CHECK_LOOPBACK_DATA_MATCH",
          "RX frame longer than TX frame")
        break;
      end

      if (r_vif.rxd !== tx_q[idx]) begin
        `uvm_error("CHECK_LOOPBACK_DATA_MATCH",
          $sformatf("Nibble mismatch at index %0d : TX=%h RX=%h",
                     idx, tx_q[idx], r_vif.rxd))
      end

      idx++;
    end

    
    if (idx != tx_q.size()) begin
      `uvm_error("CHECK_LOOPBACK_DATA_MATCH",
        $sformatf("Length mismatch TX=%0d RX=%0d",
                   tx_q.size(), idx))
    end
    else begin
      `uvm_info("CHECK_LOOPBACK_DATA_MATCH",
        "Loopback TX and RX data match",
        UVM_LOW)
    end

  end

endtask

  
task check_tx_crc_append();
  int minfl;
  int maxfl;
  bit crc_global_en;
  bit crc_bd_en;
 `uvm_info("CHECK_TX_CRC_APPEND"," INSIDE CHECK_TX_CRC_APPEND TASK",UVM_LOW)

  forever begin

     
    @(posedge t_vif.tx_en);

   
 
    minfl = reg_model.packetlen.minfl.get_mirrored_value();
    maxfl = reg_model.packetlen.maxfl.get_mirrored_value();

    crc_global_en = reg_model.moder.crcen.get_mirrored_value();
    crc_bd_en     = reg_model.tx_bd[0].CRC.get_mirrored_value();
    tx_nibble_byte_cnt_task();
    
     
    `uvm_info("CHECK_TX_CRC_APPEND",
              $sformatf("TX frame ended bytes=%0d  MINFL=%0d MAXFL=%0d CRCEN=%0d BD_CRC=%0d",
                 tx_byte_cnt, minfl, maxfl,crc_global_en, crc_bd_en),
      UVM_LOW)
    
  if (crc_global_en && crc_bd_en) begin  


    if (tx_byte_cnt < minfl) 
      `uvm_warning("CHECK_TX_CRC_APPEND",
                   $sformatf("TX frame too short (%0d bytes)", tx_byte_cnt))
    
      else if (tx_byte_cnt > maxfl)  
      `uvm_warning("CHECK_TX_CRC_APPEND",
                   $sformatf("TX frame too long (%0d bytes)", tx_byte_cnt))
     
    else  
      `uvm_info("CHECK_TX_CRC_APPEND",
                $sformatf("TX frame length within valid range  and CRC is appended as CRCEN=%0d BD_CRC=%0d ",crc_global_en, crc_bd_en),
        UVM_LOW)
      end

     
      else if ((crc_bd_en && !crc_global_en) || (!crc_bd_en && crc_global_en) ) 
      `uvm_error("CHECK_TX_CRC_APPEND",
                 $sformatf("TX_BD.CRC=%0d but MODER.CRCEN=%0d — invalid configuration",crc_bd_en,crc_global_en))
    
    
    else 
      `uvm_info("CHECK_TX_CRC_APPEND",
          "CRC append disabled — ensure payload already contains CRC",
          UVM_LOW)  

  end

endtask
  
 
task check_dlycrc_mode_cfg();
  bit crc_en;
  bit dlycrc_en;
`uvm_info("CHECK_DLYCRC_MODE_CFG"," INSIDE CHECK_DLYCRC_MODE_CFG TASK",UVM_LOW)

  forever begin

    
    @(posedge t_vif.tx_en);

    crc_en    = reg_model.moder.crcen.get_mirrored_value();
    dlycrc_en = reg_model.moder.dlycrcen.get_mirrored_value();

    `uvm_info("CHECK_DLYCRC_MODE_CFG",
      $sformatf("CRCEN=%0b  DLYCRCEN=%0b", crc_en, dlycrc_en),
      UVM_LOW)

    
    if (dlycrc_en && !crc_en) begin
      `uvm_error("CHECK_DLYCRC_MODE_CFG",
        "DLYCRCEN=1 but CRCEN=0 — delayed CRC mode invalid when CRC disabled")
    end

   
    else if (crc_en && dlycrc_en) begin
      `uvm_info("CHECK_DLYCRC_MODE_CFG",
        "Delayed CRC enabled — CRC calculation starts 4 bytes after SFD",
        UVM_LOW)
    end

    else if (crc_en && !dlycrc_en) begin
      `uvm_info("CHECK_DLYCRC_MODE_CFG",
        "Normal CRC mode — CRC calculation starts immediately after SFD",
        UVM_LOW)
    end

    else begin
      `uvm_info("CHECK_DLYCRC_MODE_CFG",
        "CRC append disabled — DLYCRCEN ignored",
        UVM_LOW)
    end

  end

endtask
 
task check_rx_crc_error_flag();
  bit crc_err_flag;
  `uvm_info("CHECK_RX_CRC_ERROR_FLAG"," INSIDE CHECK_RX_CRC_ERROR_FLAG TASK",UVM_LOW)

  forever begin
    @(posedge r_vif.rx_dv);
       crc_err_flag = reg_model.rx_bd[0].CRC.get_mirrored_value();
      rx_nibble_byte_cnt_task();
    `uvm_info("CHECK_RX_CRC_ERROR_FLAG",
                 $sformatf("RX frame end ::  frame_length in bytes = %0d frame_length in nibbles = %0d CRC_ERR=%0b",
                           rx_byte_cnt,rx_nibble_cnt,crc_err_flag),UVM_LOW)

    
    if (crc_err_flag) begin
      `uvm_warning("CHECK_RX_CRC_ERROR_FLAG",
          "RX BD indicates CRC ERROR for descriptor RX_BD"
           )
    end
    else begin
      `uvm_info("CHECK_RX_CRC_ERROR_FLAG",
        "RX BD indicates CRC OK",
        UVM_LOW)
    end

  end

endtask
  
 
task check_duplex_rules();
  
  bit full_duplex;
  int ipgt_val;
  `uvm_info("CHECK_DUPLEX_RULES"," INSIDE CHECK_DUPLEX_RULES TASK",UVM_LOW)

  forever begin
    @(posedge t_vif.tx_en);

    full_duplex = reg_model.moder.fulld.get_mirrored_value();
    ipgt_val    = reg_model.ipgt.ipgt.get_mirrored_value();
    
     `uvm_info("CHECK_DUPLEX_RULES",
               $sformatf("full_duplex = %0d  ipgt_val = %0h ",full_duplex,ipgt_val),
        UVM_LOW)
 
    
    if (!full_duplex) begin

      `uvm_info("CHECK_DUPLEX_RULES",
        $sformatf("Half duplex mode active — IPGT=%0h", ipgt_val),
        UVM_LOW)
 
      if (ipgt_val != 7'h12) begin
        `uvm_warning("CHECK_DUPLEX_RULES",
          $sformatf(
           "Half duplex recommended IPGT=0x12 but configured=%0h",
            ipgt_val))
      end

    end

    
    else begin

      `uvm_info("CHECK_DUPLEX_RULES",
                $sformatf("Full duplex mode active — IPGT=%0h",
          ipgt_val),
        UVM_LOW)

       
      if (ipgt_val != 7'h15) begin
        `uvm_warning("CHECK_DUPLEX_RULES",
          $sformatf(
            "Full duplex recommended IPGT=0x15 but configured=%0h",
            ipgt_val))
      end

    end

  end

endtask
    
 
task check_excess_deferral();
  bit full_duplex;
  bit exdfren_moder;
  bit exdef_tx_bd;

  int ipgt_val;
  int ipgr1_val;
  int ipgr2_val;
  `uvm_info("CHECK_EXCESS_DEFERRAL"," INSIDE CHECK_EXCESS_DEFERRAL TASK",UVM_LOW)

  forever begin
 
    @(posedge t_vif.tx_en);

    full_duplex  = reg_model.moder.fulld.get_mirrored_value();
    exdfren_moder = reg_model.moder.exdfr_en.get_mirrored_value();
    exdef_tx_bd   = reg_model.tx_bd[0].DF.get_mirrored_value();

    ipgt_val  = reg_model.ipgt.ipgt.get_mirrored_value();
    ipgr1_val = reg_model.ipgr1.ipgr1.get_mirrored_value();
    ipgr2_val = reg_model.ipgr2.ipgr2.get_mirrored_value();
    
     `uvm_info("CHECK_EXCESS_DEFERRAL",
      $sformatf(
       " EXDFREN_MODER = %0d  EXDEF_TX_BD = %0d IPGT=%0h IPGR1=%0h IPGR2=%0h",
        exdfren_moder, exdef_tx_bd , ipgt_val, ipgr1_val, ipgr2_val),
      UVM_LOW)


     
    if (full_duplex) begin
      `uvm_info("CHECK_EXCESS_DEFERRAL",
        "Full duplex mode — excess deferral not applicable",
        UVM_LOW)
      continue;
    end

    
    
    if (exdef_tx_bd) begin

      if (exdfren_moder) begin
       
        `uvm_warning("CHECK_EXCESS_DEFERRAL",
          "EXDEF set as well as EXDFREN=1 (MAC should wait indefinitely, not abort)")
      end
      else begin
        
        `uvm_info("CHECK_EXCESS_DEFERRAL",
          "Packet aborted due to excessive deferral as expected",
          UVM_MEDIUM)
      end

    end
    else begin
      `uvm_info("CHECK_EXCESS_DEFERRAL",
        "No excessive deferral detected for this TX attempt",
        UVM_LOW)
    end

  end

endtask
    
  
task check_backoff_rule();
  bit nobackoff_moder;
  bit full_duplex;
  int retry_window_cycles = 8;  
  int tx_restart_seen;
    `uvm_info("CHECK_BACKOFF_RULE","INSIDE CHECK_BACKOFF_RULE TASK",UVM_LOW)
  forever begin
     @(posedge r_vif.col);
    `uvm_info("CHECK_BACKOFF_RULE",$sformatf("BEFORE CHECKING FOR BACK OFF ALGO, NEED TO CHECK FOR COLLISION HAS ACTUALLY HAPPENED OR NOT  , COLLISION = %0d",r_vif.col),UVM_LOW)
    
    @(posedge r_vif.col);

    nobackoff_moder = reg_model.moder.nobckof.get_mirrored_value();
    full_duplex    = reg_model.moder.fulld.get_mirrored_value();

    
    if (full_duplex) begin
      `uvm_info("CHECK_BACKOFF_RULE",
        "Collision seen in full duplex — ignored",
        UVM_LOW)
      continue;
    end

    `uvm_info("CHECK_BACKOFF_RULE",
              $sformatf("Collision detected — NOBCKOF=%0d", nobackoff_moder),
      UVM_LOW)

    
     tx_restart_seen = 0;

    repeat (retry_window_cycles) begin
      @(posedge t_vif.clk);
      if (t_vif.tx_en)
        tx_restart_seen = 1;
    end

    
    if (!nobackoff_moder) begin

      if (tx_restart_seen) begin
        `uvm_error("CHECK_BACKOFF_RULE",
          "TX restarted too soon — backoff expected after collision")
      end
      else begin
        `uvm_info("CHECK_BACKOFF_RULE",
          "Backoff delay observed after collision",
          UVM_MEDIUM)
      end

    end

    
    else begin

      if (!tx_restart_seen) begin
        `uvm_warning("CHECK_BACKOFF_RULE",
          "No immediate retry seen though NOBCKOF=1")
      end
      else begin
        `uvm_info("CHECK_BACKOFF_RULE",
          "Immediate retry observed — no-backoff mode correct",
          UVM_MEDIUM)
      end

    end

  end

endtask
  
   
task check_rxflow_rxc_rule();
    bit rxc     = reg_model.int_source.rxc.get_mirrored_value();
   bit rxflow  = reg_model.ctrlmoder.rxflow.get_mirrored_value();
  `uvm_info("CHECK_RXFLOW_RXC_RULE",$sformatf("rxc = %0d rxflow = %0d",rxc,rxflow),UVM_LOW)

  forever begin
    @(posedge r_vif.rx_dv);  
    `uvm_info("CHECK_RXFLOW_RXC_RULE","INSIDE FOREVER BLOCK WITH REFERENCE TO RX_DV OF R_VIF",UVM_LOW) 
    
    if (rxc && !rxflow) begin
      `uvm_error("CHECK_RXFLOW_RXC_RULE",
        "RXC interrupt set while RXFLOW=0")
    end

    if (rxc && rxflow) begin
      `uvm_info("CHECK_RXFLOW_RXC_RULE",
        "RXC correctly set with RXFLOW enabled",
        UVM_LOW)
    end
    
    if(!rxc && !rxflow)begin
      `uvm_info("CHECK_RXFLOW_RXC_RULE",
        "RXC  and RXFLOW both are disabled",
        UVM_LOW)
    end
    
  end

endtask

    
task check_txflow_txc_rule();
   bit txc    = reg_model.int_source.txc.get_mirrored_value();
    bit txflow = reg_model.ctrlmoder.txflow.get_mirrored_value();
  `uvm_info("CHECK_TXFLOW_TXC_RULE",$sformatf("txc = %0d txflow = %0d",txc,txflow),UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);

   
    if (txc && !txflow) begin
      `uvm_error("CHECK_TXFLOW_TXC_RULE",
        "TXC interrupt set while TXFLOW=0")
    end
     if (txc && txflow) begin
       `uvm_info("CHECK_TXFLOW_TXC_RULE",
        "TXC correctly set with TXFLOW enabled",
        UVM_LOW)
    end
    if(!txc && !txflow)begin
      `uvm_info("CHECK_TXFLOW_TXC_RULE",
        "TXC  and TXFLOW both are disabled",
        UVM_LOW)
    end
    
  end

endtask
    
    
 
    
task check_pause_full_duplex_only();
   
  bit is_ctrl_frame;
  bit is_full_duplex;
    `uvm_info("CHECK_PAUSE_FULL_DUPLEX_ONLY"," INSIDE CHECK_PAUSE_FULL_DUPLEX_ONLY TASK",UVM_LOW)
  forever begin
    @(posedge r_vif.rx_dv);

     is_ctrl_frame =
    reg_model.rx_bd[0].CF.get_mirrored_value();
     is_full_duplex = 
    reg_model.moder.fulld.get_mirrored_value();
    
       `uvm_info("CHECK_PAUSE_FULL_DUPLEX_ONLY",$sformatf("PAUSE CONTROL FRAME = %0d full duplex = %0d ",is_ctrl_frame,is_full_duplex ),UVM_LOW)

    if (is_ctrl_frame &&
        !is_full_duplex) begin

      `uvm_error("CHECK_PAUSE_FULL_DUPLEX_ONLY",
        "Pause control frame transmitted in half duplex")

    end
    else 
      `uvm_info("CHECK_PAUSE_FULL_DUPLEX_ONLY",$sformatf("PAUSE CONTROL FRAME = %0d full duplex = %0d ::Pause frame only allowed in full duplex",is_ctrl_frame,is_full_duplex ),UVM_LOW)
  end

endtask
 
  
task check_txbd_num_zero_tx_disable();
    `uvm_info("CHECK_TXBD_NUM_ZERO_RX_DISABLE","INSIDE CHECKER TASK :: TX disabled when TXBD_NUM = 0 ",UVM_LOW)
  forever begin
    @(posedge t_vif.clk);

    if (reg_model.tx_bd_num.get_mirrored_value() == 0) begin
      if (t_vif.tx_en) begin
        `uvm_error("CHECK_TXBD_NUM_ZERO_TX_DISABLE",
          "TX_EN asserted even though TXBD_NUM = 0")
      end
    end
   // else 
   //   `uvm_info("CHECK_TXBD_NUM_ZERO_TX_DISABLE",$sformatf("TX_BD_NUM = %0h hence tx is enabled ",reg_model.tx_bd_num.get_mirrored_value()),UVM_LOW)
  end

endtask
 
task check_txbd_num_max_rx_disable();
    `uvm_info("CHECK_RXBD_NUM_MAX_RX_DISABLE","INSIDE CHECKER TASK :: RX disabled when TXBD_NUM = 0x80 ",UVM_LOW)
  forever begin
    @(posedge r_vif.clk);

    if (reg_model.tx_bd_num.get_mirrored_value() == 8'h80) begin
      if (r_vif.rx_dv) begin
        `uvm_error("CHECK_RXBD_NUM_MAX_RX_DISABLE",
          "RX_DV asserted even though TXBD_NUM = 0x80 (RX disabled)")
      end
    end
    // else 
    //   `uvm_info("CHECK_RXBD_NUM_MAX_RX_DISABLE",$sformatf("TX_BD_NUM = %0h hence rx is enabled  ",reg_model.tx_bd_num.get_mirrored_value()),UVM_LOW)
  end

endtask

 
task check_nopre();
  
  byte preamble_nibbles[$];
  int nibble_cnt;
   `uvm_info("CHECK_NOPRE"," INSIDE CHECK_NOPRE TASK",UVM_LOW)

  forever begin
   
    @(posedge t_vif.tx_en);

   
    if (!reg_model.moder.nopre.get_mirrored_value()) begin
      preamble_nibbles.delete();  
      nibble_cnt = 0;

       
      while (nibble_cnt < 16) begin
        @(posedge t_vif.clk);
        preamble_nibbles.push_back(t_vif.txd);
        nibble_cnt++;
      end

      
      foreach (preamble_nibbles[i]) begin
        if (i < 14) begin
           
          if (preamble_nibbles[i] != 4'h5) begin
            `uvm_error("PREAMBLE", $sformatf(
              "Invalid preamble nibble at position %0d: got 0x%0h, expected 0x5", 
              i, preamble_nibbles[i]))
          end
        end 
        else if (i == 14) begin
      
          if (preamble_nibbles[i] != 4'hD) begin
            `uvm_error("SFD", $sformatf(
              "Invalid SFD upper nibble: got 0x%0h, expected 0xD", 
              preamble_nibbles[i]))
          end
        end 
        else if (i == 15) begin
           
          if (preamble_nibbles[i] != 4'h5) begin
            `uvm_error("SFD", $sformatf(
              "Invalid SFD lower nibble: got 0x%0h, expected 0x5", 
              preamble_nibbles[i]))
          end
        end
        
      end

      
      `uvm_info("CHECK_NOPRE", 
                $sformatf("Preamble as well as SFD are correctly transmitted when NOPRE = %0d", reg_model.moder.nopre.get_mirrored_value()),
        UVM_LOW)
    end
    else 
      `uvm_info("CHECK_NOPRE",$sformatf("NOPRE = %0d hence Preamble is not sent ",reg_model.moder.nopre.get_mirrored_value()),UVM_LOW)
  end

endtask
  
  task check_rx_starts_when_empty_bit_set();
       `uvm_info("CHECK_RX_STARTS_WHEN_EMPTY_BIT_SET"," INSIDE CHECK_RX_STARTS_WHEN_EMPTY_BIT_SET TASK",UVM_LOW)
  forever begin
    @(posedge r_vif.rx_dv);
    if (!reg_model.rx_bd[0].E.get_mirrored_value())
      `uvm_info("CHECK_RX_STARTS_WHEN_EMPTY_BIT_SET","RX started when E=0",UVM_LOW)
    else 
      `uvm_error("CHECK_RX_STARTS_WHEN_EMPTY_BIT_SET","RX started when E=1")
  end
endtask  
        
task check_tx_enable();
       `uvm_info("CHECK_TX_ENABLE"," INSIDE CHECK_TX_ENABLE TASK",UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);
    if (!reg_model.moder.txen.get_mirrored_value())
      `uvm_error("TXEN_ERR","TX_EN asserted while MODER.TXEN=0")
    else
      `uvm_info("TXEN","TX_EN asserted while MODER.TXEN=1",UVM_LOW)
  end
endtask

task check_rx_enable();
  bit rxen;
  bit no_rx_bd;

  `uvm_info("CHECK_RX_ENABLE",
            "INSIDE CHECK_RX_ENABLE TASK",
            UVM_LOW)

  forever begin
    @(posedge r_vif.rx_dv);
    rxen     = reg_model.moder.rxen.get_mirrored_value();
    no_rx_bd = (reg_model.tx_bd_num.get_mirrored_value() == 8'h80);
    if (!rxen) begin
      `uvm_info("RXEN_LOW",
        "RX_DV asserted while MODER.RXEN = 0.If the value, written to the TX_BD_NUM register, is equal to 0x80 (all buffer descriptors are used for transmit buffer descriptors, so there is no receive BD), then receiver is automatically disabled regardless of the RXEN bit.",UVM_LOW)
    end
    else if (no_rx_bd) begin
      `uvm_error("RXBD_ERR",
                 "RX_DV asserted while TX_BD_NUM = 8'h80 (no RX buffer descriptors) as well as RECEN = 0 of moder tregister")
    end
    else begin
      `uvm_info("RXEN_OK",
        "RX_DV asserted with RXEN=1 and RX BDs available",
        UVM_LOW)
    end
  end
endtask


task check_tx_bd_ready();
       `uvm_info("CHECK_TX_BD_READY"," INSIDE CHECK_TX_BD_READY TASK",UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);
    if (!reg_model.tx_bd[0].RD.get_mirrored_value())
      `uvm_error("TXBD_RD","TX started with RD=0")
    else
      `uvm_info("TXBD_RD",
                " TX started with RD=1 ",
        UVM_LOW)
  end
endtask

task check_ipg_hd_fd();
  int idle_nibbles;
  int expected_nibbles;
  bit full_duplex;

  `uvm_info("CHECK_IPG_HD_FD","IPG checker (HD + FD) started",UVM_LOW)

  forever begin
    @(negedge t_vif.tx_en);
    full_duplex = reg_model.moder.fulld.get_mirrored_value();
    if (full_duplex)
      expected_nibbles =
        reg_model.ipgt.ipgt.get_mirrored_value() + 6;
    else
      expected_nibbles =
        reg_model.ipgt.ipgt.get_mirrored_value() + 3;

    idle_nibbles = 0;

     
    while (!t_vif.tx_en) begin
      @(posedge t_vif.clk);
      if (t_vif.txd == 4'h0 ||
          t_vif.txd == 4'hF ||
          t_vif.txd === 4'hX)
        idle_nibbles++;
    end

    `uvm_info("IPG_OBS",
              $sformatf("Mode = %s DUPLEX IPGT=%0d Expected_nibbles = %0d nibbles  Observed_nibbles = %0d nibbles",
        full_duplex ? "FULL" : "HALF",
        reg_model.ipgt.ipgt.get_mirrored_value(),
        expected_nibbles,
        idle_nibbles),
      UVM_LOW)

    if (idle_nibbles < expected_nibbles)
      `uvm_error("IPG_ERR",
        $sformatf("IPG violation (%s duplex): %0d < %0d nibble times",
          full_duplex ? "FULL" : "HALF",
          idle_nibbles, expected_nibbles))
      `uvm_info("CHECK_IPG_HD_FD","CHECK PASSED FOR CHECK_IPG_HD_FD ",UVM_LOW)
  end
      
endtask


task check_tx_only_when_media_idle();
   `uvm_info("CHECK_TX_ONLY_WHEN_MEDIA_IDLE"," INSIDE CHECK_TX_ONLY_WHEN_MEDIA_IDLE TASK",UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);
    if (r_vif.crs)
      `uvm_error("CS_ERR",
        "TX_EN asserted while carrier_sense=1 (media busy)")
    else
      `uvm_info("CS_OK",
        "TX started when media idle (carrier_sense=0)",
        UVM_LOW)
  end
endtask

task check_collision_handling();
     `uvm_info("CHECK_COLLISION_HANDLING"," INSIDE CHECK_COLLISION_HANDLING TASK",UVM_LOW)
  forever begin
    @(posedge r_vif.col);
    if (t_vif.tx_en) begin
      @(posedge t_vif.clk);
      if (t_vif.tx_en)
        `uvm_error("COLL_ERR",
          "TX_EN continues after collision_detect asserted")
      else
        `uvm_info("COLL_OK",
          "TX terminated correctly after collision_detect",
          UVM_LOW)
    end
  end
endtask

task check_wrap_tx_bd();
      `uvm_info("CHECK_WRAP_TX_BD",
    "Inside CHECK_WRAP_TX_BD task ", UVM_NONE)

  forever begin
    @(negedge t_vif.tx_en);
    prev_bd = tx_bd_idx;
    wrap    = reg_model.tx_bd[prev_bd].WR.get_mirrored_value();

    `uvm_info(get_type_name(),
      $sformatf("Transmission :: prev_bd_idx = %0d wrap = %0d",
                prev_bd, wrap),
      UVM_NONE)

    if (wrap)
      tx_bd_idx = 0;
    else
      tx_bd_idx++;

    if (wrap && tx_bd_idx != 0)
      `uvm_error("TX_BD_WRAP_ERR",
        $sformatf(" Transmission:: WRAP violation: BD[%0d] has WR=1 but next BD=%0d",
                  prev_bd, tx_bd_idx))
    else
      `uvm_info("TX_BD_WRAP_OK",
        $sformatf(" Transmission:: BD advance OK: prev_bd=%0d present_bd=%0d WR=%0b",
                  prev_bd, tx_bd_idx, wrap),
        UVM_LOW)
  end
endtask

task check_wrap_rx_bd();
    `uvm_info("CHECK_WRAP_RX_BD",
    " Inside CHECK_WRAP_RX_BD task ", UVM_NONE)

  forever begin
    @(negedge r_vif.rx_dv);
    prev_bd = rx_bd_idx;
    wrap    = reg_model.rx_bd[prev_bd].WRAP.get_mirrored_value();

    `uvm_info(get_type_name(),
      $sformatf("Reception:: prev_bd = %0d wrap = %0d",
                prev_bd, wrap),
      UVM_NONE)

    if (wrap)
      rx_bd_idx = 0;
    else
      rx_bd_idx++;

    if (wrap && rx_bd_idx != 0)
      `uvm_error("TX_BD_WRAP_ERR",
        $sformatf("Reception:: WRAP violation: BD[%0d] has WR=1 but next BD=%0d",
                  prev_bd, rx_bd_idx))
    else
      `uvm_info("TX_BD_WRAP_OK",
        $sformatf("Reception:: BD advance OK: prev_bd=%0d present_bd=%0d WR=%0b",
                  prev_bd, rx_bd_idx, wrap),
        UVM_LOW)
  end
endtask

task check_tx_min_frame_length_via_BD_LEN_field();
     `uvm_info("CHECK_TX_MIN_FRAME_LENGTH_VIA_BD_LEN_FIELD"," INSIDE CHECK_TX_MIN_FRAME_LENGTH_VIA_BD_LEN_FIELD TASK",UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);
    tx_len = reg_model.tx_bd[0].LEN.get_mirrored_value();

    `uvm_info("TX_LEN",
      $sformatf("LEN field of TX_BD = %0d", tx_len),
      UVM_NONE)

    if (tx_len <= 4 && reg_model.tx_bd[0].RD.get_mirrored_value())
      `uvm_error("TX_LEN_ERR",
        $sformatf("TX violation: TX_EN asserted with LEN=%0d (must be > 4) with ready bit = %0b",
                  tx_len, reg_model.tx_bd[0].RD.get_mirrored_value()))
    else
      `uvm_info("TX_LEN_OK",
        $sformatf("TX started with valid frame length LEN=%0d", tx_len),
        UVM_LOW)
  end
endtask


      
task check_rx_short_frame_and_crc();
     `uvm_info("CHECK_RX_SHORT_FRAME_AND_CRC"," INSIDE CHECK_RX_SHORT_FRAME_AND_CRC TASK",UVM_LOW)
  forever begin
    @(posedge r_vif.rx_dv);
    minfl         = reg_model.packetlen.minfl.get_mirrored_value();
    rx_nibble_byte_cnt_task();
     

    `uvm_info("CHECK_RX_SHORT_FRAME_AND_CRC",
              $sformatf("RX Frame received:: frame_length in bytes = %0d bytes frame_length in bytes = %0d bytes minfl = %0d ",
                rx_nibble_cnt, rx_byte_cnt, minfl),
      UVM_LOW)

    if ((rx_byte_cnt < minfl) &&
        !reg_model.moder.recsmall.get_mirrored_value()) begin

      if (!reg_model.rx_bd[rx_bd_idx].SF.get_mirrored_value() ||
          !reg_model.rx_bd[rx_bd_idx].CRC.get_mirrored_value()) begin
        `uvm_error("RX_SHORT_FRAME_ERR",
          $sformatf(
            "RX Short Frame violation: len=%0d MINFL=%0d SF=%0b CRC=%0b",
            rx_byte_cnt, minfl,
            reg_model.rx_bd[rx_bd_idx].SF.get_mirrored_value(),
            reg_model.rx_bd[rx_bd_idx].CRC.get_mirrored_value()))
      end
      else begin
        `uvm_info("RX_SHORT_FRAME_OK",
          "RX short frame correctly flagged with SF=1 and CRC=1",
          UVM_LOW)
      end
    end
    else begin
      `uvm_info("RX_FRAME_OK",
        "RX frame length >= 64 bytes",
        UVM_LOW)
    end
  end
endtask


task check_rx_too_long_frame();
  `uvm_info("CHECK_RX_TOO_LONG_FRAME",
    "Inside CHECK_RX_TOO_LONG_FRAME task ",
    UVM_NONE)

  forever begin
    @(posedge r_vif.rx_dv);

     
    maxfl         = reg_model.packetlen.maxfl.get_mirrored_value();
    rx_nibble_byte_cnt_task();
    

    `uvm_info(get_type_name(),
              $sformatf("RX Frame received:: maxfl = %0d  frame_length in bytes = %0d bytes frame_length in nibble = %0d nibble",
                maxfl, rx_byte_cnt,rx_nibble_cnt),
      UVM_LOW)

    if (rx_byte_cnt > maxfl) begin
      if (!reg_model.rx_bd[rx_bd_idx].TL.get_mirrored_value())
        `uvm_error("RX_TL_ERR",
          $sformatf(
            "RX Too-Long frame: len=%0d MAXFL=%0d TL=0",
            rx_byte_cnt, maxfl))
      else
        `uvm_info("RX_TL_OK",
          "RX too-long frame correctly flagged with TL=1",
          UVM_LOW)
    end
    else begin
      `uvm_info("RX_FRAME_OK",
        "RX frame length < maxfl",
        UVM_LOW)
    end
  end
endtask


task check_rx_dribble_nibble();
  `uvm_info("CHECK_RX_DRIBBLE_NIBBLE"," INSIDE CHECK_RX_DRIBBLE_NIBBLE TASK",UVM_LOW)
  forever begin
    @(posedge r_vif.rx_dv);
  
    rx_nibble_byte_cnt_task();
    odd_nibble = (rx_nibble_cnt % 2);
    dn_bit     = reg_model.rx_bd[0].DN.get_mirrored_value();

    `uvm_info(get_type_name(),
      $sformatf("RX DN Check :: nibbles=%0d bytes=%0d odd=%0b DN=%0b ",
                rx_nibble_cnt, rx_byte_cnt, odd_nibble, dn_bit),
      UVM_LOW)

    if (odd_nibble && !dn_bit) begin
      `uvm_error("RX_DN_ERR",
        $sformatf(
          "RX Dribble Nibble violation: odd nibble count (%0d) but DN=0 ",
          rx_nibble_cnt))
    end
    else if (!odd_nibble && dn_bit) begin
      `uvm_error("RX_DN_ERR",
        $sformatf(
          "RX Dribble Nibble violation: even nibble count (%0d) but DN=1",
          rx_nibble_cnt))
    end
    else begin
      `uvm_info("RX_DN_OK",
        "RX Dribble Nibble correctly reported",
        UVM_LOW)
    end
  end
endtask


task check_tx_late_collision_lc_bit();
  `uvm_info("CHECK_TX_LATE_COLLISION_LC_BIT",
    "Inside CHECK_TX_LATE_COLLISION_LC_BIT task ",
    UVM_NONE)

  forever begin
    @(posedge t_vif.tx_en);
   
    collvalid     = reg_model.collconf.collvalid.get_mirrored_value();
    lc_bit        = reg_model.tx_bd[tx_bd_idx].LC.get_mirrored_value();
    tx_nibble_byte_cnt_task();
    `uvm_info(get_type_name(),
              $sformatf("collvalid = %0d tx_nibble_cnt = %0d tx_byte_cnt = %0d lc_bit = %0d col = %0d ",
                collvalid, tx_nibble_cnt,tx_byte_cnt, lc_bit, r_vif.col),
      UVM_NONE)

    if (r_vif.col) begin
      `uvm_info(get_type_name(),
        $sformatf(
          "Collision detected :: tx_bytes=%0d COLLVALID=%0d",
          tx_byte_cnt, collvalid),
        UVM_LOW)

      if (tx_byte_cnt > collvalid) begin
        if (!lc_bit) begin
          `uvm_error("TX_LATE_COLL_ERR",
            $sformatf(
              "Late Collision violation: collision at %0d bytes (> %0d) but LC=0 ",
              tx_byte_cnt, collvalid))
        end
        else begin
          `uvm_info("TX_LATE_COLL_OK",
            $sformatf(
              "Late Collision correctly flagged: LC=1 (collision at %0d bytes)",
              tx_byte_cnt),
            UVM_LOW)
        end
      end
      else
        `uvm_info("TX_COLL_OK",
          "tx_byte_cnt < collvalid",
          UVM_NONE)
    end
    else
      `uvm_info("TX_NO_COLL",
        "No collision is received during transmission",
        UVM_NONE)
  end
endtask


task check_tx_retry_limit_and_rl_bit();
      `uvm_info("CHECK_TX_RETRY_LIMIT_AND_RL_BIT"," INSIDE CHECK_TX_RETRY_LIMIT_AND_RL_BIT TASK",UVM_LOW)
  forever begin
    @(posedge t_vif.tx_en);
    retry_cnt = 0;
    maxret    = reg_model.collconf.maxret.get_mirrored_value();
    rd_bit    = reg_model.tx_bd[0].RD.get_mirrored_value();

    `uvm_info("TX_RTRY",
      $sformatf("TX started: MAXRET=%0d ", maxret),
      UVM_LOW)

    while (t_vif.tx_en) begin
      @(posedge t_vif.clk);
      if (r_vif.col) begin
        retry_cnt++;
        `uvm_info("TX_RTRY",
          $sformatf("Collision detected, retry_cnt=%0d", retry_cnt),
          UVM_LOW)
      end
    end

    rl_bit = reg_model.tx_bd[tx_bd_idx].RL.get_mirrored_value();

    if (retry_cnt >= (maxret + 1)) begin
      if (!rl_bit)
        `uvm_error("TX_RL_ERR",
          $sformatf(
            "Retry limit exceeded: retries=%0d MAXRET=%0d but RL=0",
            retry_cnt, maxret))
      else
        `uvm_info("TX_RL_OK",
          $sformatf(
            "Retry limit hit: retries=%0d MAXRET=%0d RL=1 TX aborted",
            retry_cnt, maxret),
          UVM_LOW)

      if (rd_bit)
        `uvm_error("TX_ABORT_ERR",
          "TX abort expected but RD still set (BD not released)")
      else
        `uvm_info("TX_ABORT_OK",
          "BD released (RD=0) after TX abort",
          UVM_LOW)
    end
    else begin
      if (rl_bit) begin
        `uvm_error("TX_RL_SPURIOUS",
          $sformatf(
            "RL set prematurely: retries=%0d MAXRET=%0d ",
            retry_cnt, maxret))
      end
      else begin
        `uvm_info("TX_RTRY_OK",
          $sformatf("Retries within limit, RL = %0d", rl_bit),
          UVM_LOW)
      end
    end
  end
endtask


task check_rx_pause_frame_rxc_interrupt();
 
  bit rxflow;
  bit passall;
  bit rxc_int;
 `uvm_info("CHECK_RX_PAUSE_FRAME_RXC_INTERRUPT"," INSIDE CHECK_RX_PAUSE_FRAME_RXC_INTERRUPT TASK",UVM_LOW)
  forever begin
    @(negedge r_vif.rx_dv);

    rxflow  = reg_model.ctrlmoder.rxflow.get_mirrored_value();
    passall = reg_model.ctrlmoder.passall.get_mirrored_value();
    rxc_int = reg_model.int_source.rxc.get_mirrored_value();
    cf_bit  = reg_model.rx_bd[rx_bd_idx].CF.get_mirrored_value();

    `uvm_info("RX_PAUSE_CHECK",
      $sformatf(
        "RX end: RXFLOW=%0b PASSALL=%0b CF=%0b RXC=%0b",
        rxflow, passall, cf_bit, rxc_int),
      UVM_LOW)

    if (cf_bit) begin
      if (rxflow) begin
        if (!rxc_int)
          `uvm_error("RXC_ERR",
            "PAUSE frame received with RXFLOW=1 but RXC interrupt not set")
        else
          `uvm_info("RXC_OK",
            "RXC interrupt correctly set on PAUSE frame (RXFLOW=1)",
            UVM_LOW)
      end
      else begin
        if (rxc_int)
          `uvm_error("RXC_ERR",
            "RXC interrupt asserted while RXFLOW=0 (illegal)")
        else
          `uvm_info("RXC_OK",
            "RXC correctly not set when RXFLOW=0",
            UVM_LOW)
      end
    end
    else begin
      `uvm_info("RXC_OK",
        "cf_bit not set",
        UVM_LOW)
    end
  end
endtask
        
endclass
`endif




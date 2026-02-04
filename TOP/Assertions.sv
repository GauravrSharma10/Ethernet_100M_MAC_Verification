module mii_assert_module (clk,rst,m_wb_dat_w,m_wb_dat_r,m_wb_adr,m_wb_sel,m_wb_we,m_wb_cyc,m_wb_stb,m_wb_ack,m_wb_err,s_wb_dat_w,s_wb_dat_r,s_wb_adr,s_wb_sel,s_wb_we,s_wb_cyc,s_wb_stb,s_wb_ack,s_wb_err,tx_en,tx_d,tx_er,rx_d,rx_dv,rx_er,col,crs);
  input reg clk,rst;
  input bit tx_en;
  input bit tx_er;
  input bit[3:0] tx_d;
  input bit[3:0] rx_d;
  input bit rx_dv;
  input bit rx_er;
  input bit col;
  input bit crs;
  
  input bit [31:0] m_wb_adr;
  input bit [31:0] m_wb_dat_w;
  input bit [31:0] m_wb_dat_r;
  input bit        m_wb_we;
  input bit [3:0]  m_wb_sel;
  input bit        m_wb_stb;
  input bit        m_wb_cyc;
  input bit        m_wb_ack;
  input bit        m_wb_err;
  
  input bit [31:0] s_wb_adr;
  input bit [31:0] s_wb_dat_w;
  input bit [31:0] s_wb_dat_r;
  input bit        s_wb_we;
  input bit [3:0]  s_wb_sel;
  input bit        s_wb_stb;
  input bit        s_wb_cyc;
  input bit        s_wb_ack;
  input bit        s_wb_err;


//ASSERTION_1 : During reset, TXD, TX_EN, and TX_ER(from transmit end) ,RX_DV, RXD and RX_ER(from receie end,COL,CRS shall remain deasserted.

property eth_reset_valid_signals_low_check;
  @(posedge clk)
  (rst) |-> (
      tx_en == 1'b0 &&
      tx_er == 1'b0 &&
      tx_d   == '0   &&
      rx_dv == 1'b0 &&
      rx_d == 1'b0 &&
      rx_er  == '0   &&
      col   == 1'b0 &&
      crs   == 1'b0
  );
endproperty

 ETH_RESET_VALID_SIGNALS_LOW_CHECK :
  assert property (eth_reset_valid_signals_low_check)begin
  //  $display("ASSERTION PASSED FOR ETH_RESET_VALID_SIGNALS_LOW_CHECK");
  end
else
  `uvm_error("ETH_RESET_ASSERT",
    "One or more Ethernet MAC signals not LOW during reset");

// ASSERTION_2 : CRS shall be asserted by the PHY when either the transmit or receive medium is nonidle. 
  
  property crs_asserted_when_medium_active_check;
  @(posedge clk)
    disable iff (rst)
    crs |-> ##[0:$] (tx_en);
endproperty
  
  CRS_ASSERTED_WHEN_MEDIUM_ACTIVE_CHECK :
  assert property (crs_asserted_when_medium_active_check)begin
   // $display("ASSERTION PASSED FOR CRS_ASSERTED_WHEN_MEDIUM_ACTIVE_CHECK");
  end
else
  `uvm_error("CRS_ASSERT",
    "CRS not asserted when TX or RX medium is non-idle");
  
 
// ASSERTION_3 :The PHY shall ensure that CRS remains asserted throughout the duration of a collision condition

property crs_asserted_throughout_collision_check;
  @(posedge clk)
  disable iff (rst)
  col |-> (crs == 1'b1 throughout col);
endproperty
  
  CRS_ASSERTED_THROUGHOUT_COLLISION_CHECK  :
    assert property (crs_asserted_throughout_collision_check)begin
     // $display("ASSERTION PASSED FOR CRS_ASSERTED_THROUGHOUT_COLLISION_CHECK");
  end 
   
else
  `uvm_error("CRS_ASSERT",
    "CRS not asserted when TX or RX medium is non-idle");


// ASSERTION_4 : COL is asserted whenever tx_en and rx_dv is asserted simultaneously.

property  collision_assertion_check;
  @(posedge clk)
  disable iff (rst)
  col |-> (tx_en && rx_dv);
endproperty

COLLISION_ASSERTION_CHECK :
      assert property (collision_assertion_check)begin
   // $display("ASSERTION PASSED FOR COLLISION_ASSERTION_CHECK");
      end
else
  `uvm_error("COL_ASSERT",
    "COL not asserted when TX and RX both are active (collision condition)");

// ASSERTION_5 : RX_DV must encompass the frame,starting no later than the Start Frame Delimiter (SFD) and excluding any End-of-Frame delimiter. 

property rx_dv_encompasses_frame_check;
  @(posedge clk)
  disable iff (rst)
  rx_d |-> $past(rx_dv) && $stable(rx_dv);
endproperty

RX_DV_ENCOMPASSES_FRAME_CHECK :
        assert property (rx_dv_encompasses_frame_check)begin
// $display("ASSERTION PASSED FOR RX_DV_ENCOMPASSES_FRAME_CHECK");
        end
else
  `uvm_error("RX_DV_ASSERT",
    "RX_DV does not correctly encompass the Ethernet receive frame");
  

// ASSERTION_6 : TX_EN shall be asserted by the Reconciliation sublayer synchronously with the first nibble of the preamble and shall remain stable throughout a valid transmit frame.

property tx_en_encompasses_frame_check;
  @(posedge clk)
  disable iff (rst)
  $rose(tx_d) |-> tx_en;
endproperty

TX_EN_ENCOMPASSES_FRAME_CHECK :
          assert property (tx_en_encompasses_frame_check)begin
// $display("ASSERTION PASSED FOR TX_EN_ENCOMPASSES_FRAME_CHECK");
          end
else
  `uvm_error("TX_EN_ASSERT",
    "TX_EN does not correctly encompass the Ethernet receive frame");


// // Assertion_7 : RX_ER shall be asserted for one or more RX_CLK periods to indicate to the Reconciliation sublayer that an error  was detected somewhere in the frame presently being transferred from the PHY to the Reconciliation sublayer.
            
property rx_er_duration_check;
  @(posedge clk)
  disable iff (rst)
   $rose(rx_er) |-> rx_er[*1:$];
endproperty

RX_ER_DURATION_CHECK :
    assert property (rx_er_duration_check)begin
//$display("ASSERTION PASSED FOR RX_ER_ASSERTION_DURATION_CHECK");      
    end
else
  `uvm_error("RX_ER_ASSERT",
    "RX_ER is not asserted for one or more RX_CLK periods");

 // Assertion_8 : When TX_ER is asserted for one or more TX_CLK periods while TX_EN is also asserted, the PHY shall emit one or more symbols that are not part of the valid data or delimiter set somewhere in the frame being transmitted. The relative position of the error within the frame need not be preserved
      
property tx_er_duration_check;
  @(posedge clk)
  disable iff (rst)
  $rose(tx_er) |-> tx_er[*1:$];
endproperty

TX_ER_DURATION_CHECK :
      assert property (tx_er_duration_check)begin
//$display("ASSERTION PASSED FOR TX_ER_DURATION_CHECK");      
    end
else
  `uvm_error("TX_ER_ASSERT",
    "TX_ER was not asserted for at least one TX_CLK cycle");

// Assertion_9 : While RX_DV is deasserted, the PHY may provide a False Carrier indication by asserting the RX_ER signal for at least one cycle of the RX_CLK while driving the appropriate value onto RXD<3:0> as 1110

property false_carrier_check;
  @(posedge clk)
  disable iff (rst)
  (!rx_dv && rx_er && rx_d == 4'b1110)
  |-> ##1 (!rx_dv && rx_er && rx_d == 4'b1110);
endproperty

FALSE_CARRIER_CHECK :
        assert property (false_carrier_check)begin
//  $display("ASSERTION PASSED FOR FALSE_CARRIER_CHECK");           
        end
else
  `uvm_error("FALSE_CARRIER_ASSERT",
    "RX_ER not held for >= 1 full RX_CLK cycle with RXD=4'b1110 while RX_DV=0");

//ASSERTION_10 : TXD shall output the IDLE pattern(IPG) whenever TX_EN is low and TX_ER is also low.
property txd_idle_when_tx_disabled_check;
  @(posedge clk)
  disable iff (rst)
  (!tx_en && !tx_er) |-> (tx_d == 4'b0000 || tx_d == 4'b1);
endproperty

TXD_IDLE_WHEN_TX_DISABLED_CHECK :
          assert property (txd_idle_when_tx_disabled_check)begin
          //  $display("ASSERTION PASSED FOR TXD_IDLE_WHEN_TX_DISABLED_CHECK");
         end
else
  `uvm_error("TXD_IDLE_ASSERT",
    "TXD not driving IDLE pattern (0000) when TX_EN and TX_ER are low");
            
// ASSERTION_11 : During reset, all wishbone interface (master and slave) signals should remain deasserted.
 property wb_reset_low;
  @(posedge clk)
  rst |-> (
    !m_wb_cyc && !m_wb_stb && !m_wb_ack && !m_wb_err && 
    !m_wb_dat_w && !m_wb_dat_r && !m_wb_adr && !m_wb_sel && !m_wb_we &&      !s_wb_dat_w && !s_wb_dat_r && !s_wb_adr && !s_wb_sel && !s_wb_we && !s_wb_cyc && !s_wb_stb && !s_wb_ack && !s_wb_err
  );
endproperty

WB_RESET_LOW :
            assert property (wb_reset_low)begin
            //  $display("ASSERTION PASSED FOR WB_RESET_LOW");
            end
else `uvm_error("WB_RESET", "Wishbone signals not LOW during reset");         
            
// ASSERTION_12 : CYC must be asserted before or with STB ,CYC must remain high until STB deasserts for wishbone mster interface.          
            
property master_wb_cyc_stb_order;
  @(posedge clk)
  disable iff (rst)
  m_wb_stb  |-> (m_wb_cyc) throughout m_wb_stb;
endproperty

MASTER_WB_CYC_STB_ORDER :
assert property (master_wb_cyc_stb_order)begin
//  $display("ASSERTION PASSED FOR MASTER WB_CYC_STB_ORDER");
            end
  else `uvm_error("MASTER_WB_PROTOCOL", "STB asserted without CYC");          
            
//ASSERTION_13 : CYC must be asserted before or with STB ,CYC must remain high until STB deasserts for wishbone slave interface.          
            
property slave_wb_cyc_stb_order;
  @(posedge clk)
  disable iff (rst)
  s_wb_stb  |-> (s_wb_cyc) throughout s_wb_stb;
endproperty

SLAVE_WB_CYC_STB_ORDER :
assert property (slave_wb_cyc_stb_order)begin
 // $display("ASSERTION PASSED FOR SLAVE WB_CYC_STB_ORDER");
            end
  else `uvm_error("SLAVE_WB_PROTOCOL", "STB asserted without CYC");  
  
// ASSERTION_14 : ACK only when both CYC and STB are high for wishbone master interface.            
  property master_wb_ack_only_with_cyc_stb;
  @(posedge clk)
  disable iff (rst)
 m_wb_ack |-> (m_wb_cyc && m_wb_stb) throughout m_wb_ack;

endproperty

MASTER_WB_ACK_ONLY_WITH_CYC_STB :
assert property (master_wb_ack_only_with_cyc_stb)begin
  //$display("ASSERTION PASSED FOR  MASTER WB_ACK_ONLY_WITH_CYC_STB");
            end
  else `uvm_error("MASTER_WB_PROTOCOL", "ACK without CYC & STB");
  
 // ASSERTION_15 : ACK only when both CYC and STB are high for wishbone slave interface.
  
       sequence s_wb_cyc_stb;
          s_wb_cyc && s_wb_stb;
       endsequence
  
  
  property slave_wb_ack_only_with_cyc_stb;
  @(posedge clk)
  disable iff (rst)
    s_wb_ack |-> s_wb_cyc_stb;

endproperty

SLAVE_WB_ACK_ONLY_WITH_CYC_STB :
assert property (slave_wb_ack_only_with_cyc_stb)begin
 // $display("ASSERTION PASSED FOR SLAVE WB_ACK_ONLY_WITH_CYC_STB");
            end
  else `uvm_error("SLAVE_WB_PROTOCOL", "ACK without CYC & STB");
   
  // ASSERTION_16 : Only one response at a time (ACK or ERR) for wishbone master interface.  
  property master_wb_single_response;
  @(posedge clk)
  disable iff (rst)
    !(m_wb_ack && m_wb_err);
endproperty

MASTER_WB_SINGLE_RESPONSE :
  assert property (master_wb_single_response)begin
  // $display("ASSERTION PASSED FOR MASTER WB_SINGLE_RESPONSE");
            end
  else `uvm_error("MASTER_WB_PROTOCOL", "ACK and ERR asserted together");   
  
  // ASSERTION_17 : Only one response at a time (ACK or ERR) for wishbone slave interface.  
  property slave_wb_single_response;
  @(posedge clk)
  disable iff (rst)
    !(s_wb_ack && s_wb_err);
endproperty

SLAVE_WB_SINGLE_RESPONSE :
    assert property (slave_wb_single_response)begin
     //  $display("ASSERTION PASSED FOR SLAVE WB_SINGLE_RESPONSE");
            end
      else `uvm_error("SLAVE_WB_PROTOCOL", "ACK and ERR asserted together");   
  
// ASSERTION_18 :  addr,dat_w,sel,we must remain valid during stb assertion for master interface.
  property master_wb_stb_signal_stability;
  @(posedge clk)
  disable iff (rst)
   m_wb_stb |->  
    ! $isunknown(m_wb_adr) &&
    ! $isunknown(m_wb_dat_w) &&
    ! $isunknown(m_wb_sel) &&
    ! $isunknown(m_wb_we);
endproperty

MASTER_WB_STB_SIGNAL_STABILITY :
  assert property (master_wb_stb_signal_stability)begin
  //  $display("ASSERTION PASSED FOR MASTER_WB_STB_SIGNAL_STABILITY");
  end
    else `uvm_error("MASTER_WB_PROTOCOL", "WB signals invalid while STB high");           
 
// ASSERTION_19 :  addr,dat_w,sel,we must remain valid during stb assertion for slave interface.    
    
    property slave_wb_stb_signal_stability;
  @(posedge clk)
  disable iff (rst)
   s_wb_stb |->  
      ! $isunknown(s_wb_adr) &&
      ! $isunknown(s_wb_dat_r) &&
      ! $isunknown(s_wb_sel) &&
      ! $isunknown(s_wb_we);
endproperty

SLAVE_WB_STB_SIGNAL_STABILITY :
  assert property (slave_wb_stb_signal_stability)begin
 //  $display("ASSERTION PASSED FOR SLAVE_WB_STB_SIGNAL_STABILITY");
  end
    else `uvm_error("SLAVE_WB_PROTOCOL", "WB signals invalid while STB high");           
 // ASSERTION_20 :  X/Z check on DAT_O during READ ACK for wishbone master interface
  property master_wb_no_xz_on_read_data;
  @(posedge clk)
  disable iff (rst)
  (m_wb_ack && !m_wb_we) |-> (!$isunknown(m_wb_dat_r));
endproperty

MASTER_WB_NO_XZ_ON_READ :
    assert property (master_wb_no_xz_on_read_data)begin
     //  $display("ASSERTION PASSED FOR MASTER_WB_NO_XZ_ON_READ");
    end
      else `uvm_error("MASTER_WB_PROTOCOL", "X/Z detected on read data");
            
// ASSERTION_21 :  X/Z check on DAT_I during READ ACK for wishbone SLAVE interface
  property slave_wb_no_xz_on_read_data;
  @(posedge clk)
  disable iff (rst)
    (s_wb_ack && !s_wb_we) |-> (!$isunknown(s_wb_dat_r));
endproperty

SLAVE_WB_NO_XZ_ON_READ :
    assert property (slave_wb_no_xz_on_read_data)begin
    //   $display("ASSERTION PASSED FOR SLAVE_WB_NO_XZ_ON_READ");
    end
      else `uvm_error("SLAVE_WB_PROTOCOL", "X/Z detected on read data");  
                      
            
          
  endmodule

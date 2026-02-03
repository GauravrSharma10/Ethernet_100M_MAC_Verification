
///////////////////////////////////////////////////////////////////////////////////
// Filename: tx_phy_monitor.sv
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
// Description: Tx Phy Monitor component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef TX_PHY_MONITOR_SV
`define TX_PHY_MONITOR_SV

`define mvif vif.mon_cb

class tx_phy_monitor extends uvm_monitor;
  `uvm_component_utils(tx_phy_monitor)

  virtual phy_tx_interface vif;
  uvm_analysis_port #(phy_seq_item) transaction_aport;
  phy_seq_item tr;

  
  bit enable_preamble = 1;

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "tx_phy_monitor", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "tx_phy_monitor", uvm_component parent = null);
    super.new(name, parent);
    transaction_aport = new("transaction_aport", this);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : build_phase
  // argument : uvm_phase phase
  // description : Build phase to get virtual interface
  ////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual phy_tx_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for tx_phy_monitor")
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : run_phase
  // argument : uvm_phase phase
  // description : Run phase for monitoring signals
  ////////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);

    //forever begin
      //fork
        sample();
			//	end
        //@(posedge `mvif.col);
      //join_any
      //disable
  endtask
	 
      task sample();
			  bit jam_flag;
        forever begin
				  sample_preamble();
          fork 
            sample_data();
						begin
              wait(`mvif.col);
							jam_flag = 1;
						end
          join_any
          disable fork;
					if(jam_flag)begin
            sample_jam();
						jam_flag= 0;
				  end
        end
      endtask
        
      task sample_data();
        byte txd_q[$];   // temp storage to collect frame bytes
        bit [7:0]assembled_byte ; // temp variable for byte alignment
        bit in_frame,nibble_phase;
        while(`mvif.tx_en) begin
          @(`mvif);

          // Detect start of frame
          if (`mvif.tx_en && !in_frame) begin
            in_frame   = 1;
            txd_q.delete();
          end

         // Collect nibbles while tx_en is high
          if (`mvif.tx_en && in_frame) begin
            if (!nibble_phase) begin
              // Lower nibble
              assembled_byte[3:0] = {<<{`mvif.txd}};
							`uvm_info(get_name(),$sformatf("assembled lower nibble : %0h original nibble : %0h",assembled_byte[3:0],`mvif.txd),UVM_NONE)
              nibble_phase = 1;
            end
            else begin
              // Upper nibble 
              assembled_byte[7:4] = {<<{`mvif.txd}};
							`uvm_info(get_name(),$sformatf("assembled higher nibble : %0h original nibble : %0h",assembled_byte[7:4],`mvif.txd),UVM_NONE)
							`uvm_info(get_name(),$sformatf("assembled byte : %0h",assembled_byte),UVM_NONE)
              txd_q.push_back(assembled_byte);
              nibble_phase = 0;
            end
          end

          // Detect end of frame
          if (!`mvif.tx_en && in_frame) begin
            in_frame = 0;
            if(process_frame(txd_q))
              `uvm_info(get_name(),"reception complete",UVM_NONE)
            else
              `uvm_error(get_name,"frame dropped")
          end
        end
      endtask
            
task sample_preamble();
  int nibble_cnt = 0;
  logic [3:0] nibble;

    
    @(posedge `mvif.tx_en);
         if(4'h5 != `mvif.txd)
				   `uvm_error(get_name(),$sformatf("incorrect preamble : %0h %0d ",`mvif.txd,nibble_cnt))
			   else
					 `uvm_info(get_name(),$sformatf("correct preamble : %0h %0d",`mvif.txd,nibble_cnt),UVM_NONE)
				nibble_cnt++;

    do begin
      @(`mvif);
      if(4'h5 != `mvif.txd)
        `uvm_error(get_name(),$sformatf("incorrect preamble : %0h %0d",`mvif.txd,nibble_cnt))
       else
         `uvm_info(get_name(),$sformatf("correct preamble : %0h %0d",`mvif.txd,nibble_cnt),UVM_NONE)
      nibble_cnt++;
    end
    while(nibble_cnt < 15);
    
    @(`mvif);
    if(nibble_cnt == 15)begin
      if(4'hd != `mvif.txd)
        `uvm_error(get_name,$sformatf("incorrect sfd : %0h",`mvif.txd))
       else
         `uvm_info(get_name(),$sformatf("correct sfd : %0h",`mvif.txd),UVM_NONE)
      nibble_cnt++;            
    end
    
    @(`mvif);

    if(nibble_cnt == 16)begin
      if(4'h5 != `mvif.txd)
        `uvm_error(get_name(),$sformatf("incorrect preamble : %0h %0d ",`mvif.txd,nibble_cnt))
       else
         `uvm_info(get_name(),$sformatf("correct preamble : %0h %0d",`mvif.txd,nibble_cnt),UVM_NONE)
      nibble_cnt = 0;
    end              
endtask
            
task sample_jam();
  int nibble_count = 0;

		  do begin
			@(`mvif);
			if(4'h9 != `mvif.txd)
				`uvm_error(get_name(),$sformatf("incorrect jam : %0h %0d",`mvif.txd,nibble_count))
		  else
				`uvm_info(get_name(),$sformatf("correct jam : %0h %0d",`mvif.txd,nibble_count),UVM_NONE)
			nibble_count++;
	  	end
	  	while(nibble_count < 9);       
			 
	    if(`mvif.tx_en)
			  `uvm_error(get_name(),"after the completion of jam sequence still tx_en is high")
	endtask
    

  function bit process_frame(byte txd_q[$]);
    int idx;
    tr = phy_seq_item::type_id::create("tr");



    // Minimum check:64 bytes min packet size
    if (txd_q.size() < 64) begin
      `uvm_error(get_name(),"Frame too short, dropping")
      return 0;
    end// if(txd_q.size())

    // ------------------------------------------------
    // Destination Address (6 bytes)
    // ------------------------------------------------
    for (int i = 0; i < 6; i++)
      tr.dest_addr.push_back(txd_q[idx++]);

    // ------------------------------------------------
    // Source Address (6 bytes)
    // ------------------------------------------------
    for (int i = 0; i < 6; i++)
        tr.src_addr.push_back(txd_q[idx++]);

    tr.length_type[15:8] = txd_q[idx++];
    tr.length_type[7:0] = txd_q[idx++];

    // ------------------------------------------------
    // Payload (exclude last 4 bytes = CRC)
    // ------------------------------------------------
    for (int i = idx; i < txd_q.size() - 4; i++)
      tr.payload.push_back(txd_q[i]);

    // ------------------------------------------------
    // CRC / FCS (last 4 bytes of frame)
    // ------------------------------------------------
    for (int i = 0; i < 4; i++)
      tr.crc.push_back(txd_q[txd_q.size() - 4 + i]);
    
    // ------------------------------------------------
    // write
    // ------------------------------------------------
    `uvm_info(get_name(),$sformatf("received frame :%s",tr.sprint()),UVM_NONE)

    transaction_aport.write(tr);
    return 1;
  endfunction

endclass

`endif


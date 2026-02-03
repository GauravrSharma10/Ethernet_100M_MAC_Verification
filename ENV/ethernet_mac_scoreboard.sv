///////////////////////////////////////////////////////////////////////////////////
// Filename: ethernet_mac_scoreboard.sv
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
// Description: Scoreboard component.
// Dependencies:
// Notes:
//////////////////////////////////////////////////////////////////////////////////

`ifndef ETHERNET_MAC_SCOREBOARD_SV
`define ETHERNET_MAC_SCOREBOARD_SV

`uvm_analysis_imp_decl(_wishbone)
`uvm_analysis_imp_decl(_phy)

typedef byte byte_que[$];

class ethernet_mac_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ethernet_mac_scoreboard)

  uvm_analysis_imp_wishbone #(wishbone_seq_item, ethernet_mac_scoreboard) wishbone_item_imp;
  uvm_analysis_imp_phy #(phy_seq_item, ethernet_mac_scoreboard) phy_item_imp;
  eth_reg_block reg_blk_h;
  uvm_reg_data_t read_data;
	byte_que wishbone_data;
  byte_que phy_data;
  byte_que exp_que[$];
  byte_que act_que[$];

  ////////////////////////////////////////////////////////////////////////
  // function name : new
  // argument : string name = "ethernet_mac_scoreboard", uvm_component parent = null
  // description : Class constructor
  ////////////////////////////////////////////////////////////////////////
  function new(string name = "ethernet_mac_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    wishbone_item_imp = new("wishbone_item_imp", this);
    phy_item_imp = new("phy_item_imp", this);
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : write_wishbone
  // argument : wishbone_seq_item item
  // description : Analysis implementation write function
  ////////////////////////////////////////////////////////////////////////
  function void write_wishbone(wishbone_seq_item item);
    // Scoreboard logic
		wishbone_seq_item item_h;
		$cast(item_h,item.clone);
		item_h.set_name("item_h");
		`uvm_info(get_name,$sformatf("wishbone transaction from scoreboard : %s",item_h.sprint()),UVM_NONE)
    read_data = reg_blk_h.tx_bd[0].get_mirrored_value();
    prep_exp_wishbone(item_h,read_data[31:16]);
		foreach(wishbone_data[i])begin
		  `uvm_info(get_name(),$sformatf("wishbone exp data %0d : %0h",i,wishbone_data[i]),UVM_NONE)
	  end
		exp_que.push_back(wishbone_data);
		wishbone_data.delete();
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : write_wishbone
  // argument : phy_seq_item item
  // description : Analysis implementation write function
  ////////////////////////////////////////////////////////////////////////
  function void write_phy(phy_seq_item item);
		phy_seq_item item_h;
		$cast(item_h,item.clone());
		item_h.set_name("item_h");
		`uvm_info(get_name,$sformatf("phy transaction from scoreboard : %s",item_h.sprint()),UVM_NONE)
	  prep_exp_phy(item_h);	

		foreach(phy_data[i])begin
		  `uvm_info(get_name(),$sformatf("phy exp data %0d : %0h",i,phy_data[i]),UVM_NONE)
    end
		act_que.push_back(phy_data);
		phy_data.delete();
  endfunction

  ////////////////////////////////////////////////////////////////////////
  // function name : write_wishbone
  // argument : phy_seq_item item
  // description : Analysis implementation write function
  ////////////////////////////////////////////////////////////////////////
  function void prep_exp_wishbone(wishbone_seq_item item, int length);
	  byte temp_q[$];
    temp_q = {>>8{item.data_q}};

		if((item.data_q.size()*4) != length)
		  if(temp_q.size() > 0) void'(temp_q.pop_front());
	  for(int i = 0; i < length && temp_q.size() > 0 ; i++)begin
		  wishbone_data.push_back(temp_q.pop_front());
		end

  endfunction

	function void prep_exp_phy(phy_seq_item item);
	  while(item.dest_addr.size > 0)begin
		  phy_data.push_back(item.dest_addr.pop_front());
		end
  
	  while(item.src_addr.size > 0)begin
		  phy_data.push_back(item.src_addr.pop_front());
		end

		phy_data.push_back(item.length_type[16:8]);
		phy_data.push_back(item.length_type[7:0]);

	  while(item.payload.size > 0)begin
		  phy_data.push_back(item.payload.pop_front());
		end

		if(!0)begin
		  while(item.crc.size > 0)begin
		    phy_data.push_back(item.crc.pop_front());
		  end
		end
	endfunction

	task run_phase(uvm_phase phase);
	  byte_que wishbone;
	  byte_que phy;
		forever begin
  	  wait(exp_que.size > 0 && act_que.size > 0);
		    wishbone = exp_que.pop_front();
		    phy = act_que.pop_front();
		    if(wishbone.size() != phy.size())begin
			    `uvm_error(get_name(),$sformatf("invalid sizes for comparision : exp size : %0d act size : %0d",exp_que.size(),act_que.size()))
			  end
		  	foreach(wishbone[i])begin
			    if(wishbone[i] != phy[i])begin
				    `uvm_error(get_name,$sformatf("exp : %0h act : %0h ",wishbone[i],phy[i]));
			  	end
			  	else
				    `uvm_info(get_name,$sformatf("exp : %0h act : %0h",wishbone[i],phy[i]),UVM_NONE);
		  	end//foreach
		end
	endtask
endclass

`endif


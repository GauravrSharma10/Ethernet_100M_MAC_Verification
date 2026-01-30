class reg_seq extends uvm_sequence#(wishbone_seq_item);
  wishbone_seq_item req;
  eth_reg_block reg_model;
  uvm_status_e   status;
  uvm_reg_data_t read_data;
  `uvm_object_utils(reg_seq)
  
  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  task body();
    wishbone_seq_item abc;
    `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
  //  `uvm_do(abc);
    if(!uvm_config_db#(eth_reg_block) :: get(uvm_root::get(), "", "reg_model", reg_model))
      `uvm_fatal(get_type_name(), "reg_model is not set at top level");
    
//     reg_model.tx_bd[2].read(status,read_data);
//    // reg_model.int_source.write(status,24'h1223_3456_789A);
//     reg_model.moder.read(status,read_data);
//     $display("read data : %0h",read_data);
//     reg_model.int_mask.read(status,read_data);
//     $display("read data : %0h",read_data);
//     reg_model.tx_bd_num.write(status,32'h40);

    reg_model.moder.write(status,'d2);
    //reg_model.int_mask.write(status,'d1);
  //  reg_model.int_source.write(status,'d1);
  //  reg_model.int_mask.read(status,read_data);
    //reg_model.moder.nopre.read(status,read_data);
    reg_model.tx_bd_num.read(status,read_data);
    $display("read data : %0h",read_data);
    reg_model.tx_bd[0].write(status,64'hABCD_EDFD_00AB_E000);
    read_data = reg_model.tx_bd[0].get_mirrored_value();
    //$display($time,"mirrored value : %0h",read_data);
		#1000;
    //reg_model.tx_bd[0].write(status,64'h0000_1234_00AB_C000);
   // reg_model.int_mask.read(status,read_data);
    //reg_model.tx_bd[2].write(status,64'hABCD_EDFD_00AB_C000);
    //reg_model.tx_bd[3].write(status,64'hABCD_EDFD_00AB_C000);

	//	#1600;

 //   reg_model.int_source.read(status,read_data);
  //  reg_model.int_source.write(status,'d1);

	//	#1600;

   // reg_model.int_source.read(status,read_data);
   // reg_model.int_source.write(status,'d1);
   // reg_model.int_source.read(status,read_data);
	//	#1600;

    //reg_model.int_source.read(status,read_data);
//    reg_model.tx_bd[0].write(status,64'hABCD_EDFD_0064_C800);
    
//     reg_model.tx_bd[0].write(status,32'hABCD_ABCD);
//     reg_model.tx_bd[0].read(status,read_data);
//     reg_model.tx_bd[1].read(status,read_data);
    $display($time,"read data : %0h",read_data);
    
    //reg_model.moder.write(status,32'h0042_8002);
    //reg_model.moder.write(status,32'h0042_8002);
    //reg_model.moder.write(status,32'h0042_A002);
   // reg_model.moder.write(status,32'h0000_0002);

//     reg_model.rx_bd[0].write(status,64'hABCD_EDFD_0064_C800);
//     reg_model.rx_bd[0].read(status,read_data);

//     reg_model.mod_reg.control_reg.mirror(status,UVM_CHECK);
//    $display("Mirror DATA Status :%p", status);
//     reg_model.mod_reg.control_reg.write(status, 32'h1234_1234);
//     $display("status : %d",status);
// $display("READ Initialized"); 
//     reg_model.mod_reg.control_reg.read(status, read_data);
//    $display("READ DATA :%p", read_data);
//     reg_model.mod_reg.control_reg.mirror(status,UVM_CHECK);
//    $display("Mirror DATA Status :%p", status);
//     reg_model.mod_reg.intr_msk_reg.write(status, 32'h5555_5555);
//     reg_model.mod_reg.intr_msk_reg.read(status, read_data);
  endtask
endclass

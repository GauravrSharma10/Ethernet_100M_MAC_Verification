class eth_moder_reg extends uvm_reg;
  `uvm_object_utils(eth_moder_reg)

  uvm_reg_field rxen, txen, nopre, bro, iam, pro, ifg, loopbck;
  uvm_reg_field nobckof, exdfr_en, fulld, dlycrcen, crcen;
  uvm_reg_field hugen, pad, recsmall;

  function new(string name="eth_moder_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    rxen       = uvm_reg_field::type_id::create("rxen");       
    rxen.configure(this,1,0,"RW",0,0,1,0,0);
    
    txen       = uvm_reg_field::type_id::create("txen");       
    txen.configure(this,1,1,"RW",0,0,1,0,0);
    
    nopre      = uvm_reg_field::type_id::create("nopre");      
    nopre.configure(this,1,2,"RW",0,0,1,0,0);
    
    bro        = uvm_reg_field::type_id::create("bro");        
    bro.configure(this,1,3,"RW",0,0,1,0,0);
    
    iam        = uvm_reg_field::type_id::create("iam");        
    iam.configure(this,1,4,"RW",0,0,1,0,0);
    
    pro        = uvm_reg_field::type_id::create("pro");        
    pro.configure(this,1,5,"RW",0,0,1,0,0);
    
    ifg        = uvm_reg_field::type_id::create("ifg");        
    ifg.configure(this,1,6,"RW",0,0,1,0,0);
    
    loopbck    = uvm_reg_field::type_id::create("loopbck");    
    loopbck.configure(this,1,7,"RW",0,0,1,0,0);
    
    nobckof    = uvm_reg_field::type_id::create("nobckof");    
    nobckof.configure(this,1,8,"RW",0,0,1,0,0);
    
    exdfr_en   = uvm_reg_field::type_id::create("exdfr_en");  
    exdfr_en.configure(this,1,9,"RW",0,0,1,0,0);
    
    fulld      = uvm_reg_field::type_id::create("fulld");      
    fulld.configure(this,1,10,"RW",0,0,1,0,0);
    
    dlycrcen   = uvm_reg_field::type_id::create("dlycrcen");  
    dlycrcen.configure(this,1,12,"RW",0,0,1,0,0);
    
    crcen      = uvm_reg_field::type_id::create("crcen");      
    crcen.configure(this,1,13,"RW",0,0,1,0,0);
    
    hugen      = uvm_reg_field::type_id::create("hugen");      
    hugen.configure(this,1,14,"RW",0,0,1,0,0);
    
    pad        = uvm_reg_field::type_id::create("pad");        
    pad.configure(this,1,15,"RW",0,0,1,0,0);
    
    recsmall   = uvm_reg_field::type_id::create("recsmall");  
    recsmall.configure(this,1,16,"RW",0,0,1,0,0);
  endfunction
endclass


`ifndef ETH_WB_COV_SV
`define ETH_WB_COV_SV

class eth_wb_cov extends uvm_subscriber #(wishbone_seq_item);
  `uvm_component_utils(eth_wb_cov)

  bit        sample_we;
  bit [31:0] sample_addr;
  bit [31:0] sample_data;

  covergroup wb_cg;
    option.per_instance = 1;

    cp_we   : coverpoint sample_we;
    cp_addr : coverpoint sample_addr {
      bins low    = {[32'h0 : 32'h0000_FFFF]};
      bins high   = {[32'h0001_0000 : 32'hFFFF_FFFF]};
    }
    cp_data : coverpoint sample_data;

    cross_we_addr : cross cp_we, cp_addr;
    cross_we_data : cross cp_we, cp_data;
  endgroup

  function new(string name="eth_wb_cov", uvm_component parent=null);
    super.new(name, parent);
    wb_cg = new(); 
  endfunction

  virtual function void write(wishbone_seq_item t);
    if (t == null) return;

    this.sample_we   = t.we;
    this.sample_addr = t.addr;

    // Handle the dynamic queue (data_q)
    if (t.data_q.size() == 0) begin
       this.sample_data = 0;
       wb_cg.sample();
    end else begin
      foreach (t.data_q[i]) begin
        this.sample_data = t.data_q[i];
        
        wb_cg.sample(); 
      end
    end
  endfunction

endclass

`endif

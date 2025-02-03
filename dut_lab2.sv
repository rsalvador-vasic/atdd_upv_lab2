module dut_lab2(
  input pll_clk,
  input func_rst_n,
  input c1_data_gen_en,                 // 1: Enable data burst;  0 : stop data generation

  input c4_clk,
  input c5_clk,
  input c4_select_interrupt,            // 0: c4_interrupt_a; 1: c4_interrupt_b
  input c4_interrupt_a,
  input c4_interrupt_b


);

parameter c1_freq_div_ratio   = 4'd2;   //   20 MHz / 2 = 10 MHz
parameter c3_freq_div_ratio   = 4'd8;   //   20 MHz / 8 = 2.5 MHz

parameter c1_data_rate_div    = 4'd2;   //   Data thoughput C1 bursts : 10 MHz /2 = 5 MSps


logic c1_clk;
logic c2_clk;
logic c3_clk;

logic [3:0] c1_data_rate_cnt;

logic [7:0] c1_data;
logic       c1_valid;



////////////////////////////////////////////////////////////////////////////////
// Clock Generation
////////////////////////////////////////////////////////////////////////////////

clk_div_cg u_clk_div_c1 (
  .clk_in(pll_clk),
  .rst_n (func_rst_n),
  .div_factor(c1_freq_div_ratio),
  .clk_out(c1_clk)
);

assign c2_clk = pll_clk;

clk_div_cg u_clk_div_c3 (
  .clk_in(pll_clk),
  .rst_n (func_rst_n),
  .div_factor(c3_freq_div_ratio),
  .clk_out(c3_clk)
);


////////////////////////////////////////////////////////////////////////////////
// Source data bursts generation
////////////////////////////////////////////////////////////////////////////////

always @ (posedge c1_clk or negedge func_rst_n)
  if(!func_rst_n) begin
    c1_data  <= 'b0;
    c1_valid <= 1'b0;
  end
  else begin
    c1_valid <= 1'b0;
    if(c1_data_rate_cnt == 4'd0) begin
      c1_data  <= c1_data + 1'b1;
      c1_valid <= 1'b1;
    end
  end

always @ (posedge c1_clk or negedge func_rst_n)
  if(!func_rst_n)
    c1_data_rate_cnt <= c1_data_rate_div - 1'b1;
  else if(!c1_data_gen_en)
    c1_data_rate_cnt <= c1_data_rate_div - 1'b1;
  else if(c1_data_rate_cnt == 'b0)
    c1_data_rate_cnt <= c1_data_rate_div - 1'b1;
  else
    c1_data_rate_cnt <= c1_data_rate_cnt - 1'b1;


// Lab2.1 Synchronous Data Transfer c1_clk to c2_clk (Slow to Fast). Avoid data duplication
// Generate the following signals in c2_clk domain

logic [7:0] c2_data;
logic       c2_valid;








// Lab2.2 Synchronous Data Transfer c2_clk to c3_clk (Fast to Slow) with FIFO. Avoid data loss
// Instantiate the provided fifo.sv 
// Generate the following signals in c3_clk domain

logic [7:0] c3_data;
logic       c3_valid;







// Lab2.3 Asynchronous Data Transfer (CDC) from c4_clk to c5_clk
// Generate the following signal in c5_clk domain

logic c5_interrupt_selected;







endmodule

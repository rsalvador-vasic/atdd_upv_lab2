`timescale 1ns/100ps

module tb_lab2 ();

// Define Parameters and Logics

localparam sim_time = 45000; // Simulation time in ns

localparam pll_per = 50.0;   // PLL clock period in ns

localparam c4_per = 15.0;   // c4_clk period in ns

localparam c5_per = 8.0;   // c5_clk period in ns

logic pll_clk;
logic c1_data_gen_en;
logic func_rst_n;
logic c4_clk;
logic c5_clk;
logic c4_interrupt_a;
logic c4_interrupt_b;
logic c4_select_interrupt;

// Generate free-running clock sources

initial begin
    pll_clk = 1'b0;
    forever 
        pll_clk = #(pll_per/2) !pll_clk;
end

initial begin
    c4_clk = 1'b0;
    forever 
        c4_clk = #(c4_per/2) !c4_clk;
end

initial begin
    c5_clk = 1'b0;
    forever 
        c5_clk = #(c5_per/2) !c5_clk;
end


// Release functional reset before clock sources toggle

initial begin
    func_rst_n = 1'b0;
    #1ns;
    func_rst_n = 1'b1;
end



initial begin
	c1_data_gen_en = 1'b0;
        forever begin
          repeat (20) @ (posedge pll_clk);
          c1_data_gen_en = 1'b1;
          repeat (20) @ (posedge pll_clk);
          c1_data_gen_en = 1'b0;
        end
end


initial begin
	c4_interrupt_a = 1'b0;
        forever begin
          repeat (3) @ (posedge c4_clk);
          c4_interrupt_a = 1'b1;
          repeat (1) @ (posedge c4_clk);
          c4_interrupt_a = 1'b0;
        end
end

initial begin
	c4_interrupt_b = 1'b0;
        forever begin
          repeat (6) @ (posedge c4_clk);
          c4_interrupt_b = 1'b1;
          repeat (1) @ (posedge c4_clk);
          c4_interrupt_b = 1'b0;
        end
end



initial begin
	c4_select_interrupt = 1'b0;
        forever begin
          repeat (22) @ (posedge c4_clk);
          c4_select_interrupt = 1'b1;
          repeat (63) @ (posedge c4_clk);
          c4_select_interrupt = 1'b0;
        end
end




// Dump waveforms and stop simulation
initial begin
    $shm_open(,1);
    $shm_probe("ACTM");
    #(sim_time);
    $finish();
end


// Instantiate DUT

dut_lab2 u_dut_lab2(
  .pll_clk            (pll_clk),
  .func_rst_n         (func_rst_n),
  .c1_data_gen_en     (c1_data_gen_en),
  .c4_clk             (c4_clk),
  .c5_clk             (c5_clk),
  .c4_select_interrupt(c4_select_interrupt),
  .c4_interrupt_a     (c4_interrupt_a),
  .c4_interrupt_b     (c4_interrupt_b)
);



endmodule

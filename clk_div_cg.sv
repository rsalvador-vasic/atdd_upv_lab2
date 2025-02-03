module clk_div_cg 
#( parameter DIV_W = 4
)(
  input                    clk_in,
  input                    rst_n,
  input        [DIV_W-1:0] div_factor,
  output logic             clk_out
);


logic [DIV_W-1:0] cnt;
logic             end_of_count;

always @ (posedge clk_in or negedge rst_n)
  if(!rst_n)
    cnt <= 'd1;
  else if(cnt == 'h0)
    cnt <= (div_factor == 'h0) ? 'h0 : div_factor - 1'b1;
  else
    cnt <= cnt - 1'b1;
   
 
assign end_of_count = cnt == 'h0;

icg_box u_icg_div(
  .E(end_of_count),
  .CLK(clk_in),
  .TE (1'b0),
  .GCLK(clk_out)
);

endmodule


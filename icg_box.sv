module icg_box (
  input        E,
  input        CLK, 
  input        TE,
  output logic GCLK
);

logic latch_e;  
logic latch_g;
logic latch_q;

assign latch_e = E || TE;
assign latch_g = !CLK;
assign GCLK = latch_q && CLK;

always @ (*)
  if(latch_g)
     latch_q = latch_e;

//  ICG cell - Behavioral Model in Std Cell Lib. Adds physical delay of 0.02ns
//  LSGCPJIHDX0 u_icg (.E (E), .CLK (CLK), .SE (SE), .GCLK (GCLK));

endmodule

module fifo #(
  parameter DATA_W = 8,
  parameter DEPTH_N = 16
)(
  input  logic              clk,
  input  logic              rst_n,
  input  logic [DATA_W-1:0] wr_data,
  input  logic              wr_stb,
  input  logic              rd_stb,

  output logic [DATA_W-1:0] rd_data,
  output logic              empty,
  output logic              full
); 

localparam N = $clog2(DEPTH_N);

logic [DEPTH_N-1:0][DATA_W-1:0] fifo;
logic                     [N:0] wr_ptr;
logic                     [N:0] rd_ptr;

assign full   = (rd_ptr[N] != wr_ptr[N]) && (rd_ptr[N-1:0] == wr_ptr[N-1:0]);
assign empty  = (rd_ptr == wr_ptr);

always_ff @ (posedge clk or negedge rst_n)
  if(!rst_n) begin
    fifo   <= '0;
    wr_ptr <= '0;
    rd_ptr <= '0;
  end
  else begin
    if(!full && wr_stb) begin
      wr_ptr <= wr_ptr + 1'b1;
      fifo[wr_ptr[N-1:0]] <= wr_data;
    end
     
    if(!empty && rd_stb) begin
      rd_ptr <= rd_ptr + 1'b1;
    end
  end


assign rd_data = fifo[rd_ptr[N-1:0]];

endmodule

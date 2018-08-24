module Adder#(
   parameter WWIDTH  = 32
)(
   input logic clk,
   input logic rst,
   input  logic [WWIDTH-1:0] Mid,  
   input  logic [WWIDTH-1:0] ExtractedBits,
   output logic [WWIDTH-1:0] temp2,
   output logic              sign
);

logic [WWIDTH-1:0] temp1;
assign temp1 = Mid+ExtractedBits;

always @(posedge clk or negedge rst)
   if (~rst) sign <= 1'b0;
   else sign <= temp1[WWIDTH-1];

always @(posedge clk or negedge rst)
   if (~rst) temp2 <= 'h0;
   else  temp2 <= sign ? temp1 : ~temp1 + 'h1;  
  
endmodule

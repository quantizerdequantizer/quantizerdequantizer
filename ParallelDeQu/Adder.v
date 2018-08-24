module Adder#(
   parameter WWIDTH  = 32
)(
   input  logic [WWIDTH-1:0] Mid,  
   input  logic [WWIDTH-1:0] ExtractedBits,
   output logic [WWIDTH-1:0] temp2,
   output logic              sign
);

logic [WWIDTH-1:0] temp1;

assign temp1 = Mid+ExtractedBits;
assign sign  = temp1[WWIDTH-1];
assign temp2 = sign ? temp1 : ~temp1 + 'h1; 
  
endmodule

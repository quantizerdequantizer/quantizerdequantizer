module MantissaExponentFormer#(
   parameter L2WIDTH   = 512,
   parameter WWIDTH    = 32,   
   parameter EXPLENGTH = 8
)(
   input  logic [EXPLENGTH-1:0] StepSizeExp,
   input  logic [WWIDTH-1:0]    temp2,
   input  logic [5:0]           locationOfOne,
   output logic [6:0]           Exponent,
   output logic [23:0]          Mantissa
);

assign Exponent = locationOfOne == 'h0 ? 'h0 : 'd127+StepSizeExp+locationOfOne;
assign Mantissa = locationOfOne == 'h0 ? 'h0 : temp2 << 32-locationOfOne+1;

endmodule


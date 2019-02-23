module dividerRemainder(dividend, divisor,quotient);
parameter dividendWidth=10;
parameter divisorWidth =9*2;
input [dividendWidth-1:0] dividend;
input [divisorWidth-1:0] divisor;
//----------------------------
output [divisorWidth:0]quotient;
reg [divisorWidth-1:0]quotient;
//-----------------------------------------------
always @(dividend or divisor  ) begin
	quotient<=(dividend*divisor);
end
endmodule


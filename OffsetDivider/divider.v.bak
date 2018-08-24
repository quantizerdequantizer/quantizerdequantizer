`ifdef FivePortDivider
module dividerRemainder(dividend, divisor,quotient,remainder,DividendMinusremainder );
`else
`endif
module dividerRemainder(dividend, divisor,quotient,remainder );
parameter dividendWidth=10;
parameter divisorWidth =9;
parameter quotientWidth=6;
parameter remainderWidth=9;
input [dividendWidth-1:0] dividend;
input [divisorWidth-1:0] divisor;
//----------------------------
output [quotientWidth-1:0]quotient;
output [remainderWidth-1:0] remainder ;
`ifdef FivePortDivider
output [dividendWidth-1:0] DividendMinusremainder ;
reg [dividendWidth-1:0] DividendMinusremainder ;
`endif
reg [quotientWidth-1:0]quotient;
reg [remainderWidth-1:0] remainder ;
//-----------------------------------------------

`ifdef FivePortDivider
always @(dividend or remainder ) begin
	DividendMinusremainder =dividend-remainder;
end
`endif
//--------------------------------------------------
//TODO: Implement divider effiecinetly to share resource for quotient, remainder, //and DividendMinusremainder
always @(dividend or divisor  ) begin
	quotient<=(dividend/divisor);
	remainder<=(dividend%divisor);
	
end
endmodule


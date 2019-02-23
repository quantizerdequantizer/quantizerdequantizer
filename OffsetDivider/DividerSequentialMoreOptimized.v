// The number of clock for this divider depends on the number of one in the output. Since the output has 6 digits, in worst case it takes 6 cycle
//The average number of cycle is calculated by this (1+1*c(1,6)+2*c(2,6)+3*c(3,6)+4*(4,6)+5*c(5,6)+6*c(6,6)) /(2^6=64)= 
module dividerRemainder(clk, rst, dividend, divisor,divisorLOD, quotient, ready, remainder);
parameter dividendWidth=10;
parameter divisorWidth =9;
parameter quotientWidth=6;
parameter LODWidth=4;
input [0:0] clk;
input [0:0] rst;
input [dividendWidth-1:0] dividend;
input [divisorWidth-1:0] divisor;
input [LODWidth-1:0] divisorLOD;  
//----------------------------
output [quotientWidth-1:0]quotient;
output [0:0] ready;
output [dividendWidth-1:0] remainder;
reg [quotientWidth-1:0]quotient;
reg [0:0] ready;
reg [dividendWidth-1:0] remainder;
//-----------------------------------------------
//------------------------
wire [LODWidth:0] LodDiff; //one bit more than LOD for sign
wire [dividendWidth-1:0] siftedDivisor;
wire [LODWidth-1:0] dividendLOd;
wire [quotientWidth-1:0] powerOfTwoOfNumberOfShift;
reg [LODWidth-1:0] numberOfShifts;
//------------------------------------
assign LodDiff = dividendLOd-divisorLOD-1;
assign shiftedDivisor={{1'b0},{divisor}}<<numberOfShifts;
assign powerOfTwoOfNumberOfShift=({{5{1'b0}},{{1'b1}}})<<numberOfShifts;
always @(LodDiff)begin
	if ( $signed(LodDiff)>0 ) begin
		numberOfShifts=LodDiff;
	end else begin
		numberOfShifts=0;
	end
end
shortLeadingOneDetection InsshortLOD(remainder,dividendLOd);

always @(posedge clk  ) begin
	if (rst ==1'b1) begin
		remainder <= dividend;
		quotient <=0;
		ready<=0;
	end else begin
		if(remainder>divisor) begin
			remainder<=remainder-shiftedDivisor;
			quotient=quotient|powerOfTwoOfNumberOfShift;
			ready<=0;
		end else begin
 			//remainder<=remainder; implicitly
			ready<=1;
		end
	end
end
endmodule


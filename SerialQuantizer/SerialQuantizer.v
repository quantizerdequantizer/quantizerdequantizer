//Serial Quantizer need a clock
module SerialQuantizer( clk,InProgress, InputWords, bitWidthArray,MidArray,stepSizeArray, ConvArray, isBoolArray, OutpuStr,numberOfValidBits,,IsOutlierArray);
parameter L2_WIDTH = 512 ;
parameter WordWidth_WIDTH = 32 ;   
parameter ExponentLength=8;
parameter NumOfWordsinBlk=16;
parameter NumOfBytesInWord=4;

input [0:0] clk;
input [0:0] InProgress;
input [WordWidth_WIDTH*NumOfWordsinBlk-1:0] InputWords;
input [5*NumOfWordsinBlk-1:0] bitWidthArray ;
input signed [WordWidth_WIDTH*NumOfWordsinBlk-1:0] MidArray ;
input [ExponentLength*NumOfWordsinBlk-1:0]stepSizeArray;
input [NumOfWordsinBlk-1:0]ConvArray;
input [NumOfBytesInWord*NumOfWordsinBlk-1:0]isBoolArray;
//
output [L2_WIDTH-1:0] OutpuStr;
output [8:0] numberOfValidBits;
output [NumOfWordsinBlk-1:0] IsOutlierArray;
reg  [L2_WIDTH-1:0] OutpuStr;
reg [8:0] numberOfValidBits;
reg [NumOfWordsinBlk-1:0] IsOutlierArray;
//---------------------
reg [WordWidth_WIDTH-1:0] OrigFormat;
reg [4:0] bitWidth;
reg  [WordWidth_WIDTH-1:0] Mid;
reg  [ExponentLength-1:0] StepSizeExp;
reg [0:0] Conv;
reg [3:0] IsBool;
reg [3:0] counter;

//------------------------------
OneWayQuantizer InsOWQ( OrigFormat, bitWidth,Mid, StepSizeExp, Conv, IsBool, QuantizedBits,IsOutlier); 


always @(InputWords or bitWidthArray or MidArray  or stepSizeArray or ConvArray or isBoolArray or counter ) begin

	OrigFormat <=InputWords[(WordWidth_WIDTH*counter) +: WordWidth_WIDTH];
	bitWidth <=bitWidthArray[5*counter +: 5] ;
	Mid<=MidArray[  WordWidth_WIDTH*counter +: WordWidth_WIDTH];
	StepSizeExp <=stepSizeArray[ExponentLength*counter +: ExponentLength];
	Conv<=ConvArray[counter +: 1];
	IsBool<=isBoolArray[NumOfBytesInWord*counter +: NumOfBytesInWord] ;
end
always @ (posedge clk) begin
	if(InProgress==1'b1) begin
		numberOfValidBits<=numberOfValidBits+{4'b0,bitWidth};
		IsOutlierArray[counter]<=IsOutlier;
		counter<=counter+1;
		OutpuStr[numberOfValidBits-1 +: 32]<= QuantizedBits;
	end else begin
		numberOfValidBits<=0;
		counter<=0;
		IsOutlierArray<=0;
		numberOfValidBits<=0;
		OutpuStr<=0;
	end
end

endmodule

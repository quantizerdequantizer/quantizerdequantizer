module MetaDataRotator( clk, rst, bitWidthArray,MidArray, ConvArray, isBoolArray,numberOfRotation,RotatedbitWidthArray,RotatedMidArray, RotatedConvArray, RotatedisBoolArray );
parameter L2_WIDTH = 512 ;
parameter WordWidth_WIDTH = 32 ;   
parameter ExponentLength=8;
//parameter NumOfWordsinBlk=16;
parameter NumOfBytesInWord=4;
parameter NumberOfRotationWidth=5; //maximum number of words is 32
parameter MAXNUMWORD=32;

//- LPGG Add parenthesis to fix warnings
//input [ExponentLength*MAXNUMWORD-1:0]stepSizeArray;

input [5*MAXNUMWORD-1:0] bitWidthArray ;
input [WordWidth_WIDTH*MAXNUMWORD-1:0] MidArray ;
input [MAXNUMWORD-1:0]ConvArray;
input [NumOfBytesInWord*MAXNUMWORD-1:0]isBoolArray;
input [NumberOfRotationWidth-1:0] numberOfRotation;

//-------------------------------
//LPGG- RotatedstepSizeArray unused port commented out
//output [ExponentLength*MAXNUMWORD-1:0]RotatedstepSizeArray;
output [(5*MAXNUMWORD)-1:0] RotatedbitWidthArray ;
output [WordWidth_WIDTH*MAXNUMWORD-1:0] RotatedMidArray ;
output [MAXNUMWORD-1:0]RotatedConvArray;
output [NumOfBytesInWord*MAXNUMWORD-1:0]RotatedisBoolArray;


////////////////////////////////////
//// -Add for P&R
input clk, rst;
reg [(5*MAXNUMWORD)-1:0] RotatedbitWidthArray ;
reg [WordWidth_WIDTH*MAXNUMWORD-1:0] RotatedMidArray ;
reg [MAXNUMWORD-1:0]RotatedConvArray;
reg [NumOfBytesInWord*MAXNUMWORD-1:0]RotatedisBoolArray;


logic [(5*MAXNUMWORD)-1:0] RotatedbitWidthArray_temp ;
logic [WordWidth_WIDTH*MAXNUMWORD-1:0] RotatedMidArray_temp ;
logic [MAXNUMWORD-1:0]RotatedConvArray_temp;
logic [NumOfBytesInWord*MAXNUMWORD-1:0]RotatedisBoolArray_temp;

always @(posedge clk or negedge rst)begin
   if (~rst) begin
      RotatedbitWidthArray <= 'h0; 
      RotatedMidArray      <= 'h0;
      RotatedConvArray     <= 'h0;
      RotatedisBoolArray   <= 'h0;
   end else begin
      RotatedbitWidthArray <= RotatedbitWidthArray_temp;
      RotatedMidArray      <= RotatedMidArray_temp;
      RotatedConvArray     <= RotatedConvArray_temp;
      RotatedisBoolArray   <= RotatedisBoolArray_temp;
   end
end

//// -End for P&R
////////////////////////////////////////

//LPGG- stepSizeArrayTemp unused port and wires commented
//-------------------------------
wire [(5*MAXNUMWORD*2)-1:0] bitWidthArrayTemp ;
wire [(WordWidth_WIDTH*MAXNUMWORD*2)-1:0] MidArrayTemp ;
//wire [(ExponentLength*MAXNUMWORD*2)-1:0]stepSizeArrayTemp;
wire [(MAXNUMWORD*2)-1:0]ConvArrayTemp;
wire [(NumOfBytesInWord*MAXNUMWORD*2)-1:0]isBoolArrayTemp;

//-----------------------------
assign bitWidthArrayTemp = {bitWidthArray,bitWidthArray};
assign MidArrayTemp={MidArray,MidArray} ;
//assign stepSizeArrayTemp={stepSizeArray,stepSizeArray};
assign  ConvArrayTemp={ConvArray,ConvArray};
assign isBoolArrayTemp={isBoolArray,isBoolArray};

//-----------------------------
//- LPGG Add parenthesis to fix warnings
// (5*32)=160 
// Add parenthesis and remove -1 at the end of all the lines.
assign	RotatedbitWidthArray_temp = bitWidthArrayTemp[(5*numberOfRotation)-1 +: 5*MAXNUMWORD];
assign	RotatedMidArray_temp = MidArrayTemp[(WordWidth_WIDTH*numberOfRotation)-1 +: WordWidth_WIDTH*MAXNUMWORD];
assign	RotatedConvArray_temp =ConvArrayTemp[numberOfRotation-1 +: MAXNUMWORD];
assign RotatedisBoolArray_temp = isBoolArrayTemp[(NumOfBytesInWord*numberOfRotation)-1 +: NumOfBytesInWord*MAXNUMWORD];
//-----------------------------

endmodule

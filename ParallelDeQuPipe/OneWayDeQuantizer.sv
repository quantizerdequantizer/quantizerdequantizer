//five cycle  parallel De-Quantizer

module OneWayDeQuantizer ( clk, InpuStr, NumShift, AccNumShift, Mid, StepSizeExp, Conv, IsBool, OrigFormat,IsOutlier); 
  parameter L2_WIDTH = 512 ;
  parameter SWIDTH = 5;
  parameter WordWidth_WIDTH = 32 ;   
  parameter ExponentLength=8;
//------------------------------------
  input [0:0] clk;
  input [L2_WIDTH-1:0] InpuStr;
  input [SWIDTH-1:0] NumShift;
  input [8:0] AccNumShift;
  input  [WordWidth_WIDTH-1:0] Mid;
  input  [ExponentLength-1:0] StepSizeExp;
  input [0:0] Conv;
  input [3:0] IsBool;

//-------------------
  
  output [WordWidth_WIDTH-1:0] OrigFormat ;
  output [0:0] IsOutlier;
//-------------------
  
  reg [WordWidth_WIDTH-1:0] OrigFormat ;
  
//--------------------------
  wire [WordWidth_WIDTH-1:0] ExtractedBits ;
  wire [WordWidth_WIDTH-1:0] temp2;
  wire [0:0] sign;
  wire[5:0] locationOfOne;
  wire [6:0] Exponent;
  wire [23:0] Mantissa;


//To make the desin pipilme, we need to add  clock  to each of the followind steps
//Step1
//Shift the L2 block to get the corresponding values of an L1 block
//Step1
AsynchBarrelShifter Inst1BSH(clk, InpuStr, NumShift, AccNumShift, ExtractedBits,IsOutlier);
//Step2
Adder InstAdder(clk, Mid,ExtractedBits, temp2,sign );
//Step3
leadingOneDetection InstLOD(clk, temp2,locationOfOne);
//Step4
MantissaExponentFormer Inst1MEF(clk,StepSizeExp,temp2,locationOfOne,Exponent, Mantissa );

always @( Conv or IsBool or ExtractedBits or sign or Exponent or Mantissa )
begin
	if(Conv==1'b1) begin
		case (IsBool) 
		4'b0000: begin
 			OrigFormat[31:31]<=sign;
			OrigFormat[30:24]<=Exponent;
			OrigFormat[23:0]<=Mantissa;
			end
		4'b0001: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=ExtractedBits[8:2];
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=ExtractedBits[16:10];
			OrigFormat[24:24]<=ExtractedBits[17:17];
			OrigFormat[31:25]<=ExtractedBits[24:18];
			end
		4'b0010: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=ExtractedBits[16:10];
			OrigFormat[24:24]<=ExtractedBits[17:17];
			OrigFormat[31:25]<=ExtractedBits[24:18];	
			end
		4'b0011: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[2:2];
			OrigFormat[23:17]<=ExtractedBits[9:3];
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=ExtractedBits[17:11];
			end
//----------------------------------
		4'b0100: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
         //- LPGG: 
         //- COmpiler Error Reversed part-select
         //OrigFormat[8:8]<=ExtractedBits[8:9];
         OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=ExtractedBits[15:9];
			OrigFormat[16:16]<=ExtractedBits[16:16];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[17:17];
			OrigFormat[31:25]<=ExtractedBits[24:18];
			end
		4'b0101: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=ExtractedBits[8:2];
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=ExtractedBits[17:11];
			end
		4'b0110: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=ExtractedBits[17:11];	
			end
		4'b0111: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[2:2];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[3:3];
			OrigFormat[31:25]<=ExtractedBits[10:4];
			end
//-----------------------------------
		4'b1000: begin
 			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=ExtractedBits[15:9];
			OrigFormat[16:16]<=ExtractedBits[16:16];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[17:17];
			OrigFormat[31:25]<=ExtractedBits[24:18];
			end
		4'b1001: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=ExtractedBits[10:2];
			OrigFormat[16:16]<=ExtractedBits[11:11];
			OrigFormat[23:17]<=ExtractedBits[18:12];
			OrigFormat[24:24]<=ExtractedBits[19:19];
			OrigFormat[31:25]<=0;
			end
		4'b1010: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=ExtractedBits[17:10];
			OrigFormat[24:24]<=ExtractedBits[18:18];
			OrigFormat[31:25]<=0;
			end
		4'b1011: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[2:2];
			OrigFormat[23:17]<=ExtractedBits[9:3];
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=0;
			end
//-------------------------------------
		4'b1100: begin
 			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=ExtractedBits[15:9];
			OrigFormat[16:16]<=ExtractedBits[16:16];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[17:17];
			OrigFormat[31:25]<=0;
			end
		4'b1101: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=ExtractedBits[8:2];
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=0;
			end
		4'b1110: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=ExtractedBits[7:1];
			OrigFormat[8:8]<=ExtractedBits[8:8];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[9:9];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[10:10];
			OrigFormat[31:25]<=0;
			end
		4'b1111: begin
			OrigFormat[0:0]<=ExtractedBits[0];
			OrigFormat[7:1]<=0;
			OrigFormat[8:8]<=ExtractedBits[1:1];
			OrigFormat[15:9]<=0;
			OrigFormat[16:16]<=ExtractedBits[2:2];
			OrigFormat[23:17]<=0;
			OrigFormat[24:24]<=ExtractedBits[3:3];
			OrigFormat[31:25]<=0;
			end
		endcase

	end else begin
		OrigFormat<=ExtractedBits; // support quantiization and consequently compression of integers
	end 
	
end



endmodule

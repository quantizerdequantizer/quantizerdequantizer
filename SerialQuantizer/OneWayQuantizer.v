module OneWayQuantizer ( OrigFormat, bitWidth,Mid, StepSizeExp, Conv, IsBool, QuantizedBits, IsOutlier); 
  parameter L2_WIDTH = 512 ;
  parameter WordWidth_WIDTH = 32 ;   
  parameter ExponentLength=8;
//------------------------------------
  input [WordWidth_WIDTH-1:0] OrigFormat;
  input [4:0] bitWidth;
  input  signed [WordWidth_WIDTH-1:0] Mid;
  input  [ExponentLength-1:0] StepSizeExp;
  input [0:0] Conv;
  input [3:0] IsBool;

//------------------- 
  output [WordWidth_WIDTH-1:0] QuantizedBits ;
  output [0:0] IsOutlier;
  reg [WordWidth_WIDTH-1:0] QuantizedBits ;
   

//------------------- 
  wire [L2_WIDTH-1:0] OutputStr; 
//--------------------------
  reg [0:0] sign;
  reg [6:0] Exponent;
  reg [22:0] Mantissa;
  reg [31:0] NumberOfMantissaShift;
  reg [32:0] MantissaShifted;
  reg [23:0] MantissaHidden;
  reg signed [31:0] BitsPlusMid;
  //reg [0:0] IsOutlierTemp;

wire  [WordWidth_WIDTH -1:0] temp1, temp2;

always @(sign or Exponent or Mantissa or MantissaHidden or NumberOfMantissaShift or MantissaShifted or  BitsPlusMid  or Mid)
begin
	sign [0:0]<=OrigFormat[31:31];
	Exponent<=OrigFormat[30:23];
	Mantissa<=OrigFormat[22:0];
	MantissaHidden={1'b1,Mantissa}; //Add the hidden bit in floating point format
	//Step1: determining number of shifts
	NumberOfMantissaShift<= ((127-Exponent)-StepSizeExp);
	//Step2 shifting
	MantissaShifted <= ({MantissaHidden,8'b0}>>(32-NumberOfMantissaShift));
	//Step3: Adding Mid to the bits
	if(sign ==1'b0) begin
		BitsPlusMid<=-MantissaShifted[31:0]-Mid;
	end else begin
		BitsPlusMid<=MantissaShifted[3:0]-Mid;
	end

end


assign temp1         = {WordWidth_WIDTH{1'b1}} >>WordWidth_WIDTH-bitWidth;    //-- Create mask for IsOutlier 
assign temp2         = temp1 & BitsPlusMid;
assign IsOutlier = &temp2;
/*
  genvar ii;
  generate
  for(ii=0; ii<32; ii=ii+1) begin: generate_loop
	
	always @ ( BitsPlusMid or bitWidth)
	
        begin	
		if(ii==bitWidth) begin
			if(BitsPlusMid>=0) begin
				if(BitsPlusMid>{ii{1'b1}}) begin
					IsOutlier<=1'b1;
				end else begin
					IsOutlierTemp[ii]<=1'b0;
				end
			end else begin 
				if((-BitsPlusMid)>{ii{1'b1}}) begin
					IsOutlierTemp[ii]<=1'b1;
				end else begin
					IsOutlierTemp[ii]<=1'b0;
				end		
			end
        	end else begin
			IsOutlierTemp[ii]<=1'b0;
		end
		
  	end
	
  end
  endgenerate
*/
//----------------

//genvar gen_i;
//generate
//assign IsOutlier = 1'b0;

//  for (gen_i = 0; gen_i < 32; gen_i = gen_i + 1) begin
 //     assign IsOutlier = IsOutlier | IsOutlierTemp[gen_i];
 // end
//endgenerate

//------------------
always @( Conv or IsBool or OrigFormat or BitsPlusMid  )
begin
	if(Conv==1'b1) begin
		case (IsBool) 
		4'b0000: begin
			QuantizedBits<=BitsPlusMid;
			end
		4'b0001: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1];
			QuantizedBits[1:1]<=OrigFormat[8:8];
			QuantizedBits[8:2]<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			QuantizedBits[16:10]<=OrigFormat[23:17];
			QuantizedBits[17:17]<=OrigFormat[24:24];
			QuantizedBits[24:18]<=OrigFormat[31:25];
			QuantizedBits[31:25]<=7'b0;
			end
// ToDo: assuming that in the system false is represented by one,  we could also use conditional assignments QuantizedBits[0]<=((OrigFormat[7:0]& 8'b00000000)==0) 1'b0  : 1'b1;

		4'b0010: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			//<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			QuantizedBits[16:10]<=OrigFormat[23:17];
			QuantizedBits[17:17]<=OrigFormat[24:24];
			QuantizedBits[24:18]<=OrigFormat[31:25];
			QuantizedBits[31:25]<=7'b0;	
			end
		4'b0011: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1];
			QuantizedBits[1:1]<=OrigFormat[8:8];
			//<=OrigFormat[15:9];
			QuantizedBits[2:2]<=OrigFormat[16:16];
			QuantizedBits[9:3]<=OrigFormat[23:17];
			QuantizedBits[10:10]<=OrigFormat[24:24];
			QuantizedBits[17:11]<=OrigFormat[31:25];
			QuantizedBits[31:18]<=14'b0;
			end

//----------------------------------
		4'b0100: begin
			QuantizedBits[0:0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:9]<=OrigFormat[8:8];
			QuantizedBits[15:9]<=OrigFormat[15:9];
			QuantizedBits[16:16]<=OrigFormat[16:16];
			//<=OrigFormat[23:17];
			QuantizedBits[17:17]<=OrigFormat[24:24];
			QuantizedBits[24:18]<=OrigFormat[31:25];
			QuantizedBits[31:25]<=7'b0;
			end
		4'b0101: begin
			QuantizedBits[0] <=OrigFormat[0:0];
			//<=OrigFormat[7:1] ;
			QuantizedBits[1:1]<=OrigFormat[8:8];
			QuantizedBits[8:2]<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			//<= OrigFormat[23:17];
			QuantizedBits[10:10]<=OrigFormat[24:24];
			QuantizedBits[17:11]<=OrigFormat[31:25];
 			QuantizedBits[31:18]<=14'b0;
			end
		4'b0110: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			//<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			//<=OrigFormat[23:17];
			QuantizedBits[10:10]<=OrigFormat[24:24];
			QuantizedBits[17:11]<=OrigFormat[31:25];	
			QuantizedBits[31:18]<=14'b0;
			end
		4'b0111: begin
			QuantizedBits[0]<= OrigFormat[0:0];
			//OrigFormat[7:1]
			QuantizedBits[1:1]<=OrigFormat[8:8];
			//OrigFormat[15:9]
			QuantizedBits[2:2]<=OrigFormat[16:16];
			//OrigFormat[23:17]
			QuantizedBits[3:3]<=OrigFormat[24:24];
			QuantizedBits[10:4]<=OrigFormat[31:25];
			QuantizedBits[31:11]<=21'b0;
			end
//-----------------------------------
		4'b1000: begin
 			QuantizedBits[0]<= OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			QuantizedBits[15:9]<=OrigFormat[15:9];
			QuantizedBits[16:16]<=OrigFormat[16:16];
			//<=OrigFormat[23:17]
			QuantizedBits[17:17]<=OrigFormat[24:24];
			QuantizedBits[24:18]<=OrigFormat[31:25];
			QuantizedBits[31:25]<=7'b0;
			end
		4'b1001: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1];
			QuantizedBits[1:1]<=OrigFormat[8:8];
			QuantizedBits[10:2]<=OrigFormat[15:9];
			QuantizedBits[11:11]<=OrigFormat[16:16];
			QuantizedBits[18:12]<=OrigFormat[23:17];
			QuantizedBits[19:19]<=OrigFormat[24:24];
			//<=OrigFormat[31:25]
			QuantizedBits[31:20]<=12'b0;
			end
		4'b1010: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			//<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			QuantizedBits[17:10]<=OrigFormat[23:17];
			QuantizedBits[18:18]<=OrigFormat[24:24];
			QuantizedBits[31:19]<=13'b0;
			//<=OrigFormat[31:25];
			end
		4'b1011: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1]
			QuantizedBits[1:1]<=OrigFormat[8:8];
			//<=OrigFormat[15:9];
			QuantizedBits[2:2]<=OrigFormat[16:16];
			QuantizedBits[9:3]<=OrigFormat[23:17];
			QuantizedBits[10:10]<=OrigFormat[24:24];
			//<=OrigFormat[31:25]
			QuantizedBits[31:11]<=21'b0;
			end
//-------------------------------------
		4'b1100: begin
 			QuantizedBits[0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			QuantizedBits[15:9]<=OrigFormat[15:9];
			QuantizedBits[16:16]<=OrigFormat[16:16];
			//OrigFormat[23:17]
			QuantizedBits[17:17]<=OrigFormat[24:24];
			QuantizedBits[31:18]<=14'b0;
			//OrigFormat[31:25]
			end
		4'b1101: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1];
			QuantizedBits[1:1]<=OrigFormat[8:8];
			QuantizedBits[8:2]<=OrigFormat[15:9];
			QuantizedBits[9:9]<=OrigFormat[16:16];
			//OrigFormat[23:17]
			QuantizedBits[10:10]<=OrigFormat[24:24];
			//<=OrigFormat[31:25]
			QuantizedBits[31:11]<=21'b0;
			end
		4'b1110: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			QuantizedBits[7:1]<=OrigFormat[7:1];
			QuantizedBits[8:8]<=OrigFormat[8:8];
			//<=OrigFormat[15:9]
			QuantizedBits[9:9]<=OrigFormat[16:16];
			//<= OrigFormat[23:17]
			QuantizedBits[10:10]<=OrigFormat[24:24];
			//<= OrigFormat[31:25]
			QuantizedBits[31:11]<=21'b0;
			end
		4'b1111: begin
			QuantizedBits[0]<=OrigFormat[0:0];
			//<=OrigFormat[7:1];
			QuantizedBits[1:1]<=OrigFormat[8:8];
			//<=OrigFormat[15:9]
			QuantizedBits[2:2]<=OrigFormat[16:16];
			//<=OrigFormat[23:17]
			QuantizedBits[3:3]<=OrigFormat[24:24];
			//<=OrigFormat[31:25];
			QuantizedBits[31:4]<=28'b0;
			end
		endcase

	end else begin
		QuantizedBits<=OrigFormat;
	end 
	
end



endmodule

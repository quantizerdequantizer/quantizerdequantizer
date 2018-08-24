module ParallelDeQ#(
   parameter L2WIDTH   = 512,
   parameter WWIDTH    =  32,   
   parameter EXPLENGTH =   8,
   parameter WORDSBLK  =  16,
   parameter BYTESWORD =   4
)(
   input  logic clk, rst, 
   input  logic [L2WIDTH-1:0]              InpuStr,
   input  logic [(5*WORDSBLK)-1:0]         bitWidthArray,
   input  logic [(9*WORDSBLK)-1:0]         AccNumShiftArray,
   input  logic [(WWIDTH*WORDSBLK)-1:0]    MidArray,
   input  logic [(EXPLENGTH*WORDSBLK)-1:0] stepSizeArray,
   input  logic [WORDSBLK-1:0]             ConvArray,
   input  logic [(BYTESWORD*WORDSBLK)-1:0] isBoolArray,
   output logic [(WWIDTH*WORDSBLK)-1:0]    OutputWords,
   output logic [WORDSBLK-1:0]             IsOutlierArray 
);

logic [4:0] NumShiftInArray [0:WORDSBLK-1];
logic [8:0] AcumInArray [0:WORDSBLK-1];

//- For P&R
logic [(WWIDTH*WORDSBLK)-1:0]    OutputWords_temp;
logic [WORDSBLK-1:0]             IsOutlierArray_temp; 
always @(posedge clk or negedge rst) begin 
   if (~rst) begin
      OutputWords    <= 'h0;
      IsOutlierArray <= 'h0; 
   end else begin
      OutputWords    <= OutputWords_temp;
      IsOutlierArray <= IsOutlierArray_temp;
   end
end
//- End of P&R
 
genvar i;
generate
   for(i=0; i<WORDSBLK; i=i+1) begin
    
      assign NumShiftInArray[i] = bitWidthArray[((5*i)+5)-1:5*i];
      assign AcumInArray[i] = AccNumShiftArray[((9*i)+9)-1:9*i];
      OneWayDeQuantizer Deq ( clk, InpuStr, NumShiftInArray[i], 
                              AcumInArray[i], 
                              MidArray[((i+1)*WWIDTH)-1:i*WWIDTH], 
                              stepSizeArray[(EXPLENGTH*(i+1))-1:EXPLENGTH*i], 
                              ConvArray[i], isBoolArray[((i+1)*BYTESWORD)-1:i*BYTESWORD], 
                              OutputWords_temp[(WWIDTH*(i+1))-1:WWIDTH*i], 
                              IsOutlierArray_temp[i]);  
         
   end
endgenerate


endmodule



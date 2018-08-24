module leadingOneDetection(
   input  logic clk, rst,
   input  logic [31:0] inputWord,
   output logic [5:0] locationOfOne
);

logic [5:0] locationOfOneTemp;

always @(posedge clk or negedge rst)
   if (~rst) locationOfOne <= 'h0;
   else locationOfOne <= locationOfOneTemp;


always @(inputWord) begin
  casez (inputWord)
    //Warnings zero multiple concatenations
    //{{0{1'b0}},{1'b1},{31{1'b?}}} : locationOfOneTemp <= 32;
    {{1'b1},{31{1'b?}}} : locationOfOneTemp <= 32;
    {{1{1'b0}},{{1'b1},{30{1'b?}}}} : locationOfOneTemp <= 31;
    {{2{1'b0}},{{1'b1},{29{1'b?}}}} : locationOfOneTemp <= 30;
    {{3{1'b0}},{{1'b1},{28{1'b?}}}} : locationOfOneTemp <= 29;
    {{4{1'b0}},{{1'b1},{27{1'b?}}}} : locationOfOneTemp <= 28;
    {{5{1'b0}},{{1'b1},{26{1'b?}}}} : locationOfOneTemp <= 27;
    {{6{1'b0}},{{1'b1},{25{1'b?}}}} : locationOfOneTemp <= 26;
    {{7{1'b0}},{{1'b1},{24{1'b?}}}} : locationOfOneTemp <= 25;
    {{8{1'b0}},{{1'b1},{23{1'b?}}}} : locationOfOneTemp <= 24;
    {{9{1'b0}},{{1'b1},{22{1'b?}}}} : locationOfOneTemp <= 23;
    {{10{1'b0}},{{1'b1},{21{1'b?}}}} : locationOfOneTemp <= 22;
    {{11{1'b0}},{{1'b1},{20{1'b?}}}} : locationOfOneTemp <= 21;
    {{12{1'b0}},{{1'b1},{19{1'b?}}}} : locationOfOneTemp <= 20;
    {{13{1'b0}},{{1'b1},{18{1'b?}}}} : locationOfOneTemp <= 19;
    {{14{1'b0}},{{1'b1},{17{1'b?}}}} : locationOfOneTemp <= 18;
    {{15{1'b0}},{{1'b1},{16{1'b?}}}} : locationOfOneTemp <= 17;
    {{16{1'b0}},{{1'b1},{15{1'b?}}}} : locationOfOneTemp <= 16;
    {{17{1'b0}},{1'b1},{14{1'b?}}}   : locationOfOneTemp <= 15;
    {{18{1'b0}},{{1'b1},{13{1'b?}}}} : locationOfOneTemp <= 14;
    {{19{1'b0}},{{1'b1},{12{1'b?}}}} : locationOfOneTemp <= 13;
    {{20{1'b0}},{{1'b1},{11{1'b?}}}} : locationOfOneTemp <= 12;
    {{21{1'b0}},{{1'b1},{10{1'b?}}}} : locationOfOneTemp <= 11;
    {{22{1'b0}},{{1'b1},{9{1'b?}}}} : locationOfOneTemp <= 10;
    {{23{1'b0}},{{1'b1},{8{1'b?}}}} : locationOfOneTemp <= 9;
    {{24{1'b0}},{{1'b1},{7{1'b?}}}} : locationOfOneTemp <= 8;
    {{25{1'b0}},{{1'b1},{6{1'b?}}}} : locationOfOneTemp <= 7;
    {{26{1'b0}},{{1'b1},{5{1'b?}}}} : locationOfOneTemp <= 6;
    {{27{1'b0}},{{1'b1},{4{1'b?}}}} : locationOfOneTemp <= 5;
    {{28{1'b0}},{{1'b1},{3{1'b?}}}} : locationOfOneTemp <= 4;
    {{29{1'b0}},{{1'b1},{2{1'b?}}}} : locationOfOneTemp <= 3;
    {{30{1'b0}},{{1'b1},{1{1'b?}}}} : locationOfOneTemp <= 2;
    //Warnings zero multiple concatenations
    //{{31{1'b0}},{{1'b1},{0{1'b?}}}} : locationOfOneTemp <= 1;
    {{31{1'b0}},{{1'b1}}} : locationOfOneTemp <= 1;
    32'b0 : locationOfOneTemp <= 0;
    default: locationOfOneTemp <= 0;
  endcase
end
endmodule


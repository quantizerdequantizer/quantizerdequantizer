module leadingOneDetection(
   input  logic [31:0] inputWord,
   output logic [5:0] locationOfOne
);

always @(inputWord) begin
  casez (inputWord)
    //Warnings zero multiple concatenations
    //{{0{1'b0}},{1'b1},{31{1'b?}}} : locationOfOne <= 32;
    {{1'b1},{31{1'b?}}} : locationOfOne <= 32;
    {{1{1'b0}},{{1'b1},{30{1'b?}}}} : locationOfOne <= 31;
    {{2{1'b0}},{{1'b1},{29{1'b?}}}} : locationOfOne <= 30;
    {{3{1'b0}},{{1'b1},{28{1'b?}}}} : locationOfOne <= 29;
    {{4{1'b0}},{{1'b1},{27{1'b?}}}} : locationOfOne <= 28;
    {{5{1'b0}},{{1'b1},{26{1'b?}}}} : locationOfOne <= 27;
    {{6{1'b0}},{{1'b1},{25{1'b?}}}} : locationOfOne <= 26;
    {{7{1'b0}},{{1'b1},{24{1'b?}}}} : locationOfOne <= 25;
    {{8{1'b0}},{{1'b1},{23{1'b?}}}} : locationOfOne <= 24;
    {{9{1'b0}},{{1'b1},{22{1'b?}}}} : locationOfOne <= 23;
    {{10{1'b0}},{{1'b1},{21{1'b?}}}} : locationOfOne <= 22;
    {{11{1'b0}},{{1'b1},{20{1'b?}}}} : locationOfOne <= 21;
    {{12{1'b0}},{{1'b1},{19{1'b?}}}} : locationOfOne <= 20;
    {{13{1'b0}},{{1'b1},{18{1'b?}}}} : locationOfOne <= 19;
    {{14{1'b0}},{{1'b1},{17{1'b?}}}} : locationOfOne <= 18;
    {{15{1'b0}},{{1'b1},{16{1'b?}}}} : locationOfOne <= 17;
    {{16{1'b0}},{{1'b1},{15{1'b?}}}} : locationOfOne <= 16;
    {{17{1'b0}},{1'b1},{14{1'b?}}}   : locationOfOne <= 15;
    {{18{1'b0}},{{1'b1},{13{1'b?}}}} : locationOfOne <= 14;
    {{19{1'b0}},{{1'b1},{12{1'b?}}}} : locationOfOne <= 13;
    {{20{1'b0}},{{1'b1},{11{1'b?}}}} : locationOfOne <= 12;
    {{21{1'b0}},{{1'b1},{10{1'b?}}}} : locationOfOne <= 11;
    {{22{1'b0}},{{1'b1},{9{1'b?}}}} : locationOfOne <= 10;
    {{23{1'b0}},{{1'b1},{8{1'b?}}}} : locationOfOne <= 9;
    {{24{1'b0}},{{1'b1},{7{1'b?}}}} : locationOfOne <= 8;
    {{25{1'b0}},{{1'b1},{6{1'b?}}}} : locationOfOne <= 7;
    {{26{1'b0}},{{1'b1},{5{1'b?}}}} : locationOfOne <= 6;
    {{27{1'b0}},{{1'b1},{4{1'b?}}}} : locationOfOne <= 5;
    {{28{1'b0}},{{1'b1},{3{1'b?}}}} : locationOfOne <= 4;
    {{29{1'b0}},{{1'b1},{2{1'b?}}}} : locationOfOne <= 3;
    {{30{1'b0}},{{1'b1},{1{1'b?}}}} : locationOfOne <= 2;
    //Warnings zero multiple concatenations
    //{{31{1'b0}},{{1'b1},{0{1'b?}}}} : locationOfOne <= 1;
    {{31{1'b0}},{{1'b1}}} : locationOfOne <= 1;
    32'b0 : locationOfOne <= 0;
    default: locationOfOne <= 0;
  endcase
end
endmodule


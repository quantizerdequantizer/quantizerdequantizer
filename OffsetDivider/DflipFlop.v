module DflipFlop(clk, d, shifted_d, d_enable,shifted_d_enable, outD);

input clk;
input d;
input shifted_d;
input d_enable;
input shifted_d_enable;
//----------------------------
output  outD;
reg outD;
//-----------------------------------------------
always @(posedge clk ) begin
	if(d_enable==1'b1)begin
		outD<=d;
	end else begin
	 	if(shifted_d_enable==1'b1)begin
			outD<=shifted_d;
		end
	end
end
endmodule


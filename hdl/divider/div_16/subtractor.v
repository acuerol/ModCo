module subtractor (clk, rst, dv0, in_A, in_B, msb , result);
	input clk;
	input rst;
	input dv0;
	input [15:0] in_A;
	input [15:0] in_B;

	output reg msb = 0;
	output reg [15:0] result = 0;

	always @(negedge clk) begin
		if(rst) begin 
			result = 0;
		end
		else 
			if(dv0) begin
				result = in_A + (~in_B) + 1; // a A le resta el complemento de B + 1 (Complemento a dos).
			end 
			else
				result = result;
	end

	always@(*) begin
		if(in_A < in_B)
			msb = 1;
		else
			msb = 0;
	end
endmodule

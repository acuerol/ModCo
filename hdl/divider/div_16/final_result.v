module final_result (clk, rst, dec, msb, result);
	input clk;
	input rst;
	input dec;
	input msb;
	output reg [15:0] result;

	always @(posedge clk) begin
		if(rst)
			result = 0;
		else 
			if(dec) begin
				if (msb == 0)
					result = {result[14:0], 1'b1};
				else
					result = {result[14:0], 1'b0};
			end
		end
endmodule

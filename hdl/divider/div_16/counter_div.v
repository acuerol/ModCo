// Disminuye en 1 unidad cada vez que dec es 1 empezando desde 16.
module counter_div (clk, rst, dec, z);
	input clk;
	input rst;
	input dec; // Decrementar.
	output reg z;

	reg [4:0] cont = 16;

	always @(negedge clk) begin
		if (rst) 
			cont = 5'b10000; //16
		else begin
			if (dec)
				cont = cont - 1;
			else
				cont = cont;
		end
		z = (cont == 0) ? 1 : 0 ;
	end
endmodule

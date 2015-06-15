module lsr_div (clk, rst, dv_in, result, init, sh, load_A, A);
	input clk;
	input rst;
	input [15:0] dv_in; // Dividendo de entrada.
	input [15:0] result;
	input init;
	input sh;
	input load_A;
	output reg [15:0] A;

	reg [15:0] dv; // Dividendo.

	always @(negedge clk) // Verificar: ¿actualizacion de A antes de corrimiento?
		if(init || rst) begin
			A = 0;
			dv = dv_in;
		end
		else begin
			if(sh)
				{A,dv} = {A,dv} << 1;
			else begin
				if(load_A)
					A = result;
				else
					A = A;
			end
	end
endmodule

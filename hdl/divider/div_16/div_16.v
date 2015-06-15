module div_16(clk, rst, init_in, A, B, result, done);
	input rst;
	input clk;
	input init_in;
	input [15:0] A;
	input [15:0] B;
	output [15:0] result;
	output done;

	wire w_init, w_sh, w_load_A;

	wire w_msb;
	wire [15:0] w_result;
	wire [15:0] w_A;

	wire w_dec, w_z, w_dv0;

	lsr_div lsr_d (.clk(clk), .rst(rst), .dv_in(A), .result(w_result), .init(w_init), .sh(w_sh), .load_A(w_load_A), .A(w_A) );
	subtractor sb (.clk(clk), .rst(rst), .in_A(w_A), .in_B(B), .msb(w_msb), .result(w_result), .dv0(w_dv0) );
	counter_div ctr_dv (.clk(clk), .rst(w_init), .dec(w_dec), .z(w_z) );
	final_result fr (.clk(clk), .rst(w_init), .dec(w_dec), .msb(w_msb), .result(result));
	
	control_div ctl_dv (.clk(clk), .rst(rst), .start(init_in), .msb(w_msb), .z(w_z), .init(w_init), .sh(w_sh), .dec(w_dec), .load_A(w_load_A), .done(done), .dv0(w_dv0) );
endmodule

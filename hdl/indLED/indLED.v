module indLED(clk, rst, addr, cs, rd, wr, led1, led2);

	input clk;
	input rst;
	input [3:0]addr;
	input cs;
	input rd;
	input wr;
	
	output reg led1;
	output reg led2;
	
	reg [3:0]sel_mux;
	
	always @(*) begin
		case(addr)
			4'h0: sel_mux = (cs & wr) ? 4'h1 : 0; // On 1
			4'h2: sel_mux = (cs & wr) ? 4'h2 : 0; // On 2
			4'h4: sel_mux = (cs & wr) ? 4'h4 : 0; // Off 1
			4'h8: sel_mux = (cs & wr) ? 4'h8 : 0; // Off 2
			default: sel_mux = 0;
		endcase
	end
	
	always @(negedge clk) begin
		led1 = sel_mux[0] ? 1 : led1;
		led2 = sel_mux[1] ? 1 :	led2;
		led1 = sel_mux[2] ? 0 : led1;
		led2 = sel_mux[3] ? 0 : led2;
		
		if(rst) begin
			led1 = 0;
			led2 = 0;
		end
	end
	
endmodule

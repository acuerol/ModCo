////////////////////////////////////////////////////////////////////////////
// Authors: Fernando Bastidas - Alexis Cuero Losada
//	Revision: 1
// Description: Interfaz entre el timer y el j1.
////////////////////////////////////////////////////////////////////////////

module peripheral_timer(clk, rst, addr, cs, rd, wr, data_out);

	//--------------------Entradas
	input clk;
	input rst;
	input [3:0]addr;
	input cs;
	input rd;
	input wr;
	
	//--------------------Salidas
	output reg [15:0]data_out;
	
	reg [3:0]sel_mux;
	reg rst_timer;
	
	wire [15:0]timer_cycles;
	
	always @(*) begin
		case(addr)
			4'h0:begin sel_mux = (cs & rd) ? 4'h1 : 4'b0; end // Lee los ciclos.
			4'h2:begin sel_mux = (cs & wr) ? 4'h2 : 4'b0; end // Reset.
			default:begin sel_mux = 4'h0; end
		endcase
	end
	
	always @(negedge clk) begin
		data_out = (sel_mux[0]) ? timer_cycles : 0;
	end
	
	always @(negedge clk) begin
		rst_timer = sel_mux[1];
	end
	
	timer tim(.clk(clk), .rst(rst), .rst_timer(rst_timer), .cycles(timer_cycles));
endmodule

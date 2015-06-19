////////////////////////////////////////////////////////////////////////////
// Authors: Fernando Bastidas - Alexis Cuero Losada
//	Revision: 1
// Description: peripherico de comunicación del j1 con el controlador para las señales de control del módulo de Wi-Fi ESP8266.
////////////////////////////////////////////////////////////////////////////

module peripheral_espDriver(clk, sys_rst, addr, cs, rd, wr, mod_rst);
	//--------------------Entradas
	input clk;
	input sys_rst;
	
	input [3:0]addr;
	input cs;
	input rd;
	input wr;
	
	//--------------------Salidas
	output mod_rst;

	reg rst;
	reg [1:0]sel_mux;
	
	always @(negedge clk) begin
		case(addr)
			4'h0: sel_mux = (cs & wr) ? 2'h1 : 2'h0;
			default: sel_mux = 2'h0;
		endcase
	end
	
	always @(negedge clk) begin
			rst = sel_mux[0] ? 1 : 0;
	end
	
	espDriver espD(.clk(clk), .sys_rst(sys_rst), .rst(rst), .mod_rst(mod_rst));
	
endmodule

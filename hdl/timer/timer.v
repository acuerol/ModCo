////////////////////////////////////////////////////////////////////////////
// Authors: Fernando Bastidas - Alexis Cuero Losada
//	Revision: 1
// Description: Contador para determinar tiempo de envio y recepción del módulo de Wi-Fi ESP8266.
////////////////////////////////////////////////////////////////////////////

module timer(clk, rst, rst_timer, cycles);
	
	//--------------------Entradas
	input clk;
	input rst;
	input rst_timer;
	
	//--------------------Salidas
	output [15:0]cycles;
	
	reg [19:0]counter;	
	reg [15:0]cycles;
	
	parameter [19:0]PERIOD = 50000; // Nexys2 50000.
	
	always @(posedge clk) begin
		if(rst) begin
			cycles = 0;
			counter = 0;
		end
		
		if(rst_timer) begin
			cycles = 0;
			counter = 0;
		end else begin
			counter = counter + 1;
		end	
			
		if(counter == PERIOD) begin
			counter = 0;
			cycles = cycles + 1;
		end
	end
endmodule

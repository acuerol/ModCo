////////////////////////////////////////////////////////////////////////////
// Authors: Fernando Bastidas - Alexis Cuero Losada
//	Revision: 1
// Description: Controlador para las señales de control del módulo de Wi-Fi ESP8266.
////////////////////////////////////////////////////////////////////////////

module espDriver(clk, sys_rst, rst, mod_rst);
	//--------------------Entradas
	input clk;
	input sys_rst;
	input rst;
	
	//--------------------Salidas
	output mod_rst;
	
	//--------------------Intermediarias
	reg [3:0]counter;

	wire mod_rst = ~|counter;
	
	always @(posedge clk)
		if(sys_rst)
			counter <= 0;
		else begin
			if(rst & ~|counter)
				counter <= 15;
			else if(|counter) // Si no es cero se cuenta hasta que sea cero.
				counter <= counter - 1;
		end
	
endmodule

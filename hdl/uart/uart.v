module uart(clk, rst, init_tx, init_rx ,uart_data_in, uart_tx, uart_tx_busy, uart_data_out, uart_rx, uart_rx_busy, done);

	//--------------------Entradas
	input clk;
	input rst;
	
	input init_tx;
	input init_rx;
	
	input [7:0]uart_data_in;
	input uart_rx;
	
	//--------------------Salidas
	output reg [7:0]uart_data_out;
	
	output uart_tx;
	
	output uart_tx_busy;
	output uart_rx_busy;	
	
	output done;
	
	//--------------------Variables facilitadoras
	reg [3:0]bitcount_rx;
	reg [3:0]bitcount_tx;
	
	wire uart_rx;
	wire uart_rx_busy = |bitcount_rx;
	wire receiving = |bitcount_rx[3:1];
	
	reg uart_tx;
	wire uart_tx_busy = |bitcount_tx; // invertidos v

	reg [8:0]shifter;
	
	wire done = receiving ^ uart_rx_busy;
	
	//--------------------clk is 50MHz (Nexys2). We want a 115200Hz clock.
	reg [28:0] d;
	wire [28:0] dInc = d[28] ? (115200) : (115200 - 50000000); // Si el último bit es 1, reinicia el contador, si es 0, lo deja a 115200 de volverse 1.
	wire [28:0] dNxt = d + dInc;
	wire clk_div = ~d[28]; // Pulso resultante resultante.

	always @(posedge clk)
		if (rst) begin
			d = 0;
		end else begin
			d = dNxt;
		end
	
	always @(posedge clk) begin
		if (rst) begin
			uart_tx <= 1;
			bitcount_tx <= 0;
			shifter <= 0;
			
			uart_data_out <= 0;
			bitcount_rx <= 0;
		end else begin
			//--------------------Tx UART
			if (~uart_tx_busy & ~uart_rx_busy & init_tx) begin
				shifter <= { uart_data_in , 1'h0 }; // Marca el bit de inicio.
				bitcount_tx <= (1 + 8 + 2); // Para contar 1bit de inicio (low) de transmisión, contar el número de bits a enviar y mantener 2bits en alto para terminar.
			end

			if (uart_tx_busy & clk_div) begin
				// { 8:0 , 1 } <= { 1 , 8:0 } -> { 110110110 , 0 } <= { 1 , 101101100 } -> { 111011011 , 0 } <= { 1 , 110110110 }
				{ shifter , uart_tx } <= { 1'h1 , shifter }; 
				bitcount_tx <= bitcount_tx - 1;
			end
			
			//--------------------Rx UART
			if(init_rx) begin
				uart_data_out <= 0;
				if(~uart_tx_busy & ~uart_rx_busy & ~uart_rx) begin
					bitcount_rx <= 10;
				end
			end
		
			if(uart_rx_busy & clk_div) begin
				bitcount_rx <= bitcount_rx - 1;
				if(receiving)
					uart_data_out <= { uart_rx , uart_data_out[7:1]};
			end
//			if( ~receiving & uart_rx_busy ) Verificar que le siugiente bit sea 1
					
		end
	end	
endmodule

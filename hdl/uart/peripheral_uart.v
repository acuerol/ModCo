module peripheral_uart(clk, rst, addr, cs, rd, wr, data_in, uart_tx, tx_led, data_out, uart_rx, rx_led);

	//--------------------Entradas
	input clk;
	input rst;
	
	input cs;
	input rd;
	input wr;
	
	input [3:0]addr;
	input [15:0]data_in;
	input uart_rx;

	//--------------------Salidas
	output reg [15:0]data_out;
	output uart_tx;
	
	output reg rx_led;
	output reg tx_led;
	
	//--------------------Intermediarias
	reg [3:0] sel_mux;
	reg [7:0] uart_data_in;
	reg init_tx;
	reg init_rx;
	reg stop;
	
	wire [7:0]uart_data_out;
	wire uart_rx_busy;
	wire uart_tx_busy;
	wire uart_done;
	
	//--------------------Decodificador de direcciones
	always @(*) begin
		case (addr)
			4'h0: sel_mux = (cs & wr) ? 4'h1 : 4'b0; // Escritura de datos de entrada.
			4'h2: sel_mux = (cs & rd) ? 4'h2 : 4'b0; // Lectura de datos de salida.
			4'h4: sel_mux = (cs & rd) ? 4'h4 : 4'b0; // Lectura de estado de transmisión.
			4'h6: sel_mux = (cs & rd) ? 4'h6 : 4'b0; // Lectura de estado de recepción.
			4'h8: sel_mux = (cs & wr) ? 4'h8 : 4'b0; // Iniciar tx.
			4'hA: sel_mux = (cs & rd) ? 4'hA : 4'b0; // Iniciar rx.
			4'hB: sel_mux = (cs & rd) ? 4'hB : 4'b0; // Leer done.
			4'hC: sel_mux = (cs & wr) ? 4'hC : 4'b0; // Escribir stop.
			default: sel_mux = 4'h0;
		endcase
	end

	//--------------------Control de entrada a la UART
	always @(negedge clk) begin
		tx_led = uart_tx_busy;
		rx_led = uart_rx_busy;
		
		uart_data_in = sel_mux[0] ? data_in[7:0] : uart_data_in;
		init_tx = (~sel_mux[1] & sel_mux[3]) ? 1 : 0;
		init_rx = (sel_mux[1] & sel_mux[3]) ? ~uart_rx_busy : ~uart_rx_busy & init_rx;
		
		stop = (sel_mux[2] & sel_mux[3]) ? 1 : 0;
	end

	//--------------------Control de salida de la UART
	always @(negedge clk) begin
		case (sel_mux)
			4'h2: data_out = uart_data_out;
			4'h4: data_out = uart_tx_busy;
			4'h6: data_out = uart_rx_busy;
			4'hB: data_out = uart_done;
			default: data_out = uart_data_out;
		endcase
	end

	uart uart(.clk(clk), .rst(rst), .init_tx(init_tx), .init_rx(init_rx), .uart_data_in(uart_data_in), .uart_tx(uart_tx), .uart_tx_busy(uart_tx_busy), .uart_data_out(uart_data_out), .uart_rx(uart_rx), .uart_rx_busy(uart_rx_busy), .done(uart_done), .stop(stop));

endmodule

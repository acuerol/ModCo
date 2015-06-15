module peripheral_uart(clk , rst , d_in , cs , addr , rd , wr, d_out,  uart_tx, ledout );
  
	input clk;
	input rst;
	input [15:0]d_in;
	input cs;
	input [3:0]addr; // 4 LSB from j1_io_addr
	input rd;
	input wr;
	
	output reg [15:0]d_out;
	output uart_tx;
	output reg ledout = 0;

	//---------------------------------- regs and wires-------------------------------

	reg [2:0] sel_mux; 	//selector mux_4  and demux_4
	reg [7:0] d_in_uart; // data in uart
	wire uart_busy;  // out_uart

	//------------------------------------ regs and wires-------------------------------

	//----address_decoder------------------
	always @(*) begin
		case (addr)
			4'h0:begin sel_mux = (cs && rd) ? 3'b001 : 3'b000; end //busy
			//Iría el data_in
			4'h2:begin sel_mux = (cs && wr) ? 3'b010 : 3'b000; end //data_out
			4'h4:begin sel_mux = (cs && wr) ? 3'b100 : 3'b000; end //ledout
			default:begin sel_mux = 3'b000; end
		endcase
	end
	//-----------------address_decoder--------------------

	//-------------------- escritura de registros
	always @(negedge clk) begin

		d_in_uart = (sel_mux[1]) ? d_in[7:0] : d_in_uart; // data in uart
		ledout = (sel_mux[2]) ? d_in[0] : ledout;	// write ledout register
		ledout = uart_busy;
	end
	//-------------------- escritura de registros

	//-----------------------mux_4 : multiplexa salidas del periferico
	always @(negedge clk) begin
		case (sel_mux)
			3'b001: d_out[0] = uart_busy;	// data out uart
			default: d_out = 0;
		endcase
	end
	//----------------------------------------------mux_4

										//(addr != 4'h4): se hace para evitar escrituras fantasma
	uart uart(.uart_busy(uart_busy), .uart_tx(uart_tx), .uart_wr_i(cs && wr && (addr != 4'h4) ), .uart_dat_i(d_in_uart), .sys_clk_i(clk), .sys_rst_i(rst));// System clock, 

endmodule

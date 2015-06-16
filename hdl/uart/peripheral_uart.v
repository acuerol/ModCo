module peripheral_uart(
	clk,
	rst,
	d_in,
	
	cs,
	addr,
	rd,
	wr,
	d_out,
	uart_tx,
	
	uart_rx,
	//done,
	
	ledout 
	
	);
  
	input clk;
	input rst;
	input [15:0]d_in;
	input cs;
	input [3:0]addr; // 4 LSB from j1_io_addr
	input rd;
	input wr;
	
	//-----------------rx
	input uart_rx;
	wire [7:0]uart_dat_o;
	wire uart_rx_busy;
	wire done;
	//-----------------rx
	
	output reg [15:0]d_out;
	output uart_tx;
	output reg ledout = 0;

	//---------------------------------- regs and wires-------------------------------

	reg [3:0] sel_mux; 	//selector mux_4  and demux_4
	reg [7:0] d_in_uart; // data in uart
	wire uart_busy;  // out_uart

	//------------------------------------ regs and wires-------------------------------

	//----address_decoder------------------
	always @(*) begin
		case (addr)
			4'h0:begin sel_mux = (cs && rd) ? 4'b0001 : 4'b0000; end //busy
			4'h2:begin sel_mux = (cs && rd) ? 4'b0010 : 4'b0000; end //rx
			4'h4:begin sel_mux = (cs && rd) ? 4'b0100 : 4'b0000; end //done
			4'h6:begin sel_mux = (cs && wr) ? 4'b1000 : 4'b0000; end //data_in!!!
			4'h8:begin sel_mux = (cs && wr) ? 4'b1010 : 4'b0000; end //ledout
			default:begin sel_mux = 4'b0000; end
		endcase
	end
	//-----------------address_decoder--------------------

	//-------------------- escritura de registros
	always @(negedge clk) begin
		d_in_uart = (sel_mux[3]) ? d_in[7:0] : d_in_uart; // data in uart
		// ledout = (sel_mux[2]) ? d_in[0] : ledout; 	// write ledout register 
		ledout = uart_busy | uart_rx_busy; // NO IBA
	end
	//-------------------- escritura de registros

	//-----------------------mux_4 : multiplexa salidas del periferico
	always @(negedge clk) begin
		case (sel_mux)
			4'b0001: d_out[0] = uart_busy | uart_rx_busy;	// data out uart
			4'b0010: d_out = uart_dat_o[7:0]; //rx dato
			4'b0100: d_out[0] = done; //rx done
			default: d_out = 0;
		endcase
	end
	//----------------------------------------------mux_4

										//(addr != 4'h4): se hace para evitar escrituras fantasma
	uart uart(.uart_busy(uart_busy), .uart_tx(uart_tx), .uart_dat_o(uart_dat_o), .uart_rx_busy(uart_rx_busy), .done(done), .uart_wr_i(cs && wr && (addr != 4'h8) ), .uart_rd_i(cs && rd && (addr != 4'h8)), .uart_rx(uart_rx) , .uart_dat_i(d_in_uart), .sys_clk_i(clk), .sys_rst_i(rst));// System clock, 


endmodule

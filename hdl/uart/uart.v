module uart(
	// Outputs
	uart_busy,   // High means UART is transmitting
	uart_tx,     // UART transmit wire
	
	uart_dat_o, //RX
	uart_rx_busy, //RX
	done, //RX
	
	// Inputs
	uart_wr_i,   // Raise to transmit byte
	
	uart_rd_i,	//RX
	uart_rx, //RX
	
	uart_dat_i,  // 8-bit data
	sys_clk_i,   // System clock, 50MHz
	sys_rst_i    // System reset
);

	input uart_wr_i;
	input [7:0]uart_dat_i;
	input sys_clk_i;
	input sys_rst_i;

	//----------------RX
	input uart_rd_i;
	input uart_rx;
	
	output reg [7:0]uart_dat_o;
	
	output uart_rx_busy;
	
	reg [3:0] bitcount_rx;
	
	wire receiving = (bitcount_rx > 0 & bitcount_rx < 12) ? 1 : 0;
	wire uart_rx_busy = (bitcount_rx > 0 & bitcount_rx < 10) ? 1 : 0;
	
	reg [7:0]uart_dat;
	output reg done;
	//----------------RX
	 
	output uart_busy;
	output uart_tx;

	reg [3:0] bitcount;
	reg [8:0] shifter;
	reg uart_tx;

	wire uart_busy = |bitcount[3:1];
	wire sending = |bitcount;

	// sys_clk_i is 50MHz.  We want a 115200Hz clock

	reg [28:0] d;
	wire [28:0] dInc = d[28] ? (115200) : (115200 - 50000000);
	wire [28:0] dNxt = d + dInc;
	wire ser_clk = ~d[28];
  
	always @(posedge sys_clk_i)
		if (sys_rst_i) begin
			d = 0;
		end else begin
			d = dNxt;
		end

	always @(posedge sys_clk_i) begin
		if (sys_rst_i) begin
			uart_tx <= 1;
			bitcount <= 0;
			shifter <= 0;
			
			done <= 0;
			uart_dat <= 0;
			uart_dat_o <= 0;
			bitcount_rx = 0;
		end else begin
		// just got a new byte
			if (uart_wr_i & ~uart_busy) begin
				shifter <= { uart_dat_i[7:0], 1'h0 };
				bitcount <= (1 + 8 + 2);
			end

			if (sending & ser_clk) begin
				{ shifter, uart_tx } <= { 1'h1 , shifter };
				bitcount <= bitcount - 1;
			end
			
			// UART RX
			if(uart_rd_i & ~uart_busy & ~uart_rx_busy & ~uart_rx & ~receiving) begin
				bitcount_rx = 1;
				done <= 0;
				uart_dat <= 0;
				uart_dat_o <= 0;
			end
			
			if(done)
				uart_dat_o <= uart_dat_o;
				
			
			if(~done & receiving & ser_clk) begin
				uart_dat <= {uart_dat, uart_rx};
				bitcount_rx = bitcount_rx + 1;
				done <= 0;
			end
			
			if(~uart_rx_busy & receiving) begin
				done <= 1;
				uart_dat_o <= uart_dat;
			end
			
			if(~uart_rx_busy & receiving & ser_clk) begin
				bitcount_rx = 12;
				done <= 0;
			end
				
		end
	end
  
endmodule

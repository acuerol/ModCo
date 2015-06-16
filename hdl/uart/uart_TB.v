`timescale 1ns / 1ps

`define SIMULATION

module uart_TB;

	reg uart_wr_i;
	reg [7:0] uart_dat_i;
	reg sys_clk_i;
	reg sys_rst_i;
	
	//----------RX
	wire [7:0]uart_dat_o;
	wire uart_rx_busy;
	wire done;
	
	reg uart_rd_i;
	reg uart_rx;
	//----------RX
	
	wire uart_busy;
	wire uart_tx;
	
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;
		
	uart uart(.uart_busy(uart_busy), .uart_tx(uart_tx), .uart_dat_o(uart_dat_o), .uart_rx_busy(uart_rx_busy) , .done(done), .uart_wr_i(uart_wr_i), .uart_rd_i(uart_rd_i), .uart_rx(uart_rx), .uart_dat_i(uart_dat_i), .sys_clk_i(sys_clk_i), .sys_rst_i(sys_rst_i));
	
	initial begin// Initialize Inputs
		sys_clk_i = 0;
		sys_rst_i = 1;
		uart_wr_i = 0;
		uart_dat_i = 0;
		
		uart_rx = 1;
		uart_rd_i = 0;
	end

	initial begin// Process for sys_clk_i
		#OFFSET;
		forever begin
			sys_clk_i = 1'b0;
			#(PERIOD-(PERIOD*DUTY_CYCLE)) sys_clk_i = 1'b1;
			#(PERIOD*DUTY_CYCLE);
		end
	end
	
	initial begin				
		for(i=0; i<20000; i=i+1) begin
			@ (posedge sys_clk_i);
			
			if(i == 10) begin
				sys_rst_i = 1;
			end
			
			if(i == 20) begin
				sys_rst_i = 0;
			end
			
			if(i == 30) begin
				uart_wr_i = 1;
				uart_dat_i = 27;
			end
			
			if(i == 40) begin
				uart_wr_i = 0;
				uart_dat_i = 0;
			end
			
			if(i == 6340) begin
				uart_wr_i = 1;
				uart_dat_i = 30;
			end
			
			if(i == 6350) begin
				uart_wr_i = 0;
				uart_dat_i = 0;
			end
			
			//--------------------RX 10101110 -170
			
			if(i == 11150) begin
				uart_rd_i = 1; // inicio de recepción
			end
			
			if(i == 11520) begin
				uart_rx = 0; // inicio de recepción
			end
			
			if(i == 11954) begin
				uart_rx = 1;
			end
			
			if(i == 12388) begin
				uart_rx = 0;
			end
			
			if(i == 12822) begin
				uart_rx = 1;
			end
			
			if(i == 13256) begin
				uart_rx = 0;
			end
			
			if(i == 13690) begin
				uart_rx = 1;
			end
			
			if(i == 14124) begin
				uart_rx = 1;
			end
			
			if(i == 14558) begin
				uart_rx = 1;
			end
			
			if(i == 14992) begin
				uart_rx = 0;
			end
			// end
			if(i == 15426) begin
				uart_rx = 1;
			end
			//--------------------RX 10101110 -170
		
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("uart_TB.vcd");
	  	$dumpvars(-1, uart_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*60000) $finish;
	end

endmodule

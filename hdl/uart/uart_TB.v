`timescale 1ns / 1ps

`define SIMULATION

module uart_TB;

	reg uart_wr_i;
	reg [7:0] uart_dat_i;
	reg sys_clk_i;
	reg sys_rst_i;
	
	reg [8:0]counter;
	
	wire uart_busy;
	wire uart_tx;
	
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;
		
	uart uart(.uart_busy(uart_busy), .uart_tx(uart_tx), .uart_wr_i(uart_wr_i), .uart_dat_i(uart_dat_i), .sys_clk_i(sys_clk_i), .sys_rst_i(sys_rst_i));
	
	initial begin// Initialize Inputs
		sys_clk_i = 0;
		sys_rst_i = 1;
		uart_wr_i = 0;
		uart_dat_i = 0;
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
		@ (posedge sys_clk_i)
		@ (posedge sys_clk_i)
		sys_rst_i = 0;
				
		for(i=0; i<10000; i=i+1) begin
			@ (posedge sys_clk_i);
			
			if(i == 10) begin
				sys_rst_i=1;
			end
			
			if(i == 20) begin
				sys_rst_i=0;
			end
			
			if(i == 25) begin
				uart_dat_i = 254;
				uart_wr_i = 1;
			end
			
			if(i == 27) begin
				uart_dat_i = 0;
				uart_wr_i = 0;
			end
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("uart_TB.vcd");
	  	$dumpvars(-1, uart_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*15000) $finish;
	end

endmodule

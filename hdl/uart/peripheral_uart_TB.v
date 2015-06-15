`timescale 1ns / 1ps

`define SIMULATION

module peripheral_uart_TB;

	reg clk;
	reg rst;
	reg [15:0]d_in;
	reg cs;
	reg [3:0]addr; // 4 LSB from j1_io_addr
	reg rd;
	reg wr;
	
	wire [15:0]d_out;
	wire uart_tx;
	wire ledout = 0;
	
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;
		
	peripheral_uart p_uart(.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr) , .d_out(d_out) ,  .uart_tx(uart_tx) , .ledout(ledout) );
	
	initial begin// Initialize Inputs
		clk = 1;
		rst = 1;
		d_in = 0;
		cs = 0;
		addr = 3'b000;
		rd = 0;
		wr = 0;
	end

	initial begin// Process for sys_clk_i
		#OFFSET;
		forever begin
			clk = 1'b0;
			#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
			#(PERIOD*DUTY_CYCLE);
		end
	end
	
	initial begin
		@ (posedge clk)
		@ (posedge clk)
		rst = 0;
				
		for(i = 0; i < 10000; i = i+1) begin
			@ (posedge clk);
			
			if(i == 20) begin
				addr = 3'b010;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h26;
			end
			
			if(i == 25) begin
				addr = 3'b010;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h0;
			end
			
			if(i == 30) begin
				addr = 3'b000;
				cs = 0;
				wr = 0;
				rd = 0;
			end
			
			if(i == 7000) begin
				addr = 3'b010;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h2D;
			end
			
			if(i == 7005) begin
				addr = 3'b010;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h0;
			end
			
			if(i == 7010) begin
				addr = 3'b000;
				cs = 0;
				wr = 0;
				rd = 0;
			end
			
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("peripheral_uart_TB.vcd");
	  	$dumpvars(-1, peripheral_uart_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*30000) $finish;
	end

endmodule

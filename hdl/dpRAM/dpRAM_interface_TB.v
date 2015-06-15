`timescale 1ns / 1ps

`define SIMULATION

module dpRAM_interface_TB;

	reg clk;
	reg [15:0]d_in;
	reg cs;
	reg [7:0]addr; // 8 LSB from j1_io_addr
	reg rd;
	reg wr;
	wire [15:0]d_out;
	
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;
		
	dpRAM_interface dpRAM(.clk(clk), .addr(addr), .d_in(d_in), .d_out(d_out), .cs(cs), .wr(wr), .rd(rd));
	
	initial begin// Initialize Inputs
		clk = 1;
		addr = 0;
		cs = 0;
		wr = 0;
		rd = 0;
		d_in = 0;
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
		for(i = 0; i < 10000; i = i+1) begin
			@ (posedge clk);
			
			if(i == 20) begin
				addr = 8'h70;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 4'hC;
			end
			
			if(i == 25) begin
				addr = 8'h70;
				cs = 1;
				wr = 0;
				rd = 1;
				d_in = 4'h0;
			end
			
			if(i == 30) begin
				addr = 8'h70;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 4'hB;
			end
			
			if(i == 35) begin
				addr = 8'h70;
				cs = 1;
				wr = 0;
				rd = 1;
				d_in = 4'h0;
			end
			
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("dpRAM_interface_TB.vcd");
	  	$dumpvars(-1, dpRAM_interface_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*10000) $finish;
	end

endmodule

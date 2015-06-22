`timescale 1ns / 1ps

`define SIMULATION

module indLED_TB;

	reg clk;
	reg rst;
	
	reg cs;
	reg rd;
	reg wr;
	
	reg [3:0]addr;
	
	//--------------------Salidas
	wire led1;
	wire led2;
	
	//--------------------Generar reloj
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;

	event reset_trigger;
		
	indLED ind(.clk(clk) , .rst(rst), .addr(addr), .cs(cs), .rd(rd), .wr(wr), .led1(led1), .led2(led2));
	
	initial begin// Initialize Inputs
		clk = 1;
		rst = 1;
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
		for(i = 0; i < 30000; i = i+1) begin
			@ (posedge clk);
			
			if(i == 5) begin
				rst = 0;
			end
			
			if(i == 20) begin
				addr = 4'h0;
				cs = 1;
				rd = 0;
				wr = 1;
			end
			
			if(i == 25) begin
				addr = 4'h2;
				cs = 1;
				rd = 0;
				wr = 1;
			end
			
			if(i == 30) begin
				addr = 4'h8;
				cs = 1;
				rd = 0;
				wr = 1;
			end
			
			if(i == 35) begin
				addr = 4'h4;
				cs = 1;
				rd = 0;
				wr = 1;
			end
			
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("indLED_TB.vcd");
	  	$dumpvars(-1, indLED_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*10000) $finish;
	end

endmodule

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
	
	//--------rx
	reg uart_rx;
	wire done;
	//--------rx
	
	wire [15:0]d_out;
	wire uart_tx;
	wire ledout = 0;
	
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	reg [10:0] fac;
	reg [20:0] fac2;
	reg [7:0] flag;
	
	event reset_trigger;
		
	peripheral_uart p_uart(.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr) , .d_out(d_out) ,  .uart_tx(uart_tx) , .uart_rx(uart_rx) , .done(done) , .ledout(ledout) );
	
	initial begin// Initialize Inputs
		flag = 0;
		fac = 4000;
		fac2 = 10000;
		
		clk = 1;
		rst = 1;
		d_in = 0;
		cs = 0;
		addr = 3'b000;
		rd = 0;
		wr = 0;
		
		uart_rx=1;
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
				
		for(i = 0; i < 30000; i = i+1) begin
			@ (posedge clk);
			
			if(i == 20) begin
				addr = 4'b0110;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h26;
				uart_rx=1;
			end
			
			if(i == 30) begin
				addr = 4'b0110;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h0;
			end
			
			if(i == 40) begin
				addr = 4'b0000;
				cs = 0;
				wr = 0;
				rd = 0;
			end
			
//			envio 2
			
			if(i == 7000) begin
				addr = 4'b0110;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h2D;
			end
			
			if(i == 7005) begin
				addr = 4'b0110;
				cs = 1;
				wr = 1;
				rd = 0;
				d_in = 8'h0;
			end
			
			if(i == 7010) begin
				addr = 4'b0000;
				cs = 0;
				wr = 0;
				rd = 0;
			end
			
			if(i == 12153) begin
				addr = 4'h2;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
			
			//--------------------RX 10101110 -170
			
			if(i == 11150+fac) begin
				 // inicio de recepción
			end
			
			if(i == 11520+fac) begin
				uart_rx = 0; // inicio de recepción
			end
			
			if(i == 11954+fac) begin
				uart_rx = 1;
			end
			
			if(i == 12388+fac) begin
				uart_rx = 0;
			end
			
			if(i == 12822+fac) begin
				uart_rx = 1;
			end
			
			if(i == 13256+fac) begin
				uart_rx = 0;
			end
			
			if(i == 13690+fac) begin
				uart_rx = 1;
			end
			
			if(i == 14124+fac) begin
				uart_rx = 1;
			end
			
			if(i == 14558+fac) begin
				uart_rx = 1;
			end
			
			if(i == 14992+fac) begin
				uart_rx = 0;
			end
			// end
			if(i == 15426+fac) begin
				uart_rx = 1;
			end
			//--------------------RX  10101110-170
			
			if(i == 19900) begin
				addr = 4'h2;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
			//--------------------RX 00000011 -3
			
			if(i == 11520+fac2) begin
				uart_rx = 0; // inicio de recepción
				flag = 1;
			end
			
			if(i == 11954+fac2) begin
				uart_rx = 0;
				flag = 2;
			end
			
			if(i == 12388+fac2) begin
				uart_rx = 0;
			end
			
			if(i == 12822+fac2) begin
				uart_rx = 0;
			end
			
			if(i == 13256+fac2) begin
				uart_rx = 0;
			end
			
			if(i == 13690+fac2) begin
				uart_rx = 0;
			end
			
			if(i == 14124+fac2) begin
				uart_rx = 0;
			end
			
			if(i == 14558+fac2) begin
				uart_rx = 1;
			end
			
			if(i == 14992+fac2) begin
				uart_rx = 1;
			end
			// end
			if(i == 15426+fac2) begin
				uart_rx = 1;
			end
			//--------------------RX 00000011 -3

		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("peripheral_uart_TB.vcd");
	  	$dumpvars(-1, peripheral_uart_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*60000) $finish;
	end

endmodule

`timescale 1ns / 1ps

`define SIMULATION

module peripheral_uart_TB;

	reg clk;
	reg rst;
	
	reg cs;
	reg rd;
	reg wr;
	
	reg [3:0]addr;
	reg [15:0]data_in;
	reg uart_rx;
	
	//--------------------Salidas
	wire [15:0]data_out;
	wire uart_tx;
	
	wire tx_busy;
	wire rx_busy;
	
	wire rx_led;
	wire tx_led;
	
	//--------------------Generar reloj
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	reg [20:0] fac;
	event reset_trigger;
		
	peripheral_uart p_uart(.clk(clk) , .rst(rst), .addr(addr), .cs(cs), .rd(rd), .wr(wr), .data_in(data_in), .uart_tx(uart_tx), .tx_led(tx_led), .data_out(data_out), .uart_rx(uart_rx), .rx_led(rx_led));
	
	initial begin// Initialize Inputs
		clk = 1;
		rst = 1;
		data_in = 0;
		cs = 0;
		addr = 3'b000;
		rd = 0;
		wr = 0;
		
		uart_rx=1;
		
		fac = 1;
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
			
			if(i == 10) begin
				rst = 0;
			end
			
			//--------------------Envia EE = 11101110
			if(i == 15) begin
				addr = 4'h0;
				cs = 1;
				rd = 0;
				wr = 1;
				data_in = 8'hEE;
			end
			
			if(i == 20) begin
				addr = 4'h8;
				cs = 1;
				rd = 0;
				wr = 1;
				data_in = 0;
			end
			
			if(i == 25) begin
				addr = 4'hC;
				cs = 0;
				rd = 0;
				wr = 0;
				data_in = 0;
			end
			
			//--------------------Envia C2 = 11000010
			if(i == 6000) begin
				addr = 4'h0;
				cs = 1;
				rd = 0;
				wr = 1;
				data_in = 8'hC2;
			end
			
			if(i == 6005) begin
				addr = 4'h8;
				cs = 1;
				rd = 0;
				wr = 1;
				data_in = 0;
			end
			
			if(i == 6015) begin
				addr = 4'hC;
				cs = 1;
				rd = 0;
				wr = 0;
			end
			
			//--------------------Iniciar escucha.
			if(i == 11000+fac) begin
				addr = 4'hA;	
				cs = 1;
				rd = 1;
				wr = 0;
			end
			
			if(i == 11005+fac) begin
				addr = 4'hC;	
				cs = 1;
				rd = 0;
				wr = 0;
			end
			
			//--------------------Rx 10101110 = AE			
			if(i == 11520+fac) begin
				uart_rx = 0; // inicio de recepción
			end
			
			if(i == 11954+fac) begin
				uart_rx = 0;
			end
			
			if(i == 12388+fac) begin
				uart_rx = 1;
			end
			
			if(i == 12822+fac) begin
				uart_rx = 1;
			end
			
			if(i == 13256+fac) begin
				uart_rx = 1;
			end
			
			if(i == 13690+fac) begin
				uart_rx = 0;
			end
			
			if(i == 14124+fac) begin
				uart_rx = 1;
			end
			
			if(i == 14558+fac) begin
				uart_rx = 0;
			end
			
			if(i == 14992+fac) begin
				uart_rx = 1;
			end
			// end
			if(i == 15426+fac) begin
				uart_rx = 1;
			end
			
			//--------------------Iniciar escucha.
			if(i == 20000) begin
				addr = 4'h2;
				cs = 1;
				rd = 1;
				wr = 0;
			end
			
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("peripheral_uart_TB.vcd");
	  	$dumpvars(-1, peripheral_uart_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*60000) $finish;
	end

endmodule

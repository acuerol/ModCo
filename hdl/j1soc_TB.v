
// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

reg sys_clk_i, sys_rst_i;
wire  uart_tx, ledout; 

//----------------------Añadido
reg uart_rx;
reg [30:0] i;
reg [30:0] fac;
//----------------------Añadido

j1soc uut (sys_clk_i, sys_rst_i, uart_tx, uart_rx, rx_led, tx_led);

initial begin
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #10 sys_rst_i = 0;
	
	//----------------------Añadido
	uart_rx = 1; 
	fac = 18480;
	//----------------------Añadido
end

initial begin
		for(i = 0; i < 50000; i = i+1) begin
			@ (posedge sys_clk_i);
			//--------------------RX 10101110 -170
			
			//--------------------Rx 10101110 = AE			
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
		end
end

always sys_clk_i = #1 ~sys_clk_i;


initial begin: TEST_CASE
  $dumpfile("j1soc_TB.vcd");
  $dumpvars(-1, j1soc_TB);
  #90000 $finish;
end

endmodule

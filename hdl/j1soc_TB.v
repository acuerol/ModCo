
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

j1soc uut (
	 uart_tx, uart_rx, ledout, sys_clk_i, sys_rst_i
);

initial begin
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #10 sys_rst_i = 0;
	
	//----------------------Añadido
	uart_rx = 1; 
	fac = 16500;
	//----------------------Añadido
end

initial begin
		for(i = 0; i < 50000; i = i+1) begin
			@ (posedge sys_clk_i);
			//--------------------RX 10101110 -170
			
			
			
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

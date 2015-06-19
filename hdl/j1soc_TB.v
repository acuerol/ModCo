
// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

reg sys_clk_i, sys_rst_i;

wire  uart_tx;
wire tx_led; 
wire rx_led;

wire mod_rst;

reg [30:0] i;

j1soc uut (sys_clk_i, sys_rst_i, uart_tx, uart_rx, rx_led, tx_led, mod_rst);

initial begin
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #10 sys_rst_i = 0;
end

initial begin
		for(i = 0; i < 50000; i = i+1) begin
			@ (posedge sys_clk_i);
			
		end
end

always sys_clk_i = #1 ~sys_clk_i;


initial begin: TEST_CASE
  $dumpfile("j1soc_TB.vcd");
  $dumpvars(-1, j1soc_TB);
  #90000 $finish;
end

endmodule

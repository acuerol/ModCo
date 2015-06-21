
// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

	reg sys_clk_i, sys_rst_i;

	wire  uart_tx;
	wire tx_led; 
	wire rx_led;
	wire mod_rst;

	j1soc uut (sys_clk_i, sys_rst_i, uart_tx, uart_rx, rx_led, tx_led, mod_rst);

	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;
	
	initial begin// Process for sys_clk_i
		#OFFSET;
		forever begin
			sys_clk_i = 1'b0;
			#(PERIOD-(PERIOD*DUTY_CYCLE)) sys_clk_i = 1'b1;
			#(PERIOD*DUTY_CYCLE);
		end
	end

	initial begin
		sys_rst_i = 1;
	end

	initial begin
			for(i = 0; i < 50000; i = i+1) begin
				@ (posedge sys_clk_i);
			
				if(i == 20) begin
					sys_rst_i = 0;
				end
			end
	end

	initial begin: TEST_CASE
	  	$dumpfile("j1soc_TB.vcd");
	  	$dumpvars(-1, j1soc_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*140000) $finish;
	end


endmodule

module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem"       // For simulation         
  )(sys_clk_i, sys_rst_i, uart_tx, uart_rx, rx_led, tx_led, mod_rst);

   input sys_clk_i, sys_rst_i;
   
   output uart_tx;
   output tx_led;
   output rx_led;
	output mod_rst;

	input uart_rx;

//------------------------------------ regs and wires-------------------------------
   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1
 
   reg [3:0]cs;  // CHIP-SELECT

   wire			[15:0] mult_dout;  
   wire			[15:0] div_dout;
   wire			[7:0] uart_dout;
   wire			[15:0] ram_dout;
	wire [15:0]timer_dout;
	wire [7:0]strRAM_dout;
	
	reg csm;
	reg csd;
	reg csu;
	reg cse;
	reg csr;
	reg cst;
	reg css;
	
	
//------------------------------------ regs and wires-------------------------------


	j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

	peripheral_mult  per_m (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(csm), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

	peripheral_div  per_d (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(csd), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

	peripheral_uart  per_u (.clk(sys_clk_i), .rst(sys_rst_i), .addr(j1_io_addr[3:0]), .cs(csu), .rd(j1_io_rd), .wr(j1_io_wr), .data_in(j1_io_dout[7:0]), .uart_tx(uart_tx), .tx_led(tx_led), .data_out(uart_dout), .uart_rx(uart_rx), .rx_led(rx_led));

	peripheral_RAM per_RAM(.clk(sys_clk_i), .addr(j1_io_addr[3:0]), .dat_in(j1_io_dout), .dat_out(ram_dout), .cs(csr), .rd(j1_io_rd), .wr(j1_io_wr));

	peripheral_espDriver per_espD(.clk(sys_clk_i), .sys_rst(sys_rst_i), .addr(j1_io_addr[3:0]), .cs(cse), .rd(j1_io_rd), .wr(j1_io_wr), .mod_rst(mod_rst));
	
	peripheral_timer per_timer(.clk(sys_clk_i), .rst(sys_rst_i), .addr(j1_io_addr[3:0]), .cs(cst), .rd(j1_io_rd), .wr(j1_io_wr), .data_out(timer_dout));
	
	peripheral_strRAM per_strR(.clk(sys_clk_i), .addr(j1_io_addr[3:0]), .dat_in(j1_io_dout[7:0]), .dat_out(strRAM_dout), .cs(css), .rd(j1_io_rd), .wr(j1_io_wr));
	
  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @(*) begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
        8'h67: cs = 4'h1; // mult
        8'h68: cs = 4'h2; // div
        8'h69: cs = 4'h3; // uart
        8'h70: cs = 4'h4; // RAM
        8'h71: cs = 4'h5; // espDriver
        8'h72: cs = 4'h6; // Timer
        8'h73: cs = 4'h7; // strRAM
        default: cs = 4'h0;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //

  // ============== MUX ========================  // se encarga de lecturas del J1
  always @(*) begin
      case (cs)
        4'h1: j1_io_din = mult_dout; 
        4'h2: j1_io_din = div_dout;
        4'h3: j1_io_din = uart_dout; 
        4'h4: j1_io_din = ram_dout; 
        4'h6: j1_io_din = timer_dout;
        4'h7: j1_io_din = strRAM_dout;
        default: j1_io_din = 16'h0666;
      endcase
  end
 // ============== MUX ========================  // 

	always @(*) begin
		csm = (cs == 4'h1) ? 1 : 0;
		csd = (cs == 4'h2) ? 1 : 0;
		csu = (cs == 4'h3) ? 1 : 0;
		cse = (cs == 4'h4) ? 1 : 0;
		csr = (cs == 4'h5) ? 1 : 0;
		cst = (cs == 4'h6) ? 1 : 0;
		css = (cs == 4'h7) ? 1 : 0;
	end
endmodule // top

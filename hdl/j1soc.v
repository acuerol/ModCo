module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem"       // For simulation         
  )(sys_clk_i, sys_rst_i, uart_tx, uart_rx, rx_led, tx_led);

   input sys_clk_i, sys_rst_i;
   
   output uart_tx;
   output tx_led;
   output rx_led;

	input uart_rx;

//------------------------------------ regs and wires-------------------------------
   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1
 
   reg [1:4]cs;  // CHIP-SELECT

   wire			[15:0] mult_dout;  
   wire			[15:0] div_dout;
   wire			[7:0] uart_dout;
   wire			[15:0] ram_dout;
//------------------------------------ regs and wires-------------------------------


  j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

  peripheral_mult  per_m (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[1]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

  peripheral_div  per_d (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[2]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

  peripheral_uart  per_u (.clk(sys_clk_i), .rst(sys_rst_i), .addr(j1_io_addr[3:0]), .cs(cs[3]), .rd(j1_io_rd), .wr(j1_io_wr), .data_in(j1_io_dout), .uart_tx(uart_tx), .tx_led(tx_led), .data_out(uart_dout), .uart_rx(uart_rx), .rx_led(rx_led));

  peripheral_RAM Rm(.clk(sys_clk_i), .addr(j1_io_addr[3:0]), .dat_in(j1_io_dout), .dat_out(ram_dout), .cs(cs[4]), .rd(j1_io_rd), .wr(j1_io_wr));


  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @*
  begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
        8'h67: cs = 4'b1000; 		//mult
        8'h68: cs = 4'b0100;		//div
        8'h69: cs = 4'b0010;		//uart
        8'h70: cs = 4'b0001;		//ram
        default: cs = 3'b000;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //

  // ============== MUX ========================  // se encarga de lecturas del J1
  always @*
  begin
      case (cs)
        4'b1000: j1_io_din = mult_dout; 
        4'b0100: j1_io_din = div_dout;
        4'b0010: j1_io_din = uart_dout; 
        4'b0001: j1_io_din = ram_dout; 
        default: j1_io_din = 16'h0666;
      endcase
  end
 // ============== MUX ========================  // 

endmodule // top

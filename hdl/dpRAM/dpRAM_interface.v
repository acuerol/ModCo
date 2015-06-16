module dpRAM_interface(clk, addr, dat_in, dat_out, cs, wr, rd);
  
	input clk;
	input [15:0]dat_in;
	input cs;
	input [3:0]addr; // 8 LSB from j1_io_addr
	input rd;
	input wr;
	
	reg init;
	
	output reg [15:0]dat_out;

	reg [3:0]sel_mux;

	//------------------------------------ regs and wires-------------------------------
	reg [15:0]mem_dat_in;
	reg [7:0]mem_addr;
	wire [15:0]mem_dat_out;
	//------------------------------------ regs and wires-------------------------------
	
	always @(*) begin
		case(addr)
			4'h0: begin sel_mux = (cs && wr) ? 4'h1 : 4'h0; end //write dat
			4'h2: begin sel_mux = (cs && rd) ? 4'h2 : 4'h0; end //read dat
			4'h4: begin sel_mux = (cs && wr) ? 4'h4 : 4'h0; end //set_addr
			4'h8: begin sel_mux = (cs) ? 4'h8 : 4'h0; end //init
			default: begin sel_mux = 4'h0; end
		endcase
	end

	always @(negedge clk) begin
		mem_dat_in = (sel_mux[0]) ? dat_in : mem_dat_in;
		dat_out = (sel_mux[1]) ? mem_dat_out : dat_out;
		mem_addr = (sel_mux[2]) ? dat_in : mem_addr;
		init = sel_mux[3];
	end

	dualport_RAM dlptRAM(.clk(clk), .init(init), .mem_dat_in(mem_dat_in), .mem_dat_out(mem_dat_out), .mem_addr(mem_addr), .rd(cs && rd), .wr(cs && wr));	
endmodule

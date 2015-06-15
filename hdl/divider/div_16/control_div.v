module control_div( clk, rst , start, msb, z, init, sh, dec, load_A, done, dv0);
	input clk;
	input rst;
	input start;
	input msb;
	input z;

	output reg init;
	output reg dv0;
	output reg sh;
	output reg dec;
	output reg load_A;
	output reg done;

	parameter START 		= 3'b000;
	parameter SHIFT_DEC = 3'b001;
	parameter CHECK 		= 3'b010;
	parameter ADD 			= 3'b011;
	parameter LOAD 			= 3'b101; //agregado
	parameter END 			= 3'b100;
 
	reg [2:0] state;
 
	initial begin
		init = 1;
		dv0 = 0;
		sh = 0;
		dec = 0;
		load_A = 0;
		done = 0;
	end

	reg [3:0] count;

	always @(posedge clk) begin
		if (rst) begin
			state = START;
		end 
		else begin
			case(state)
				START: begin
					count = 0;
					if(start)
						state = SHIFT_DEC;
					else
						state = START;
				end
				
				SHIFT_DEC:
					state = CHECK;
					
				CHECK: 
					if(z)
						state = END;
					else begin 
						if (msb == 0)
							state = ADD;
						else
							state = SHIFT_DEC;
					end
					
				ADD: 
					state = LOAD;
					
				LOAD:
					if(z)
						state = END;
					else
						state = SHIFT_DEC;
						
				END:begin
					count = count + 1;
					state = (count > 9) ? START : END ; // hace falta de 10 ciclos de reloj, para que lea el done y luego cargue el resultado
				end
				
				default: state = START;
			endcase
		end
	end

	always@(state) begin
		case(state)
		
			START:begin
				init = 1;
				dv0 = 0;
				sh = 0;
				dec = 0;
				load_A = 0;
				done = 0;
			end
			
			SHIFT_DEC:begin
				init = 0;
				dv0 = 0; // (estaba dv0 = dv0) revisar, deberia ser = 0, puesto que solo se llega desde START, CHECK y LOAD, desde los cuales vale 0, 0 y 0.
				sh = 1;
				dec = 1;
				load_A = 0;
				done = 0;
			end
			
			CHECK:begin
				init = 0;
				dv0 = 0;
				sh = 0;
				dec = 0;
				load_A = 0;
				done = 0;
			end
			
			ADD:begin
				init = 0;
				dv0 = 1; // primero suma
				sh = 0;
				dec = 0;
				load_A = 0;
				done = 0;
			end
			
			LOAD:begin
				init = 0;
				dv0 = 0;
				sh = 0;
				dec = 0;
				load_A = 1; // ahora carga el resultado
				done = 0;
			end
			
			END:begin
				init = 0;
				dv0 = 0;
				sh = 0;
				dec = 0;
				load_A = 0;
				done = 1;
			end
			
			default:begin
				init = 1;
				dv0 = 0;
				sh = 0;
				dec = 0;
				load_A = 0;
				done = 0;
			end
		endcase
	end
endmodule

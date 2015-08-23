`include "commands.vh"

module communication(
	output reg transmit,
	output reg [7:0] tx_byte,
	input wire received,
	input wire [7:0] rx_byte,

	output reg en,
	output wire [31:0] m,
	output reg set	

);

reg [7:0] state=`COMMAND;
reg [7:0] command=0;
reg [7:0] m0, m1, m2, m3;

assign m = {m3, m2, m1, m0};

always @ (posedge received)
begin
	case(state)
		`COMMAND: begin
				command <= rx_byte;
				case(command)
					`BYTE0: state = `DATA;
					`BYTE1: state = `DATA;
					`BYTE2: state = `DATA;
					`BYTE3: state = `DATA;
					`ENABLE: begin
							en = 1; 
							state = `COMMAND;
						end
					`DISABLE: begin
							en = 0; 
							state = `COMMAND;
						end
					`SET: 	begin
							set<=1;
							set<=0;
						end
					default: state = `COMMAND;
				endcase
			end
		`DATA: 	begin	
				case(command)
					`BYTE0: m0 = rx_byte;
					`BYTE1: m1 = rx_byte;
					`BYTE2: m2 = rx_byte;
					`BYTE3: m3 = rx_byte;
				endcase
				state = `COMMAND;
			end
	endcase
end

endmodule

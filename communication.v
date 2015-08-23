`include "commands.vh"

module communication(
	input wire clk,
	output reg transmit,
	output reg [7:0] tx_byte,
	input wire received,
	input wire [7:0] rx_byte,

	output reg en=0,
	output wire [31:0] m,
	output reg set=0	

);

reg [7:0] state=`COMMAND;
reg [7:0] command=0;
reg [7:0] m0=0, m1=0, m2=0, m3=0;
reg gen_pulse=0;

assign m = {m3, m2, m1, m0};


// state machine to receive data from the UART
always @ (posedge received)
begin
	case(state)
		`COMMAND: begin
				command = rx_byte;
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
							gen_pulse=1;
							state = `COMMAND;
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

// pulse generator for the 'set' output
// to generate a pulse, the 'gen_pulse' reg is set to 1
// and the following code generates the pulse during one clock cycle
always @ (posedge clk)
begin
	if (gen_pulse==1)
	begin
		gen_pulse=0;
		set=1;
	end
end

always @ (negedge clk) begin
	set=0;
end

// end of pulse generator

endmodule

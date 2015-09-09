`include "commands.vh"

module communication(
	input wire clk,
	output reg transmit=0,
	output reg [7:0] tx_byte=0,
	input wire received,
	input wire [7:0] rx_byte,

	output reg en=0,
	output wire [31:0] m,
	output reg set=0,
	output reg error=0
);

reg [7:0] state=0;
reg [7:0] command=0;
reg [7:0] m0=0, m1=0, m2=0, m3=0;
reg [23:0] count=0;

assign m = {m3, m2, m1, m0};


// state machine to receive data from the UART
always @ (posedge clk)
begin
	case(state)
		0: begin
			if (received == 1) begin
				case(rx_byte)
					`BYTE0:	begin
							command = rx_byte;
							state=1;
						end
					`BYTE1:	begin
							command = rx_byte;
							state=1;
						end
					`BYTE2: begin
							command = rx_byte;
							state=1;
						end
					`BYTE3:	begin
							command = rx_byte;
							state=1;
						end
					`ENABLE: state = 2;
					`DISABLE: state = 3;
					`SET: state = 4;
					default: state = 8;
				endcase
			end
		end
		1: begin
			if (received == 1)
			begin
				case(command)
					`BYTE0: m0 = rx_byte;
					`BYTE1: m1 = rx_byte;
					`BYTE2: m2 = rx_byte;
					`BYTE3: m3 = rx_byte;
				endcase
				state=6;
			end
		end
		2: begin
			en=1;
			state=6;
		end
		3: begin
			en=0;
			state=6;
		end
		4: begin
			set=1;
			state=5;
		end
		5: begin
			set=0;
			state=6;
		end
		6: begin
			tx_byte=`ACK;
			transmit=1;
			state=7;
		end
		7: begin
			transmit=0;
			state=0;
		end
		8: begin // error state
			error=1;
			count=count+1;
			if (count>12000000) state=9;
		end
		9: begin
			error=0;
			count=0;
			state=0;
		end
	endcase
end

always @ (posedge received) error=0;

endmodule

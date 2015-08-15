module dds(clk, out);
input clk;
output [7:0] out;
wire [7:0] out;
reg [31:0] phase_acc=0;
wire [31:0] m;

always @ (posedge clk)
	phase_acc <= phase_acc + m;

assign out = phase_acc[31:24];
assign m = 157482;	// tuning word for a frequency of 440 Hz (m = 2^32 * 440 Hz / 12 MHz)

endmodule

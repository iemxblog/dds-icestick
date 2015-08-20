module dds(
	input wire clk, 
	output wire [7:0] out
);
reg [31:0] phase_acc=0;
wire [31:0] m;
wire [7:0] phase;


always @ (posedge clk)
	phase_acc <= phase_acc + m;

assign phase = phase_acc[31:24];
assign m = 157482;	// tuning word for a frequency of 440 Hz (m = 2^32 * 440 Hz / 12 MHz)

sine_lut sine(.addr(phase), .s(out));

endmodule

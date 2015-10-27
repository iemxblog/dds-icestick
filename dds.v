module dds(
	input wire clk, 
	input wire en,
	input wire [39:0] m,
	input wire set,	
	output wire [7:0] out
);
reg [39:0] phase_acc=0;	// phase accumulator
wire [7:0] phase;	// top 8 bits of the phase, to send to the lookup table
reg [39:0] mem_m=0;	// memorized tuning word 'm'
wire [7:0] lut_out;

always @ (posedge set)
	mem_m = m;

always @ (posedge clk)
	phase_acc <= phase_acc + mem_m;

assign phase = phase_acc[39:32];

sine_lut sine(.addr(phase), .s(lut_out));

assign out = en ? lut_out : 0;

endmodule

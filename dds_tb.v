`timescale 1ns/1ps	// reference time = 1ns, precision value = 1ps 
module dds_tb;
	initial begin
		$dumpfile("dds.vcd");
		$dumpvars(0, dds_tb);
		# 13636363 $finish;	// 13 636 363 ns = 6 periods of the 440 Hz signal
	end

	reg clk=0;
	reg en = 0;
	reg [31:0] m = 157482;	// tuning word for a frequency of 440 Hz (m = 2^32 * 440 Hz / 12 MHz)
	reg set = 0;

	always #41.666 clk = !clk;	// 41.666 ns = a half period of the 12MHz clock

	initial begin
		# 4545454 en=1;
		set=1;
		# 1 set = 0;
		# 2272727 m=314964; // tuning word for a frequency of 880Hz
		# 2272727 set = 1; 
		# 1 set=0;
	end

	wire [7:0] dds_out;
	dds dds1 (.clk(clk), .en(en), .m(m), .set(set), .out(dds_out));	// instantiation of the dds

endmodule

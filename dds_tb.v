`timescale 1ns/1ps	// reference time = 1ns, precision value = 1ps 
module test;
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0, test);
		# 200000 $finish;	// 200 000 ns = 2 periods of the 10kHz signal
	end

	reg clk=0;
	always #41.666 clk = !clk;	// 41.666 ns = a half period of the 12MHz clock

	wire [7:0] dds_out;
	dds dds1 (clk, dds_out);	// instantiation of the dds

endmodule

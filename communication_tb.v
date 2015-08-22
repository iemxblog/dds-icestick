`timescale 1ns/1ps	// reference time = 1ns, precision value = 1ps 
module communication_tb;
	initial begin
		$dumpfile("communication.vcd");
		$dumpvars(0, communication_tb);
		# 13636363 $finish;	// 13 636 363 ns = 6 periods of the 440 Hz signal
	end

	reg clk=0;

	always #41.666 clk = !clk;	// 41.666 ns = a half period of the 12MHz clock

	initial begin
		
	end

endmodule

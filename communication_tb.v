`timescale 1ns/1ps	// reference time = 1ns, precision value = 1ps 
`include "commands.vh"

module communication_tb;
	initial begin
		$dumpfile("communication.vcd");
		$dumpvars(0, communication_tb);
		# 13636363 $finish;	// 13 636 363 ns = 6 periods of the 440 Hz signal
	end

	reg clk=0;

	always #41.666 clk = !clk;	// 41.666 ns = a half period of the 12MHz clock

	wire transmit;
	wire [7:0] tx_byte;
	reg received;
	reg [7:0] rx_byte;	
	wire en;
	wire [31:0] m;
	wire set;

	reg [31:0] m2=157482; // value of m to send

	initial begin
		#10 rx_byte = `BYTE0;
		#1 received = 1;
		#1 received = 0;		
		#1 rx_byte = m2[7:0];
		#1 received = 1;
		#1 received = 0;
		
		#1 rx_byte = `BYTE1;
		#1 received = 1;
		#1 received = 0;		
		#1 rx_byte = m2[15:8];
		#1 received = 1;
		#1 received = 0;

		#1 rx_byte = `BYTE2;
		#1 received = 1;
		#1 received = 0;		
		#1 rx_byte = m2[23:16];
		#1 received = 1;
		#1 received = 0;

		#1 rx_byte = `BYTE3;
		#1 received = 1;
		#1 received = 0;		
		#1 rx_byte = m2[31:24];
		#1 received = 1;
		#1 received = 0;

		#1 rx_byte = `SET;
		#1 received = 1;
		#1 received = 0;

		#1 rx_byte = `ENABLE;
		#1 received = 1;
		#1 received = 0;
	end

	communication com(.clk(clk), .transmit(transmit), .tx_byte(tx_byte), .received(received), .rx_byte(rx_byte), .en(en), .m(m), .set(set));

endmodule

`timescale 1ns/1ps	// reference time = 1ns, precision value = 1ps 
`include "commands.vh"

`define H_PERIOD 41.666
`define PERIOD 83.333
`define PERIOD10 833.33

module communication_tb;
	initial begin
		$dumpfile("communication.vcd");
		$dumpvars(0, communication_tb);
		# 1100000000 $finish;	// 1 100 000 000 ns = 1.1s	
	end

	reg clk=0;

	always #`H_PERIOD clk = !clk;	// 41.666 ns = a half period of the 12MHz clock

	wire transmit;
	wire [7:0] tx_byte;
	reg received;
	reg [7:0] rx_byte;	
	wire en;
	wire [39:0] m;
	wire set;
	wire error;

	reg [39:0] m2=40315426; // value of m to send (for 440 Hz)

	initial begin
		#`PERIOD10 rx_byte = `BYTE0;
		#`PERIOD received = 1;
		#`PERIOD received = 0;		
		#`PERIOD10 rx_byte = m2[7:0];
		#`PERIOD received = 1;
		#`PERIOD received = 0;
		
		#`PERIOD10 rx_byte = `BYTE1;
		#`PERIOD received = 1;
		#`PERIOD received = 0;		
		#`PERIOD10 rx_byte = m2[15:8];
		#`PERIOD received = 1;
		#`PERIOD received = 0;

		#`PERIOD10 rx_byte = `BYTE2;
		#`PERIOD received = 1;
		#`PERIOD received = 0;		
		#`PERIOD10 rx_byte = m2[23:16];
		#`PERIOD received = 1;
		#`PERIOD received = 0;

		#`PERIOD10 rx_byte = `BYTE3;
		#`PERIOD received = 1;
		#`PERIOD received = 0;		
		#`PERIOD10 rx_byte = m2[31:24];
		#`PERIOD received = 1;
		#`PERIOD received = 0;

		#`PERIOD10 rx_byte = `BYTE4;
		#`PERIOD received = 1;
		#`PERIOD received = 0;		
		#`PERIOD10 rx_byte = m2[39:32];
		#`PERIOD received = 1;
		#`PERIOD received = 0;

		#`PERIOD10 rx_byte = `SET;
		#`PERIOD received = 1;
		#`PERIOD received = 0;

		#`PERIOD10 rx_byte = `ENABLE;
		#`PERIOD received = 1;
		#`PERIOD received = 0;
		
		#`PERIOD10 rx_byte = 0; // generate an error
		#`PERIOD received = 1;
		#`PERIOD received = 0;

	end

	communication com(.clk(clk), .transmit(transmit), .tx_byte(tx_byte), .received(received), .rx_byte(rx_byte), .en(en), .m(m), .set(set), .error(error));

endmodule

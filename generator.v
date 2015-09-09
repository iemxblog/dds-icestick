module generator(
	input clk,
	input rx,
	output tx,
	output led1,
	output led2,
	output led3,
	output led4,
	output led5,
	output wire [7:0] out
);

wire transmit;
wire received;
wire [7:0] tx_byte;
wire [7:0] rx_byte;
wire is_receiving;
wire is_transmitting;

uart #(
	.baud_rate(9600), 
	.sys_clk_freq(12000000)
) 
uart0(	
	.clk(clk), 
	.rx(rx), 
	.tx(tx), 
	.transmit(transmit), 
	.tx_byte(tx_byte), 
	.received(received), 
	.rx_byte(rx_byte), 
	.is_transmitting(is_transmitting), 
	.is_receiving(is_receiving)
);

assign led5 = en;
assign led4 = 0;
assign led3 = error;
assign led2 = is_transmitting;
assign led1 = is_receiving;

wire en;
wire [31:0] m;
wire set;
wire error;

communication com(
	.clk(clk), 
	.transmit(transmit), 
	.tx_byte(tx_byte), 
	.received(received), 
	.rx_byte(rx_byte), 
	.en(en), 
	.m(m), 
	.set(set), 
	.error(error)
);

dds dds(
	.clk(clk), 
	.en(en), 
	.m(m), 
	.set(set), 
	.out(out)
);

endmodule

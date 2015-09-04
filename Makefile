all: dds.vcd communication.vcd generator

dds: dds.v sine_lut.v dds_tb.v
	iverilog -o dds dds.v sine_lut.v dds_tb.v

dds.vcd: dds
	vvp dds

communication: communication.v communication_tb.v commands.vh
	iverilog -o communication communication.v communication_tb.v

communication.vcd: communication
	vvp communication

generator: generator.v communication.v commands.vh dds.v sine_lut.v uart.v
	iverilog -o generator generator.v communication.v dds.v sine_lut.v uart.v

sim_dds: dds.vcd
	gtkwave dds.vcd

sim_com: communication.vcd
	gtkwave communication.vcd

clean:
	rm -f dds communication *.vcd

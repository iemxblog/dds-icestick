all: dds.vcd communication.vcd

dds: dds.v sine_lut.v dds_tb.v
	iverilog -o dds dds.v sine_lut.v dds_tb.v

dds.vcd: dds
	vvp dds

communication: communication.v communication_tb.v
	iverilog -o communication communication.v communication_tb.v

communication.vcd: communication
	vvp communication

sim: dds.vcd
	gtkwave dds.vcd

clean:
	rm -f dds communication *.vcd

all: test.vcd

dds: dds.v sine_lut.v dds_tb.v
	iverilog -o dds dds.v sine_lut.v dds_tb.v

test.vcd: dds
	vvp dds

sim: test.vcd
	gtkwave test.vcd

clean:
	rm -f dds test.vcd

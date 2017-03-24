### Simulation ###

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

### Icestorm toolchain ###

generator.blif: generator.v
	yosys -p "read_verilog generator.v dds.v communication.v uart.v sine_lut.v; synth_ice40 -blif generator.blif"

generator.txt: generator.blif
	arachne-pnr -d 1k -p generator.pcf -o generator.txt generator.blif

generator.bin: generator.txt
	icepack generator.txt generator.bin

prog:	generator.bin
	iceprog generator.bin

clean:
	rm -f dds communication *.vcd                       # Delete simulation files
	rm -f generator.blif generator.txt generator.bin    # Delete Icestorm toolchain files

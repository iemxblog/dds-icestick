module pulse_gen(
	input clk
	, input start
	, output reg pulse=0
);

// This module generates a pulse during 1 clock cycle.
// The pulse is generated after a rising edge on 'start' input.

reg start_mem = 0;

always @ (posedge clk)
begin
	if (start_mem == 1)
	begin
		pulse = 1;
		start_mem = 0;
	end
end

always @ (negedge clk)
begin
	pulse=0;
end

always @ (posedge start)
begin
	start_mem = 1;
end

endmodule

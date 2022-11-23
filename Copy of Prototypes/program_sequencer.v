module program_sequencer
(
	input wire clk, sync_reset,
	input wire jmp, jmp_nz, dont_jump,
	input wire [3:0] jmp_addr,
	output reg [7:0] pm_addr, pc 
);

always @ (posedge clk)
	pc = pm_addr;

always @ (*)
	if (sync_reset == 1'd1)
		pm_addr = 8'H00;
	else if (jmp == 1'd1)
		pm_addr = {jmp_addr, 4'H0};
	else if (jmp_nz == 1'd1 && dont_jump == 1'd0)
		pm_addr = {jmp_addr, 4'H0};
	else
		pm_addr = pc + 8'H01;

endmodule
	
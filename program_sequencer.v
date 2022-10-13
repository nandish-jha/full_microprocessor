module program_sequencer
(
	input clk, sync_reset,
	input jmp, jmp_nz, dont_jump,
	input [3:0] jmp_addr,
	output reg [7:0] pm_addr, pc,

	// for final exam
	output reg [7:0] from_PS
);

//always @ *					// for final exam
//	from_PS = pc;			// change to "from_PS = 8'h0" upon entering the exam

always @ *
	from_PS = 8'h0;

always @ (posedge clk)
	pc = pm_addr;

always @ (*)
	if (sync_reset == 1'd1)
		pm_addr = 8'h00;
	else if (jmp == 1'd1)
		pm_addr = {jmp_addr, 4'h0};
	else if (jmp_nz == 1'd1 && dont_jump == 1'd0)
		pm_addr = {jmp_addr, 4'h0};
	else
		pm_addr = pc + 8'h01;

endmodule
	
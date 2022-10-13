module microprocessor
(
	input clk, reset,
	input [3:0] i_pins,
	output [3:0] o_reg,

	// for final exam
	output [8:0] reg_en,
	output [3:0] x0, x1, y0, y1, r, m, i,
	output zero_flag, NOPC8, NOPCF, NOPD8, NOPDF,
	output [7:0] pm_data, pm_address, from_PS, from_ID, from_CU, pc, ir
//	output [3:0] LS_nibble_ir, dm, source_select, data_mem_addr, data_bus
);

wire jump, conditional_jump, i_mux_select, y_reg_select, x_reg_select;
wire [3:0] LS_nibble_ir, dm, source_select, data_mem_addr, data_bus;
// wire [7:0] pm_address, pm_data;
// wire [8:0] reg_enables;
// wire zero_flag;

reg sync_reset;

always @ (posedge clk)
	sync_reset <= reset;

program_sequencer prog_sequencer
(
	// input
	.clk(clk),
	.sync_reset(sync_reset),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.jmp_addr(LS_nibble_ir),
	.dont_jump(zero_flag),

	// output
	.pm_addr(pm_address),
	
	// for final exam
	.from_PS(from_PS),
	.pc(pc)
);

computational_unit comp_unit
(
	// input
	.clk(clk),
	.sync_reset(sync_reset),
	.i_pins(i_pins),
	.dm(dm),
	.ir_nibble(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_en),

	// output
	.r_eq_0(zero_flag),
	// .i(data_mem_addr),
	.data_bus(data_bus),
	.o_reg(o_reg),
	
	// for final exam
	.from_CU(from_CU),
	.x0(x0),
	.x1(x1),
	.y0(y0),
	.y1(y1),
	.r(r),
	.m(m),
	.i(i)
);

instruction_decoder instr_decoder
(
	// input
	.clk(clk),
	.sync_reset(sync_reset),
	.next_instr(pm_data),

	// output
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.ir_nibble(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_en),
	
	// for final exam
	.from_ID(from_ID),
	.ir(ir),
	.NOPC8(NOPC8),
	.NOPCF(NOPCF),
	.NOPD8(NOPD8),
	.NOPDF(NOPDF)
);

data_memory data_mem
(
	// input
	.clock(~clk),
	.address(i),
//	.address(data_mem_addr),
	.data(data_bus),
	.wren(reg_en[7]),

	// output
	.q(dm)
);

program_memory prog_mem
(
	// input
	.clock(~clk),
	.address(pm_address),

	// output
	.q(pm_data)
);

endmodule

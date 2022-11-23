module microprocessor
(
	input clk, reset,
	input [3:0] i_pins,
	output [3:0] o_reg
);

wire jump, conditional_jump, zero_flag, i_mux_select, y_reg_select, x_reg_select;
wire [3:0] LS_nibble_ir, dm, source_select, data_mem_addr, data_bus;
wire [7:0] pm_address, pm_data;
wire [8:0] reg_enables;

reg sync_reset;
always @ (posedge clk)
	sync_reset <= reset;

program_sequencer prog_sequencer
(
	//input
	.clk(clk),
	.sync_reset(sync_reset),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.jmp_addr(LS_nibble_ir),
	.dont_jmp(zero_flag),

	//output
	.pm_addr(pm_address)
);

computational_unit comp_unit
(
	//input
	.clk(clk),
	.sync_reset(sync_reset),
	.i_pins(i_pins),
	.dm(dm),
	.nibble_ir(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_enables),

	//output
	.r_eq_0(zero_flag),
	.i(data_mem_addr),
	.data_bus(data_bus),
	.o_reg(o_reg)
);

instruction_decoder instr_decoder
(
	//input
	.clk(clk),
	.sync_reset(sync_reset),
	.next_instr(pm_data),

	//output
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.ir_nibble(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_enables)
);

data_memory data_mem
(
	//input
	.clk(~clk),
	.addr(data_mem_addr),
	.data_in(data_bus),
	.w_en(reg_enables[7]),

	//output
	.data_out(dm)
);

program_memory prog_mem
(
	//input
	.clk(~clk),
	.addr(pm_address),

	//output
	.data(pm_data)
);

endmodule

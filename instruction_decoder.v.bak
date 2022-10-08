module instruction_decoder
(
	input clk, sync_reset,
   input wire [7:0] next_instr,
	output reg jmp, jmp_nz, i_sel, y_sel, x_sel,
   output reg [3:0] source_sel, ir_nibble,
   output reg [8:0] reg_en
);

reg [7:0] ir;

always @ (posedge clk)
    ir <= next_instr;

always @ *
    ir_nibble <= ir[3:0];

// i select
always @ *
	if (sync_reset == 1'b1)	
		i_sel <= 1'b0; // do not jump when reset
	// next else-if conditions in order (ir values)
	// 1. load with destination i (0110)
	// 2. move with destination i (10_110)
	else if ((ir[7:4] == 4'b0110) || (ir[7:3] == 5'b10_110))
		i_sel <= 1'b0;
	else 
		i_sel <= 1'b1;

// x select
always @ *
	if (sync_reset == 1'b1)
		x_sel <= 1'b0;
	// selecting x for ALU op. (1101)
	else if (ir[7:4] == 4'b1101)
		x_sel <= 1'b1;
	else
		x_sel <= 1'b0;

// y select
always @ *
	if (sync_reset == 1'b1)
		y_sel <= 1'b0;
	// selecting y for ALU op. (110x1)
	else if (ir[7:3] == 5'b110x1)
		y_sel <= 1'b1;
	else
		y_sel <= 1'b0;

// source select
always @*
	if (sync_reset == 1'b1)
    	source_sel <= 4'd10;
	else if (ir[7] == 1'b0) // when load instructions source select will select pm_data 
    	source_sel <= 4'd8;
	else if (ir [7:6] == 2'b10) // when move instructions 
    	if(ir [5:3] == ir [2:0]) // and src = to dst 
        	if ((ir [2:0] == 3'd4) || (ir [5:3] == 3'd4)) // and src or dst = to 4 ==> source select will select r 
            	source_sel <= 4'd4;
        	else // if src or dst not = to 4 ==> source select will select i_pins 
            	source_sel <= 4'd9;
   		else // when move instruction but dst not equal to src soure select will be equal to src and we add msb to be 0 while src only 3 bits 
        	source_sel <= {1'b0 , ir [2:0] };
	else
    	source_sel <= 4'd10;

// jump instruction
always @ *
	if (sync_reset == 1'b1)
		jmp <= 1'b0;
	else if (ir[7:4] == 4'HE)
		jmp <= 1'b1;
	else
		jmp <= 1'b0;

// jump not zero instruction
always @ *
	if (sync_reset == 1'b1)
		jmp_nz <= 1'b0;
	else if (ir[7:4] == 4'HF)
		jmp_nz <= 1'b1;
	else 
		jmp_nz <= 1'b0;

// reg_en[0], x0
always @ *
	if (sync_reset == 1'b1) 
		reg_en[0] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination x0 (0000)
	// 2. move with destination x0 (10_000)
	else if ((ir[7:4] == 4'b0000) || (ir[7:3] == 5'b10_000))
		reg_en[0] <= 1'b1;
	else
		reg_en[0] <= 1'b0;

// reg_en[1] = x1
always @ *
	if (sync_reset == 1'b1)
		reg_en[1] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination x1 (0001)
	// 2. move with destination x1 (10_001)
	else if ((ir[7:4] == 4'b0001) || (ir[7:3] == 5'b10_001))
		reg_en[1] <= 1'b1;
	else
		reg_en[1] <= 1'b0;

// reg_en[2] = y0
always @ *
	if (sync_reset == 1'b1) 
		reg_en[2] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination y0 (0010)
	// 2. move with destination y0 (10_010)
	else if ((ir[7:4] == 4'b0010) || (ir[7:3] == 5'b10_010))
		reg_en[2] <= 1'b1;
	else
		reg_en[2] <= 1'b0;

// reg_en[3] = y1
always @ *
	if (sync_reset == 1'b1) 
		reg_en[3] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination y1 (0011)
	// 2. move with destination y1 (10_011)
	else if ((ir[7:4] == 4'b0011) || (ir[7:3] == 5'b10_011))
		reg_en[3] <= 1'b1;
	else
		reg_en[3] <= 1'b0;

// reg_en[4] = r
always @ *
	if (sync_reset == 1'b1) 
		reg_en[4] <= 1'b1;
	// result of ALU op. stored in r (110)
	else if (ir[7:5] == 3'b110)
		reg_en[4] <= 1'b1;
	else
		reg_en[4] <= 1'b0;

// reg_en[5] = m
always @ *
	if (sync_reset == 1'b1) 
		reg_en[5] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination m (0101)
	// 2. move with destination m (10_101)
	else if ((ir[7:4] == 4'b0101) || (ir[7:3] == 5'b10_101))
		reg_en[5] <= 1'b1;
	else
		reg_en[5] <= 1'b0;

// reg_en[6] = i
always @ *
	if (sync_reset == 1'b1) 
		reg_en[6] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination i (0110)
	// 2. load with destination dm (0111)
	// 3. move with destination i (10_110)
	// 4. move with destination dm (10_111)
	// 5. move with source dm (10_xxx_111 - 3'd7 and 2'd2)
	else if ((ir[7:4] == 4'b0110) || (ir[7:4] == 4'b0111) || (ir[7:3] == 5'b10_110) || (ir[7:3] == 5'b10_111) || ((ir[7:6] == 2'b10) && (ir[2:0] == 3'b111)))
		reg_en[6] <= 1'b1;
	else
		reg_en[6] <= 1'b0;

// reg_en[7] = dm
always @ *
	if (sync_reset == 1'b1) 
		reg_en[7] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination dm (0111)
	// 2. move with destination dm (10_111)
	else if ((ir[7:4] == 4'b0111) || (ir[7:3] == 5'b10_111))
		reg_en[7] <= 1'b1;
	else
		reg_en[7] <= 1'b0;

// reg_en[8] = o_reg
always @ *
	if (sync_reset == 1'b1) 
		reg_en[8] <= 1'b1;
	// next else-if conditions in order (ir values)
	// 1. load with destination o_reg (0100)
	// 2. move with destination o_reg (10_100)
	else if ((ir[7:4] == 4'b0100) || (ir[7:3] == 5'd10_100))
		reg_en[8] <= 1'b1;
	else
		reg_en[8] <= 1'b0;

endmodule

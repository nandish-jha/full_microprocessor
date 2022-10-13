module computational_unit
(
	input clk, sync_reset, i_sel, y_sel, x_sel,
	input [3:0] source_sel, ir_nibble, i_pins, dm,
	input [8:0] reg_en,
	output reg r_eq_0,
	output reg [3:0] data_bus, x0, x1, y0, y1, m, r, i, o_reg,
	
	// for final exam
	output reg [7:0] from_CU
);

//always @ *					// for final exam
//	from_CU <= {x1, x0};	// change to "from_CU = 8'h0" upon entering the exam

always @ *
	from_CU <= 8'h0;

reg [3:0] pm_data;

always @ *
	pm_data <= ir_nibble;

// x0 
always @ (posedge clk)
	if (reg_en[0] == 1'b1)
		x0 <= data_bus;
	else
		x0 <= x0;

// x1 
always @ (posedge clk)
	if (reg_en[1] == 1'b1)
		x1 <= data_bus;
	else
		x1 <= x1;

// y0
always @ (posedge clk)
	if (reg_en[2] == 1'b1)
		y0 <= data_bus;
	else
		y0 <= y0;

// y1
always @ (posedge clk)
	if (reg_en[3] == 1'b1)
		y1 <= data_bus;
	else
		y1 <= y1;

// m
always @ (posedge clk)
	if (reg_en[5] == 1'b1)
		m <= data_bus;
	else
		m <= m;

// i
always @ (posedge clk)
	if (reg_en[6] == 1'b1)
		if (i_sel == 1'b0)
			i <= data_bus;
		else
			i <= i + m;
	else
		i <= i;

// o_reg
always @ (posedge clk)
	if (reg_en[8] == 1'b1)
		o_reg <= data_bus;
	else
		o_reg <= o_reg;

always @ *
	case(source_sel)
		// data registers
		4'd00: data_bus <= x0;		
		4'b01: data_bus <= x1;		
		4'd02: data_bus <= y0;		
		4'd03: data_bus <= y1;	
		
		// result registers
		4'd04: data_bus <= r;
		
		// data registers
		4'd05: data_bus <= m;			
		4'd06: data_bus <= i;	
		
		// data memory input	
		4'd07: data_bus <= dm;		
		4'd08: data_bus <= pm_data;	
		4'd09: data_bus <= i_pins;	
		
		//
		default: data_bus <= 4'h0;	
	endcase

// ALU function
reg [2:0] ALU_function;

always @ *
	ALU_function <= ir_nibble[2:0];

// x
reg [3:0] x;

always @ *
	if (x_sel == 1'b0)
		x <= x0;
	else
		x <= x1;

// y
reg [3:0] y;

always @ *
	if (y_sel == 1'b0)
		y <= y0;
	else
		y <= y1;


// Multiplication ALU function
reg [7:0] xy_mul; 

always @ *
	xy_mul <= x * y;

reg [3:0] ALU_out;  

always @ (*)
	if (sync_reset == 1'b1)
		ALU_out <= 4'b0;				
	//2's compliment of x 
	else if ((ALU_function == 3'b0) && (ir_nibble[3] == 1'b0))
		ALU_out <= -x;			
	// r=x-y	
	else if (ALU_function == 3'b001)
		ALU_out <= x - y;		
	// r=x+y	
	else if (ALU_function == 3'b010)
		ALU_out <= x + y;		
	// r=x*y	
	else if (ALU_function == 3'b011)
		ALU_out <= xy_mul[7:4];	
	else if (ALU_function == 3'b100)
		ALU_out <= xy_mul[3:0];
	// r=x^y
	else if (ALU_function == 3'b101)
		ALU_out <= x ^ y;			
	// r=x&y	
	else if (ALU_function == 3'b110)
		ALU_out <= x & y;			
	// 1's compliment of x
	else if ((ALU_function == 3'b111) && (ir_nibble[3] == 1'b0))
		ALU_out <= ~x;
	else
		ALU_out <= r;

// r
always @ (posedge clk)
	if (sync_reset == 1'b1)
		r <= 4'd0;
	else if (reg_en[4] == 1'b1)
		r <= ALU_out;
	else
		r <= r;

// r_eq_0
always @ (posedge clk)
	if (sync_reset == 1'b1)
		r_eq_0 <= 1'b1;
	else if ((reg_en[4] == 1'b1) && (ALU_out == 4'd0))
		r_eq_0 <= 1'b1;
	else if ((reg_en[4] == 1'b1) && (ALU_out != 4'd0))
		r_eq_0 <= 1'b0;
	else
		r_eq_0 <= r_eq_0;

endmodule

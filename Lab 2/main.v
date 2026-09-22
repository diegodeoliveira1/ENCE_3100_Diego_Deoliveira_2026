module main(
	input [9:0] SW,
	output [9:0] LEDR,
	
	input 	MAX10_CLK1_50,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	output	[7:0]		HEX3,
	output	[7:0]		HEX4,
	output	[7:0]		HEX5
);

	//assign LEDR[9:0] = SW[9:0];
	
	// PART II
	/*
	wire [3:0] w_m;
	
	Seg7_Decoder D0(
		.m(w_m),
		.out(HEX0)
	);
	
	wire w_z;
	
	wire [2:0] w_ca;

	mux_2_1 M0(
		.s(w_z),
		.x(SW[0]),
		.y(w_ca[0]),
		.m(w_m[0])
	);

	mux_2_1 M1(
		.s(w_z),
		.x(SW[1]),
		.y(w_ca[1]),
		.m(w_m[1])
	);
	
	mux_2_1 M2(
		.s(w_z),
		.x(SW[2]),
		.y(w_ca[2]),
		.m(w_m[2])
	);
	
	mux_2_1 M3(
		.s(w_z),
		.x(SW[3]),
		.y(1'b0),
		.m(w_m[3])
	);
	
	CircuitA CA(
		.v({SW[2], SW[1], SW[0]}),
		.out(w_ca)
	);
	
	Comparator myC(
		.v({SW[3], SW[2], SW[1], SW[0]}),
		.z(w_z)	
	);
	
	CircuitB CB(
		.z(w_z),
		.s(HEX1)
	);
	*/

	// PART III 

	/*
	wire [3:0] w_sum;
	wire       w_cout;
	wire [3:1] w_c;

	full_adder FA0 (
		.a(SW[4]), 
		.b(SW[0]), 
		.ci(SW[8]), 
		.s(w_sum[0]), 
		.co(w_c[1])
	);

	full_adder FA1 (
		.a(SW[5]), 
		.b(SW[1]), 
		.ci(w_c[1]), 
		.s(w_sum[1]), 
		.co(w_c[2])
	);

	full_adder FA2 (
		.a(SW[6]), 
		.b(SW[2]), 
		.ci(w_c[2]), 
		.s(w_sum[2]), 
		.co(w_c[3])
	);

	full_adder FA3 (
		.a(SW[7]), 
		.b(SW[3]), 
		.ci(w_c[3]), 
		.s(w_sum[3]), 
		.co(w_cout)
	);

	wire w_comp_z;
	wire w_z3;

	Comparator myC3(
		.v(w_sum),
		.z(w_comp_z)	
	);

	assign w_z3 = w_comp_z | w_cout;

	wire [2:0] w_ca3;

	CircuitA CA3(
		.v(w_sum[2:0]),
		.out(w_ca3)
	);

	wire [3:0] w_m3;

	mux_2_1 M0_3(
		.s(w_z3),
		.x(w_sum[0]),
		.y(w_ca3[0]),
		.m(w_m3[0])
	);

	mux_2_1 M1_3(
		.s(w_z3),
		.x(w_sum[1]),
		.y(w_ca3[1]),
		.m(w_m3[1])
	);
	
	mux_2_1 M2_3(
		.s(w_z3),
		.x(w_sum[2]),
		.y(w_ca3[2]),
		.m(w_m3[2])
	);
	
	mux_2_1 M3_3(
		.s(w_z3),
		.x(w_sum[3]),
		.y(1'b0),
		.m(w_m3[3])
	);

	Seg7_Decoder D0_3(
		.m(w_m3),
		.out(HEX0)
	);

	CircuitB CB3(
		.z(w_z3),
		.s(HEX1)
	);
	*/


	// PART IV
	
	wire [3:0] w_s4;
	wire       w_cout4;

	bcd_adder BCD_ADD0 (
		.A(SW[7:4]),
		.B(SW[3:0]),
		.cin(SW[8]),
		.cout(w_cout4),
		.S(w_s4)
	);

	// Display BCD Units Digit (S0) on HEX0
	Seg7_Decoder D0_4 (
		.m(w_s4),
		.out(HEX0)
	);

	// Display BCD Tens Digit (S1) on HEX1 ('0' or '1')
	CircuitB CB4 (
		.z(w_cout4),
		.s(HEX1)
	);

endmodule
module main (
    input         MAX10_CLK_50,
    input  [9:0]  SW,
    input  [1:0]  KEY,
    output [9:0]  LEDR,
    output [35:0] GPIO,
    output [7:0]  HEX0,
    output [7:0]  HEX1,
    output [7:0]  HEX2,
    output [7:0]  HEX3,
    output [7:0]  HEX4,
    output [7:0]  HEX5
);

    // Default outputs for unused pins
    assign GPIO = 36'b0;
	 
	 
    // PART I: Gated RS Latch (ACTIVE)
/* // SW[0] = D, SW[1] = Clock, LEDR[0] = Q
    part1 u_part1 (
        .Clk(SW[2]),
        .R(SW[0]),
        .S(SW[1]),
        .Q(LEDR[0])
    );
    
    // Default unused outputs for Part I
    assign LEDR[9:1] = 8'b0;
    assign HEX0 = 8'hFF;
    assign HEX1 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
*/

	/*
    // PART II: Gated D Latch
	// SW[0] = D, SW[1] = Clock, LEDR[0] = Q
    part2 u_part2 (
        .SW(SW[1:0]),
        .LEDR(LEDR[0])
    );

    assign LEDR[9:1] = 8'b0;
    assign HEX0 = 8'hFF;
    assign HEX1 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
   */

	/*
    // PART III: Master-Slave D Flip-Flop
    // SW[0] = D, SW[1] = Clock, LEDR[0] = Q
    part3 u_part3 (
        .SW(SW[1:0]),
        .LEDR(LEDR[0])
    );

    assign LEDR[9:1] = 8'b0;
    assign HEX0 = 8'hFF;
    assign HEX1 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
    */
	 
    /*
    // PART IV: Comparison of Storage Elements
    // SW[0] = D, SW[1] = Clk
    // LEDR[0] = Qa (Gated D Latch)
    // LEDR[1] = Qb (Posedge DFF)
    // LEDR[2] = Qc (Negedge DFF)
    part4 u_part4 (
        .D(SW[0]),
        .Clk(SW[1]),
        .Qa(LEDR[0]),
        .Qb(LEDR[1]),
        .Qc(LEDR[2])
    );

    assign LEDR[9:3] = 7'b0;
    assign HEX0 = 8'hFF;
    assign HEX1 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
    */

	/*
    // PART V: Register & 7-Segment Displays (DE10-Lite standard 6-display setup)
    // KEY[0] = Reset (active low), KEY[1] = Clock
    // SW[7:0] = Inputs for values A and B
    // HEX5, HEX4 = Stored Register A
    // HEX1, HEX0 = Direct Input B
    reg [7:0] A_reg;

    always @(negedge KEY[1] or negedge KEY[0]) begin
        if (~KEY[0])
            A_reg <= 8'h00;
        else
            A_reg <= SW[7:0];
    end

    // Display Stored Value A on HEX5 - HEX4
    seg7_display h5 (.bin_number(A_reg[7:4]),  .seg_display(HEX5));
    seg7_display h4 (.bin_number(A_reg[3:0]),  .seg_display(HEX4));

    // Display Direct Input B on HEX1 - HEX0
    seg7_display h1 (.bin_number(SW[7:4]),     .seg_display(HEX1));
    seg7_display h0 (.bin_number(SW[3:0]),     .seg_display(HEX0));

    // Turn off unused HEX2 and HEX3 displays
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign LEDR = 10'b0;
    */

endmodule
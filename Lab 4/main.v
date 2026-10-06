module main (
    input         MAX10_CLK1_50, // Matches PIN_P11 in Pin Planner
    input  [9:0]  SW,
    input  [1:0]  KEY,
    output [9:0]  LEDR,
    output [7:0]  HEX0,
    output [7:0]  HEX1,
    output [7:0]  HEX2,
    output [7:0]  HEX3,
    output [7:0]  HEX4,
    output [7:0]  HEX5
);


    //==========================================================
    // PART I
    //==========================================================
	/*
    reg [19:0] debounce_counter;
    reg        key0_sync;
    reg        key0_state;

    always @(posedge MAX10_CLK_50 or negedge SW[0]) begin

        if (!SW[0]) begin
            // Reset debounce circuit
            debounce_counter <= 20'd0;
            key0_sync        <= 1'b1;
            key0_state       <= 1'b1;
        end
        else begin

            // Synchronize KEY0
            key0_sync <= KEY[0];

            // Has KEY0 changed from its stable state?
            if (key0_sync != key0_state) begin

                // Wait approximately 20 ms
                if (debounce_counter == 20'd999_999) begin
                    debounce_counter <= 20'd0;
                    key0_state       <= key0_sync;
                end
                else begin
                    debounce_counter <= debounce_counter + 20'd1;
                end

            end
            else begin
                debounce_counter <= 20'd0;
            end

        end

    end

    wire clean_clock;

	 assign clean_clock = ~KEY[0];

    wire [7:0] count_p1;

    Counter_8Bit part1_inst (
        .ena   (SW[1]),
        .clk   (clean_clock),
        .clear (SW[0]),
        .count (count_p1)
    );

    assign LEDR[7:0] = count_p1;
    assign LEDR[9:8] = 2'b00;

    seg7_display hex0_p1 (
        .bin_number  (count_p1[3:0]),
        .seg_display (HEX0)
    );

    seg7_display hex1_p1 (
        .bin_number  (count_p1[7:4]),
        .seg_display (HEX1)
    );


    //==========================================================
    // Turn off unused displays
    //==========================================================

    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
	
	 
    // =====================================================================
    // PART II
    // =====================================================================
    /*
    wire [15:0] count_p2;

    behavioral_counter_16bit part2_inst (
        .clk(~KEY[0]),
        .clear_n(SW[0]),
        .enable(SW[1]),
        .q(count_p2)
    );

    assign LEDR = count_p2[9:0];
    seg7_display hex0_p2 (.bin_number(count_p2[3:0]),   .seg_display(HEX0));
    seg7_display hex1_p2 (.bin_number(count_p2[7:4]),   .seg_display(HEX1));
    seg7_display hex2_p2 (.bin_number(count_p2[11:8]),  .seg_display(HEX2));
    seg7_display hex3_p2 (.bin_number(count_p2[15:12]), .seg_display(HEX3));
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
	*/

    // =====================================================================
    // PART III: 16-Bit Counter (lpm_counter)
    // =====================================================================
    /*
    wire [15:0] count_p3;

    lpm_counter_16bit part3_inst (
        .clk(~KEY[0]),
        .sclr(~SW[0]),    // Active-high synchronous clear
        .cnt_en(SW[1]),
        .q(count_p3)
    );

    assign LEDR = count_p3[9:0];
    seg7_display hex0_p3 (.bin_number(count_p3[3:0]),   .seg_display(HEX0));
    seg7_display hex1_p3 (.bin_number(count_p3[7:4]),   .seg_display(HEX1));
    seg7_display hex2_p3 (.bin_number(count_p3[11:8]),  .seg_display(HEX2));
    seg7_display hex3_p3 (.bin_number(count_p3[15:12]), .seg_display(HEX3));
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
    */


    // =====================================================================
    // PART IV: 1-Second Digit Flasher (0 to 9)
    // =====================================================================
    /*
    part4_flasher part4_inst (
        .MAX10_CLK_50(MAX10_CLK1_50), // Pass MAX10_CLK1_50 here
        .SW(SW[0:0]),
        .HEX0(HEX0)
    );

    assign LEDR = 10'b0;
    assign HEX1 = 8'hFF;
    assign HEX2 = 8'hFF;
    assign HEX3 = 8'hFF;
    assign HEX4 = 8'hFF;
    assign HEX5 = 8'hFF;
	*/


    // =====================================================================
    // PART V: "HELLO" Scroller
    // =====================================================================
    
    part5_ticker_tape part5_inst (
        .MAX10_CLK_50(MAX10_CLK1_50), // Map top clock pin MAX10_CLK1_50
        .SW(SW[0:0]),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Drive unused LEDs off
    assign LEDR = 10'b0;

endmodule

module main #(
    parameter integer ACTIVE_PART = 5
)(
    input  wire        MAX10_CLK1_50,
    input  wire [9:0]  SW,
    input  wire [1:0]  KEY,
    output wire [9:0]  LEDR,
    output wire [7:0]  HEX0,
    output wire [7:0]  HEX1,
    output wire [7:0]  HEX2,
    output wire [7:0]  HEX3,
    output wire [7:0]  HEX4,
    output wire [7:0]  HEX5
);

    // =========================================================
    // Debounce module
    // =========================================================

    wire clean_press;

    debounce debounce_inst (
        .clk      (MAX10_CLK1_50),
        .reset_n  (KEY[0]),
        .button_n (KEY[1]),
        .press    (clean_press)
    );


    // =========================================================
    // Seven-segment display signals
    // =========================================================

    wire [3:0] h0, h1, h2, h3, h4, h5;
    wire [5:0] hex_enable;

    wire [6:0] seg0, seg1, seg2;
    wire [6:0] seg3, seg4, seg5;


    generate

        // =====================================================
        // PART I
        // 8-bit accumulator
        // =====================================================

        if (ACTIVE_PART == 1) begin : PART_I

            wire [7:0] accumulator_S;
            wire accumulator_Overflow;

            accumulator accumulator_inst (
                .clk      (MAX10_CLK1_50),
                .reset_n  (KEY[0]),
                .load     (clean_press),
                .A        (SW[7:0]),
                .S        (accumulator_S),
                .Overflow (accumulator_Overflow)
            );

            assign LEDR[7:0] = accumulator_S;
            assign LEDR[8]   = accumulator_Overflow;
            assign LEDR[9]   = 1'b0;

            // Displays unused in Part I
            assign {h5,h4,h3,h2,h1,h0} = 24'b0;
            assign hex_enable = 6'b000000;

        end


        // =====================================================
        // PART II
        // Add/subtract accumulator
        // SW8 = 0: Add
        // SW8 = 1: Subtract
        // =====================================================

        else if (ACTIVE_PART == 2) begin : PART_II

            wire [7:0] S;
            wire Overflow;

            accumulator_sub accumulatorsub_inst (
                .clk      (MAX10_CLK1_50),
                .reset_n  (KEY[0]),
                .load     (clean_press),
                .A        (SW[7:0]),
                .add_sub  (SW[8]),
                .S        (S),
                .Overflow (Overflow)
            );

            assign LEDR[7:0] = S;
            assign LEDR[8]   = Overflow;
            assign LEDR[9]   = SW[8];

            // Displays unused in Part II
            assign {h5,h4,h3,h2,h1,h0} = 24'b0;
            assign hex_enable = 6'b000000;

        end


        // =====================================================
        // PART III
        // 4 x 4 multiplier
        // SW[3:0] = A
        // SW[7:4] = B
        // =====================================================

        else if (ACTIVE_PART == 3) begin : PART_III

            wire [3:0] A;
            wire [3:0] B;
            wire [7:0] P;

            assign A = SW[3:0];
            assign B = SW[7:4];

            multiplier_4x4 multiplier_inst (
                .A (A),
                .B (B),
                .P (P)
            );

            assign LEDR[7:0] = P;
            assign LEDR[9:8] = 2'b00;

            // HEX5 displays A
            // HEX3 displays B
            // HEX1-HEX0 display product P
            assign h5 = A;
            assign h4 = 4'h0;
            assign h3 = B;
            assign h2 = 4'h0;
            assign h1 = P[7:4];
            assign h0 = P[3:0];

            // Enable HEX5, HEX3, HEX1 and HEX0
            assign hex_enable = 6'b101011;

        end


        // =====================================================
        // PART IV / PART V
        // Registered 8 x 8 multiplier
        //
        // SW[7:0] = Operand being loaded
        // SW8 = 0: Load A
        // SW8 = 1: Load B
        // SW9 = 0: Display lower product byte
        // SW9 = 1: Display upper product byte
        // =====================================================

        else if ((ACTIVE_PART == 4) ||
                 (ACTIVE_PART == 5)) begin : PART_IV_V

            reg [7:0] A_reg;
            reg [7:0] B_reg;

            wire [15:0] P;


            // -------------------------------------------------
            // Operand registers
            // -------------------------------------------------

            always @(posedge MAX10_CLK1_50 or negedge KEY[0]) begin
                if (!KEY[0]) begin
                    A_reg <= 8'b0;
                    B_reg <= 8'b0;
                end
                else if (clean_press) begin
                    if (SW[8] == 1'b0)
                        A_reg <= SW[7:0];
                    else
                        B_reg <= SW[7:0];
                end
            end


            // -------------------------------------------------
            // PART IV
            // Sequential partial-product addition
            // -------------------------------------------------

            if (ACTIVE_PART == 4) begin : PART_IV

                multiplier_8x8_registered #(
                    .USE_TREE (1'b0)
                ) multiplier_inst (
                    .clk     (MAX10_CLK1_50),
                    .reset_n (KEY[0]),
                    .A       (A_reg),
                    .B       (B_reg),
                    .P       (P)
                );

            end


            // -------------------------------------------------
            // PART V
            // Adder-tree multiplier
            // -------------------------------------------------

            else begin : PART_V

                multiplier_8x8_registered #(
                    .USE_TREE (1'b1)
                ) multiplier_inst (
                    .clk     (MAX10_CLK1_50),
                    .reset_n (KEY[0]),
                    .A       (A_reg),
                    .B       (B_reg),
                    .P       (P)
                );

            end


            // -------------------------------------------------
            // Red LED outputs
            // -------------------------------------------------

            assign LEDR[7:0] = SW[9] ? P[15:8] : P[7:0];
            assign LEDR[8]   = SW[8];
            assign LEDR[9]   = SW[9];


            // -------------------------------------------------
            // Seven-segment displays
            // HEX5-HEX4 = A
            // HEX3-HEX2 = B
            // HEX1-HEX0 = selected product byte
            // -------------------------------------------------

            assign h5 = A_reg[7:4];
            assign h4 = A_reg[3:0];

            assign h3 = B_reg[7:4];
            assign h2 = B_reg[3:0];

            assign h1 = SW[9] ? P[15:12] : P[7:4];
            assign h0 = SW[9] ? P[11:8]  : P[3:0];

            assign hex_enable = 6'b111111;

        end


        // =====================================================
        // Invalid part selection
        // =====================================================

        else begin : INVALID_PART

            assign LEDR = 10'b0;

            assign {h5,h4,h3,h2,h1,h0} = 24'b0;
            assign hex_enable = 6'b000000;

        end

    endgenerate


    // =========================================================
    // Seven-segment decoders
    // =========================================================

    hex_decoder decoder0 (
        .value    (h0),
        .segments (seg0)
    );

    hex_decoder decoder1 (
        .value    (h1),
        .segments (seg1)
    );

    hex_decoder decoder2 (
        .value    (h2),
        .segments (seg2)
    );

    hex_decoder decoder3 (
        .value    (h3),
        .segments (seg3)
    );

    hex_decoder decoder4 (
        .value    (h4),
        .segments (seg4)
    );

    hex_decoder decoder5 (
        .value    (h5),
        .segments (seg5)
    );


    // =========================================================
    // Physical display outputs
    // HEX[6:0] = seven segments
    // HEX[7]    = decimal point (kept OFF)
    //
    // Active-low displays:
    // 0 = ON, 1 = OFF
    // =========================================================

    assign HEX0 = {1'b1, (hex_enable[0] ? seg0 : 7'b1111111)};
    assign HEX1 = {1'b1, (hex_enable[1] ? seg1 : 7'b1111111)};
    assign HEX2 = {1'b1, (hex_enable[2] ? seg2 : 7'b1111111)};
    assign HEX3 = {1'b1, (hex_enable[3] ? seg3 : 7'b1111111)};
    assign HEX4 = {1'b1, (hex_enable[4] ? seg4 : 7'b1111111)};
    assign HEX5 = {1'b1, (hex_enable[5] ? seg5 : 7'b1111111)};

endmodule


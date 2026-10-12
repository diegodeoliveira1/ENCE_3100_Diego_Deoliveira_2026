module multiplier_8x8_tree (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output wire [15:0] P
);

    // =========================================================
    // PART V
    // Generate the eight partial products
    // =========================================================

    wire [15:0] pp0, pp1, pp2, pp3;
    wire [15:0] pp4, pp5, pp6, pp7;

    partial_products_8x8 partial_inst (
        .A   (A),
        .B   (B),
        .pp0 (pp0),
        .pp1 (pp1),
        .pp2 (pp2),
        .pp3 (pp3),
        .pp4 (pp4),
        .pp5 (pp5),
        .pp6 (pp6),
        .pp7 (pp7)
    );


    // =========================================================
    // PART V
    // Level 1: Add four pairs in parallel
    // =========================================================

    wire [15:0] level1_0;
    wire [15:0] level1_1;
    wire [15:0] level1_2;
    wire [15:0] level1_3;

    adder16 add01 (
        .A   (pp0),
        .B   (pp1),
        .Sum (level1_0)
    );

    adder16 add23 (
        .A   (pp2),
        .B   (pp3),
        .Sum (level1_1)
    );

    adder16 add45 (
        .A   (pp4),
        .B   (pp5),
        .Sum (level1_2)
    );

    adder16 add67 (
        .A   (pp6),
        .B   (pp7),
        .Sum (level1_3)
    );


    // =========================================================
    // PART V
    // Level 2: Add the four results in pairs
    // =========================================================

    wire [15:0] level2_0;
    wire [15:0] level2_1;

    adder16 add_level2_0 (
        .A   (level1_0),
        .B   (level1_1),
        .Sum (level2_0)
    );

    adder16 add_level2_1 (
        .A   (level1_2),
        .B   (level1_3),
        .Sum (level2_1)
    );


    // =========================================================
    // PART V
    // Level 3: Final addition
    // =========================================================

    adder16 add_final (
        .A   (level2_0),
        .B   (level2_1),
        .Sum (P)
    );

endmodule

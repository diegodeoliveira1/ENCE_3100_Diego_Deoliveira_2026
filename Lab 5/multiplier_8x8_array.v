module multiplier_8x8_array (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output wire [15:0] P
);

    // =========================================================
    // PART IV
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
    // PART IV
    // Add the partial products sequentially
    // =========================================================

    wire [15:0] sum01;
    wire [15:0] sum012;
    wire [15:0] sum0123;
    wire [15:0] sum01234;
    wire [15:0] sum012345;
    wire [15:0] sum0123456;

    adder16 add01 (
        .A   (pp0),
        .B   (pp1),
        .Sum (sum01)
    );

    adder16 add012 (
        .A   (sum01),
        .B   (pp2),
        .Sum (sum012)
    );

    adder16 add0123 (
        .A   (sum012),
        .B   (pp3),
        .Sum (sum0123)
    );

    adder16 add01234 (
        .A   (sum0123),
        .B   (pp4),
        .Sum (sum01234)
    );

    adder16 add012345 (
        .A   (sum01234),
        .B   (pp5),
        .Sum (sum012345)
    );

    adder16 add0123456 (
        .A   (sum012345),
        .B   (pp6),
        .Sum (sum0123456)
    );

    adder16 add01234567 (
        .A   (sum0123456),
        .B   (pp7),
        .Sum (P)
    );

endmodule

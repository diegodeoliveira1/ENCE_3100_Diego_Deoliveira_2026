module multiplier_4x4 (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [7:0] P
);

    // =========================================================
    // Partial products
    // =========================================================

    wire p00, p01, p02, p03;
    wire p10, p11, p12, p13;
    wire p20, p21, p22, p23;
    wire p30, p31, p32, p33;

    assign p00 = A[0] & B[0];
    assign p01 = A[0] & B[1];
    assign p02 = A[0] & B[2];
    assign p03 = A[0] & B[3];

    assign p10 = A[1] & B[0];
    assign p11 = A[1] & B[1];
    assign p12 = A[1] & B[2];
    assign p13 = A[1] & B[3];

    assign p20 = A[2] & B[0];
    assign p21 = A[2] & B[1];
    assign p22 = A[2] & B[2];
    assign p23 = A[2] & B[3];

    assign p30 = A[3] & B[0];
    assign p31 = A[3] & B[1];
    assign p32 = A[3] & B[2];
    assign p33 = A[3] & B[3];


    // =========================================================
    // Intermediate wires
    // =========================================================

    wire s1, s2, s3, s4;
    wire s5, s6, s7, s8;

    wire c1, c2, c3, c4;
    wire c5, c6, c7, c8;

    wire s9, s10, s11;
    wire c9, c10, c11;

    // =========================================================
    // Row 1
    // =========================================================

    // p10 + p01
    full_adder FA0 (
        .A    (p10),
        .B    (p01),
        .Cin  (1'b0),
        .Sum  (s1),
        .Cout (c1)
    );

    // p20 + p11 + c1
    full_adder FA1 (
        .A    (p20),
        .B    (p11),
        .Cin  (c1),
        .Sum  (s2),
        .Cout (c2)
    );

    // p30 + p21 + c2
    full_adder FA2 (
        .A    (p30),
        .B    (p21),
        .Cin  (c2),
        .Sum  (s3),
        .Cout (c3)
    );

    // 0 + p31 + c3
    full_adder FA3 (
        .A    (1'b0),
        .B    (p31),
        .Cin  (c3),
        .Sum  (s4),
        .Cout (c4)
    );


    // =========================================================
    // Row 2
    // =========================================================

    // s2 + p02
    full_adder FA4 (
        .A    (s2),
        .B    (p02),
        .Cin  (1'b0),
        .Sum  (s5),
        .Cout (c5)
    );

    // s3 + p12 + c5
    full_adder FA5 (
        .A    (s3),
        .B    (p12),
        .Cin  (c5),
        .Sum  (s6),
        .Cout (c6)
    );

    // s4 + p22 + c6
    full_adder FA6 (
        .A    (s4),
        .B    (p22),
        .Cin  (c6),
        .Sum  (s7),
        .Cout (c7)
    );

    // c4 + p32 + c7
    full_adder FA7 (
        .A    (c4),
        .B    (p32),
        .Cin  (c7),
        .Sum  (s8),
        .Cout (c8)
    );


    // =========================================================
    // Row 3
    // =========================================================

    // s6 + p03
    full_adder FA8 (
        .A    (s6),
        .B    (p03),
        .Cin  (1'b0),
        .Sum  (s9),
        .Cout (c9)
    );

    // s7 + p13 + c9
    full_adder FA9 (
        .A    (s7),
        .B    (p13),
        .Cin  (c9),
        .Sum  (s10),
        .Cout (c10)
    );

    // s8 + p23 + c10
    full_adder FA10 (
        .A    (s8),
        .B    (p23),
        .Cin  (c10),
        .Sum  (s11),
        .Cout (c11)
    );

    // c8 + p33 + c11
    full_adder FA11 (
        .A    (c8),
        .B    (p33),
        .Cin  (c11),
        .Sum  (P[6]),
        .Cout (P[7])
    );


    // =========================================================
    // Product bits
    // =========================================================

    assign P[0] = p00;
    assign P[1] = s1;
    assign P[2] = s5;
    assign P[3] = s9;
    assign P[4] = s10;
    assign P[5] = s11;

endmodule
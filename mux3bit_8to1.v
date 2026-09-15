module mux3bit_8to1 (
    input  [2:0] S,
    input  [2:0] C0, C1, C2, C3, C4, C5, C6, C7,
    output [2:0] M
);

    mux8to1 b0 (
        .in0(C0[0]), .in1(C1[0]), .in2(C2[0]), .in3(C3[0]),
        .in4(C4[0]), .in5(C5[0]), .in6(C6[0]), .in7(C7[0]),
        .s(S), .m(M[0])
    );

    mux8to1 b1 (
        .in0(C0[1]), .in1(C1[1]), .in2(C2[1]), .in3(C3[1]),
        .in4(C4[1]), .in5(C5[1]), .in6(C6[1]), .in7(C7[1]),
        .s(S), .m(M[1])
    );

    mux8to1 b2 (
        .in0(C0[2]), .in1(C1[2]), .in2(C2[2]), .in3(C3[2]),
        .in4(C4[2]), .in5(C5[2]), .in6(C6[2]), .in7(C7[2]),
        .s(S), .m(M[2])
    );

endmodule
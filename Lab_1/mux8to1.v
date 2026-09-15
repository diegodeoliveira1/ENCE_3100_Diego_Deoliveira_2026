module mux8to1 (
    input  in0, in1, in2, in3, in4, in5, in6, in7,
    input  [2:0] s,
    output m
);

    wire m01, m23, m45, m67;
    wire m0123, m4567;

    mux2to1 u0 (.x(in0), .y(in1), .s(s[0]), .m(m01));
    mux2to1 u1 (.x(in2), .y(in3), .s(s[0]), .m(m23));
    mux2to1 u2 (.x(in4), .y(in5), .s(s[0]), .m(m45));
    mux2to1 u3 (.x(in6), .y(in7), .s(s[0]), .m(m67));

    mux2to1 u4 (.x(m01),  .y(m23),  .s(s[1]), .m(m0123));
    mux2to1 u5 (.x(m45),  .y(m67),  .s(s[1]), .m(m4567));

    mux2to1 u6 (.x(m0123), .y(m4567), .s(s[2]), .m(m));

endmodule
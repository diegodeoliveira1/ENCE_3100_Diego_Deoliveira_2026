module bcd_adder (
    input  [3:0] A,
    input  [3:0] B,
    input        cin,
    output       cout,
    output [3:0] S
);

    wire [3:0] w_sum;
    wire       w_cout_raw;
    wire [3:1] w_c;

    full_adder FA0 (.a(A[0]), .b(B[0]), .ci(cin),   .s(w_sum[0]), .co(w_c[1]));
    full_adder FA1 (.a(A[1]), .b(B[1]), .ci(w_c[1]), .s(w_sum[1]), .co(w_c[2]));
    full_adder FA2 (.a(A[2]), .b(B[2]), .ci(w_c[2]), .s(w_sum[2]), .co(w_c[3]));
    full_adder FA3 (.a(A[3]), .b(B[3]), .ci(w_c[3]), .s(w_sum[3]), .co(w_cout_raw));

    wire w_comp_z;
    wire w_z;

    Comparator myC (
        .v(w_sum),
        .z(w_comp_z)
    );

    assign w_z = w_comp_z | w_cout_raw;
    assign cout = w_z;

    wire [2:0] w_ca;

    CircuitA CA (
        .v(w_sum[2:0]),
        .out(w_ca)
    );

    mux_2_1 M0 (.s(w_z), .x(w_sum[0]), .y(w_ca[0]), .m(S[0]));
    mux_2_1 M1 (.s(w_z), .x(w_sum[1]), .y(w_ca[1]), .m(S[1]));
    mux_2_1 M2 (.s(w_z), .x(w_sum[2]), .y(w_ca[2]), .m(S[2]));
    mux_2_1 M3 (.s(w_z), .x(w_sum[3]), .y(1'b0),     .m(S[3]));

endmodule
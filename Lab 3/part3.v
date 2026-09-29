module part3 (
    input  [1:0] SW,
    output [0:0] LEDR
);
    wire Q_m;

    d_latch_gate master (
        .D(SW[0]),
        .Clk(~SW[1]),
        .Q(Q_m)
    );

    d_latch_gate slave (
        .D(Q_m),
        .Clk(SW[1]),
        .Q(LEDR[0])
    );
endmodule
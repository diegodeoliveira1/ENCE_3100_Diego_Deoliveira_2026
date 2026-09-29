module part2 (
    input  [1:0] SW,
    output [0:0] LEDR
);
    d_latch_gate u0 (
        .D(SW[0]),
        .Clk(SW[1]),
        .Q(LEDR[0])
    );
endmodule
module Counter_8Bit (
    input  wire       ena,
    input  wire       clk,
    input  wire       clear,
    output wire [7:0] count
);

    wire [7:0] q;

    T_FF FF0 (
        .clk   (clk),
        .clear (clear),
        .T     (ena),
        .Q     (q[0])
    );

    T_FF FF1 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0]),
        .Q     (q[1])
    );

    T_FF FF2 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1]),
        .Q     (q[2])
    );

    T_FF FF3 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1] & q[2]),
        .Q     (q[3])
    );

    T_FF FF4 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1] & q[2] & q[3]),
        .Q     (q[4])
    );

    T_FF FF5 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1] & q[2] & q[3] & q[4]),
        .Q     (q[5])
    );

    T_FF FF6 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1] & q[2] & q[3] & q[4] & q[5]),
        .Q     (q[6])
    );

    T_FF FF7 (
        .clk   (clk),
        .clear (clear),
        .T     (ena & q[0] & q[1] & q[2] & q[3] &
                q[4] & q[5] & q[6]),
        .Q     (q[7])
    );

    assign count = q;

endmodule
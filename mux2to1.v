module mux2to1 (
    input  x,
    input  y,
    input  s,
    output m
);

    assign m = (~s & x) | (s & y);

endmodule
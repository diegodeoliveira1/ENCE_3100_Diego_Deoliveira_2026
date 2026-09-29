module d_latch_gate (
    input D, Clk,
    output Q
);
    wire S, R, S_g, R_g, Qa, Qb  ;

    assign S   = D;
    assign R   = ~D;
    assign S_g = S & Clk;
    assign R_g = R & Clk;
    assign Qa  = ~(R_g | Qb);
    assign Qb  = ~(S_g | Qa);
    assign Q   = Qa;

endmodule
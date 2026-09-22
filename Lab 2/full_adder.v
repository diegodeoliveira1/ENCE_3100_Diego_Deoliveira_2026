module full_adder (
    input  wire a,
    input  wire b,
    input  wire ci,
    output wire s,
    output wire co
);

    // Inverted inputs
    wire ci_n, a_n, b_n;

    not (ci_n, ci);
    not (a_n,  a);
    not (b_n,  b);

    // Sum (s) minterms: m1, m2, m4, m7
    wire m1, m2, m4, m7;

    and (m1, ci_n, a_n, b);    // ~ci & ~a &  b
    and (m2, ci_n, a,   b_n);  // ~ci &  a & ~b
    and (m4, ci,   a_n, b_n);  //  ci & ~a & ~b
    and (m7, ci,   a,   b);    //  ci &  a &  b

    or  (s, m1, m2, m4, m7);   // 4-input OR gate for Sum

    // Carry-Out (co) product terms
    wire c1, c2, c3;

    and (c1, a,  b);           // a & b
    and (c2, ci, a);           // ci & a
    and (c3, ci, b);           // ci & b

    or  (co, c1, c2, c3);      // 3-input OR gate for Carry Out

endmodule
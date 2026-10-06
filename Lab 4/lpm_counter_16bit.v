module lpm_counter_16bit (
    input         clk,
    input         sclr,   // Synchronous clear
    input         cnt_en, // Count enable
    output [15:0] q
);
    // Instantiate Altera/Intel LPM Counter Primitive
    lpm_counter #(
        .lpm_width(16),
        .lpm_direction("UP")
    ) lpm_counter_inst (
        .clock(clk),
        .sclr(sclr),
        .cnt_en(cnt_en),
        .q(q)
    );
endmodule
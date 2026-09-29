module part4 (
    input D,
    input Clk,
    output reg Qa,
    output reg Qb,
    output reg Qc
);
    always @(D, Clk) begin
        if (Clk)
            Qa = D;
    end

    always @(posedge Clk) begin
        Qb <= D;
    end

    always @(negedge Clk) begin
        Qc <= D;
    end
endmodule
module T_FF (
    input  wire clk,
    input  wire clear,
    input  wire T,
    output reg  Q
);

    always @(posedge clk or negedge clear) begin
        if (!clear)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end

endmodule
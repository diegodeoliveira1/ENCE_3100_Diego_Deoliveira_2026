
module accumulator (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       load,
    input  wire [7:0] A,
    output reg  [7:0] S,
    output reg        Overflow
);

    wire [8:0] add_result;

    // Add the current switch input to the stored sum.
    // The 9-bit result preserves the carry-out.
    assign add_result = {1'b0, A} + {1'b0, S};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            S        <= 8'b0;
            Overflow <= 1'b0;
        end
        else if (load) begin
            S        <= add_result[7:0];
            Overflow <= add_result[8];
        end
    end

endmodule

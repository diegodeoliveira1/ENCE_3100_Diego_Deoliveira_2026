`default_nettype none

module Accumulator_A #
(
    parameter N = 4
)
(
    input MainClock,
    input ClearA,
    input LatchA,
    input EnableA,
    input [N-1:0] A,
    output [N-1:0] IB_BUS,
    output reg [N-1:0] AluA
);

    // Store a value in accumulator A.
    always @(posedge MainClock) begin
        if (ClearA)
            AluA <= {N{1'b0}};
        else if (LatchA)
            AluA <= A;
    end

    // Make output zero when not enabled, for the internal bus OR.
    assign IB_BUS = EnableA ? AluA : {N{1'b0}};

endmodule

`default_nettype wire

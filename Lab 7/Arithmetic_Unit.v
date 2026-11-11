`default_nettype none

module Arithmetic_Unit #
(
    parameter N = 4
)
(
    input EnableALU,
    input AddSub,
    input [N-1:0] A,
    input [N-1:0] B,
    output reg Carry,
    output reg [N-1:0] IB_ALU
);

    // AddSub = 0: A + B
    // AddSub = 1: A - B
    // The ALU output is zero when the ALU is not enabled.
    always @(*) begin
        Carry = 1'b0;
        IB_ALU = {N{1'b0}};

        if (EnableALU) begin
            if (AddSub)
                {Carry, IB_ALU} = {1'b0, A} - {1'b0, B};
            else
                {Carry, IB_ALU} = {1'b0, A} + {1'b0, B};
        end
    end

endmodule

`default_nettype wire

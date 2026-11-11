`default_nettype none

module InstructionReg #
(
    parameter N = 4
)
(
    input MainClock,
    input ClearInstr,
    input LatchInstr,
    input EnableInstr,
    input [N-1:0] Data,
    input [N-1:0] Instr,
    output reg [N-1:0] ToInstr,
    output [N-1:0] IB_BUS
);

    reg [N-1:0] stored_data;

    // The top nibble is the opcode; the bottom nibble is its value.
    always @(posedge MainClock) begin
        if (ClearInstr) begin
            ToInstr <= {N{1'b0}};
            stored_data <= {N{1'b0}};
        end
        else if (LatchInstr) begin
            ToInstr <= Instr;
            stored_data <= Data;
        end
    end

    // Make the stored number available during execution.
    assign IB_BUS = EnableInstr ? stored_data : {N{1'b0}};

endmodule

`default_nettype wire

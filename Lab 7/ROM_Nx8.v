`default_nettype none

module ROM_Nx8 #
(
    parameter N = 8
)
(
    input [$clog2(N)-1:0] address,
    output reg [7:0] data
);

    // Upper 4 bits = instruction, lower 4 bits = number.
    // LDA = 5, ADD = 1, SUB = 2, OUT = 3, IN = 4, NOP = 0.
    (* ramstyle = "logic" *) reg [7:0] rom [0:N-1];

    initial begin
        rom[0] = 8'h55;  // LDA 5   -> A = 5
        rom[1] = 8'h12;  // ADD 2   -> A = 7
        rom[2] = 8'h30;  // OUT     -> show 7
        rom[3] = 8'h23;  // SUB 3   -> A = 4
        rom[4] = 8'h30;  // OUT     -> show 4
        rom[5] = 8'h40;  // IN      -> A = SW[3:0]
        rom[6] = 8'h30;  // OUT     -> show switch value
        rom[7] = 8'h00;  // NOP     -> do nothing
    end

    // Read the instruction at the current address.
    always @(*) begin
        data = rom[address];
    end

endmodule

`default_nettype wire

module adder16 (
    input  wire [15:0] A,
    input  wire [15:0] B,
    output wire [15:0] Sum
);

    assign Sum = A + B;

endmodule

module partial_products_8x8 (
    input  wire [7:0] A,
    input  wire [7:0] B,

    output wire [15:0] pp0,
    output wire [15:0] pp1,
    output wire [15:0] pp2,
    output wire [15:0] pp3,
    output wire [15:0] pp4,
    output wire [15:0] pp5,
    output wire [15:0] pp6,
    output wire [15:0] pp7
);

    assign pp0 = {8'b0, (A & {8{B[0]}})};
    assign pp1 = {7'b0, (A & {8{B[1]}}), 1'b0};
    assign pp2 = {6'b0, (A & {8{B[2]}}), 2'b0};
    assign pp3 = {5'b0, (A & {8{B[3]}}), 3'b0};
    assign pp4 = {4'b0, (A & {8{B[4]}}), 4'b0};
    assign pp5 = {3'b0, (A & {8{B[5]}}), 5'b0};
    assign pp6 = {2'b0, (A & {8{B[6]}}), 6'b0};
    assign pp7 = {1'b0, (A & {8{B[7]}}), 7'b0};

endmodule

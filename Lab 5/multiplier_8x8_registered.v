module multiplier_8x8_registered #(
    parameter USE_TREE = 1'b0
)(
    input  wire        clk,
    input  wire        reset_n,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] P
);

    // =========================================================
    // Input registers
    // =========================================================

    reg [7:0] A_reg;
    reg [7:0] B_reg;

    wire [15:0] product_comb;


    // =========================================================
    // PART IV / PART V
    // Select the required multiplier architecture
    // =========================================================

    generate
        if (USE_TREE == 1'b0) begin : USE_ARRAY

            // Part IV: Sequential partial-product additions
            multiplier_8x8_array array_inst (
                .A (A_reg),
                .B (B_reg),
                .P (product_comb)
            );

        end
        else begin : USE_ADDER_TREE

            // Part V: Balanced adder-tree implementation
            multiplier_8x8_tree tree_inst (
                .A (A_reg),
                .B (B_reg),
                .P (product_comb)
            );

        end
    endgenerate


    // =========================================================
    // Input and output registers
    // =========================================================

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            A_reg <= 8'b0;
            B_reg <= 8'b0;
            P     <= 16'b0;
        end
        else begin
            A_reg <= A;
            B_reg <= B;

            P <= product_comb;
        end
    end

endmodule

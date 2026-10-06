module part5_ticker_tape (
    input        MAX10_CLK_50,
    input  [0:0] SW,           // SW[0] = Reset
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    // Character segment definitions (Active-Low)
    localparam CHAR_H = 8'b1000_1001;
    localparam CHAR_E = 8'b1000_0110;
    localparam CHAR_L = 8'b1100_0111;
    localparam CHAR_O = 8'b1100_0000;
    localparam CHAR_OFF = 8'b1111_1111;

    // 1-Second Timer
    reg [25:0] clk_count;
    wire tick_1s = (clk_count == 26'd49_999_999);

    always @(posedge MAX10_CLK_50 or negedge SW[0]) begin
        if (!SW[0])
            clk_count <= 26'd0;
        else if (tick_1s)
            clk_count <= 26'd0;
        else
            clk_count <= clk_count + 1'b1;
    end

    // 3-Bit Sequence State Counter (Cycles 0 to 7)
    reg [2:0] state;

    always @(posedge MAX10_CLK_50 or negedge SW[0]) begin
        if (!SW[0])
            state <= 3'd0;
        else if (tick_1s)
            state <= state + 1'b1;
    end

    // Multiplexer Logic for 6 7-Segment Displays (DE10-Lite mapping)
    reg [7:0] h0, h1, h2, h3, h4, h5;

    always @(*) begin
        case (state)
            3'd0, 3'd1, 3'd2, 3'd3, 3'd8: begin
                h5 = CHAR_H; h4 = CHAR_E; h3 = CHAR_L; h2 = CHAR_L; h1 = CHAR_O; h0 = CHAR_OFF;
            end
            3'd4: begin
                h5 = CHAR_E; h4 = CHAR_L; h3 = CHAR_L; h2 = CHAR_O; h1 = CHAR_H; h0 = CHAR_OFF;
            end
            3'd5: begin
                h5 = CHAR_L; h4 = CHAR_L; h3 = CHAR_O; h2 = CHAR_H; h1 = CHAR_E; h0 = CHAR_OFF;
            end
            3'd6: begin
                h5 = CHAR_L; h4 = CHAR_O; h3 = CHAR_H; h2 = CHAR_E; h1 = CHAR_L; h0 = CHAR_OFF;
            end
            3'd7: begin
                h5 = CHAR_O; h4 = CHAR_H; h3 = CHAR_E; h2 = CHAR_L; h1 = CHAR_L; h0 = CHAR_OFF;
            end
            default: begin
                h5 = CHAR_OFF; h4 = CHAR_OFF; h3 = CHAR_OFF; h2 = CHAR_OFF; h1 = CHAR_OFF; h0 = CHAR_OFF;
            end
        endcase
    end

    assign HEX0 = h0;
    assign HEX1 = h1;
    assign HEX2 = h2;
    assign HEX3 = h3;
    assign HEX4 = h4;
    assign HEX5 = h5;

endmodule
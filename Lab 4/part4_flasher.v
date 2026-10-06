module part4_flasher (
    input        MAX10_CLK_50,
    input  [0:0] SW,           
    output [7:0] HEX0
);

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

    reg [3:0] digit;

    always @(posedge MAX10_CLK_50 or negedge SW[0]) begin
        if (!SW[0]) begin
            digit <= 4'd0;
        end else if (tick_1s) begin
            if (digit == 4'd9)
                digit <= 4'd0;
            else
                digit <= digit + 1'b1;
        end
    end

    seg7_display dec0 (.bin_number(digit), .seg_display(HEX0));

endmodule
module seg7_display (
    input  wire [3:0] bin_number,
    output reg  [7:0] seg_display
);

    always @(*) begin
        case (bin_number)

            4'h0: seg_display = 8'b11000000;
            4'h1: seg_display = 8'b11111001;
            4'h2: seg_display = 8'b10100100;
            4'h3: seg_display = 8'b10110000;
            4'h4: seg_display = 8'b10011001;
            4'h5: seg_display = 8'b10010010;
            4'h6: seg_display = 8'b10000010;
            4'h7: seg_display = 8'b11111000;
            4'h8: seg_display = 8'b10000000;
            4'h9: seg_display = 8'b10010000;
            4'hA: seg_display = 8'b10001000;
            4'hB: seg_display = 8'b10000011;
            4'hC: seg_display = 8'b11000110;
            4'hD: seg_display = 8'b10100001;
            4'hE: seg_display = 8'b10000110;
            4'hF: seg_display = 8'b10001110;

            default: seg_display = 8'b11111111;

        endcase
    end

endmodule
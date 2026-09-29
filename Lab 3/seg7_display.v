module seg7_display (
	input [3:0] bin_number,
	output reg [7:0] seg_display
);

	always @(*) begin
		case(bin_number)
			4'd0:  seg_display = 8'b0100_0000; // 0
			4'd1:  seg_display = 8'b0111_1001; // 1
			4'd2:  seg_display = 8'b0010_0100; // 2
			4'd3:  seg_display = 8'b0011_0000; // 3
			4'd4:  seg_display = 8'b0001_1001; // 4
			4'd5:  seg_display = 8'b0001_0010; // 5
			4'd6:  seg_display = 8'b0000_0010; // 6
			4'd7:  seg_display = 8'b0111_1000; // 7
			4'd8:  seg_display = 8'b0000_0000; // 8
			4'd9:  seg_display = 8'b0001_0000; // 9
			4'd10: seg_display = 8'b0000_1000; // A
			4'd11: seg_display = 8'b0000_0011; // b
			4'd12: seg_display = 8'b0100_0110; // C
			4'd13: seg_display = 8'b0010_0001; // d
			4'd14: seg_display = 8'b0000_0110; // E
			4'd15: seg_display = 8'b0000_1110; // F
		endcase
	end



endmodule
	
	
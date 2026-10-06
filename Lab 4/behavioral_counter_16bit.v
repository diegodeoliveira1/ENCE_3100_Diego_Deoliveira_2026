module behavioral_counter_16bit (
    input         clk,
    input         clear_n, // Active-low clear
    input         enable,
    output reg [15:0] q
);
    always @(posedge clk or negedge clear_n) begin
        if (!clear_n)
            q <= 16'd0;
        else if (enable)
            q <= q + 1'b1;
    end
endmodule
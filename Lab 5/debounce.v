module debounce (
    input  wire clk,
    input  wire reset_n,
    input  wire button_n,
    output reg  press
);

    // 50 MHz clock
    // 20 ms = 1,000,000 clock cycles
    localparam integer MAX_COUNT = 20'd999999;

    reg button_sync1;
    reg button_sync2;
    reg button_state;

    reg [19:0] count;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            button_sync1 <= 1'b1;
            button_sync2 <= 1'b1;
            button_state <= 1'b1;
            count        <= 20'd0;
            press        <= 1'b0;
        end
        else begin
            // Synchronize KEY1 to the 50 MHz clock
            button_sync1 <= button_n;
            button_sync2 <= button_sync1;

            // Default: no press
            press <= 1'b0;

            // Button state has changed
            if (button_sync2 != button_state) begin

                if (count < MAX_COUNT) begin
                    count <= count + 1'b1;
                end
                else begin
                    // Accept the new stable state
                    button_state <= button_sync2;
                    count        <= 20'd0;

                    // KEY1 is active-low.
                    // Generate one pulse when it becomes pressed.
                    if (button_sync2 == 1'b0)
                        press <= 1'b1;
                end
            end
            else begin
                count <= 20'd0;
            end
        end
    end

endmodule
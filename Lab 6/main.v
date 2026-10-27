`default_nettype none

module main(
    input  wire        MAX10_CLK1_50,
    input  wire [9:0]  SW,
    output wire [9:0]  LEDR,
    inout  wire [35:0] GPIO,
    output wire [7:0]  HEX0
);

    // 50 MHz FPGA clock
    localparam [24:0] CHAR_TICK_COUNT =
        25'd25000000;       // 0.5 second

    localparam [23:0] BLINK_TOGGLE_COUNT =
        24'd12500000;       // 0.25 second

    localparam [27:0] FIVE_SECOND_COUNT =
        28'd250000000;      // 5 seconds

    wire clk = MAX10_CLK1_50;


    // -----------------------------------------
    // UART receiver
    // -----------------------------------------

    wire RxD_data_ready;
    wire [7:0] RxD_data;

    reg [7:0] last_rx_data = 8'h00;

    async_receiver RX (
        .clk(clk),
        .RxD(GPIO[35]),
        .RxD_data_ready(RxD_data_ready),
        .RxD_data(RxD_data)
    );

    always @(posedge clk) begin
        if (SW[9])
            last_rx_data <= 8'h00;
        else if (RxD_data_ready)
            last_rx_data <= RxD_data;
    end


    // -----------------------------------------
    // UART transmitter
    // Sends the received character back
    // -----------------------------------------

    async_transmitter TX (
        .clk(clk),
        .TxD(GPIO[33]),
        .TxD_start(RxD_data_ready),
        .TxD_data(RxD_data)
    );


    // Show received character on LEDs
    assign LEDR[7:0] = last_rx_data;


    // -----------------------------------------
    // FSM state definitions
    // A -> B -> C -> D -> E -> F -> A
    // -----------------------------------------

    localparam [2:0] ST_A = 3'd0;
    localparam [2:0] ST_B = 3'd1;
    localparam [2:0] ST_C = 3'd2;
    localparam [2:0] ST_D = 3'd3;
    localparam [2:0] ST_E = 3'd4;
    localparam [2:0] ST_F = 3'd5;

    reg [2:0] state = ST_A;

    reg [24:0] char_count = 25'd0;
    reg [27:0] five_count = 28'd0;
    reg [24:0] blink_char_count = 25'd0;
    reg [23:0] blink_count = 24'd0;

    reg blink_on = 1'b1;
    reg [2:0] hello_index = 3'd0;


    // -----------------------------------------
    // FSM and counters
    // SW[9] is the active-high reset
    // -----------------------------------------

    always @(posedge clk) begin

        if (SW[9]) begin
            state            <= ST_A;
            char_count       <= 25'd0;
            five_count       <= 28'd0;
            blink_char_count <= 25'd0;
            blink_count      <= 24'd0;
            blink_on         <= 1'b1;
            hello_index      <= 3'd0;
        end

        else begin

            case (state)

                // State A: reset counters and begin
                ST_A: begin
                    state            <= ST_B;
                    char_count       <= 25'd0;
                    five_count       <= 28'd0;
                    blink_char_count <= 25'd0;
                    blink_count      <= 24'd0;
                    blink_on         <= 1'b1;
                    hello_index      <= 3'd0;
                end


                // State B: display H
                ST_B: begin
                    if (char_count >= CHAR_TICK_COUNT - 1'b1) begin
                        state      <= ST_C;
                        char_count <= 25'd0;
                    end
                    else begin
                        char_count <= char_count + 1'b1;
                    end
                end


                // State C: display E
                ST_C: begin
                    if (char_count >= CHAR_TICK_COUNT - 1'b1) begin
                        state      <= ST_D;
                        char_count <= 25'd0;
                    end
                    else begin
                        char_count <= char_count + 1'b1;
                    end
                end


                // State D: display first L
                ST_D: begin
                    if (char_count >= CHAR_TICK_COUNT - 1'b1) begin
                        state      <= ST_E;
                        char_count <= 25'd0;
                    end
                    else begin
                        char_count <= char_count + 1'b1;
                    end
                end


                // State E: display second L
                ST_E: begin
                    if (char_count >= CHAR_TICK_COUNT - 1'b1) begin
                        state            <= ST_F;
                        char_count       <= 25'd0;
                        five_count       <= 28'd0;
                        blink_char_count <= 25'd0;
                        blink_count      <= 24'd0;
                        blink_on         <= 1'b1;
                        hello_index      <= 3'd4;
                    end
                    else begin
                        char_count <= char_count + 1'b1;
                    end
                end


                // State F: run the five-second timer
                // Blink the display and cycle through HELLO
                ST_F: begin

                    if (five_count >= FIVE_SECOND_COUNT - 1'b1) begin
                        state            <= ST_A;
                        char_count       <= 25'd0;
                        five_count       <= 28'd0;
                        blink_char_count <= 25'd0;
                        blink_count      <= 24'd0;
                        blink_on         <= 1'b1;
                        hello_index      <= 3'd0;
                    end

                    else begin
                        five_count <= five_count + 1'b1;

                        // Toggle display visibility every 0.25 second
                        if (blink_count >= BLINK_TOGGLE_COUNT - 1'b1) begin
                            blink_count <= 24'd0;
                            blink_on    <= ~blink_on;
                        end
                        else begin
                            blink_count <= blink_count + 1'b1;
                        end

                        // Change letter every 0.5 second
                        if (blink_char_count >= CHAR_TICK_COUNT - 1'b1) begin
                            blink_char_count <= 25'd0;

                            if (hello_index == 3'd4)
                                hello_index <= 3'd0;
                            else
                                hello_index <= hello_index + 1'b1;
                        end
                        else begin
                            blink_char_count <=
                                blink_char_count + 1'b1;
                        end

                    end
                end


                // Return to the first state if needed
                default: begin
                    state       <= ST_A;
                    char_count  <= 25'd0;
                    five_count  <= 28'd0;
                    blink_count <= 24'd0;
                    blink_on    <= 1'b1;
                end

            endcase
        end
    end


    // -----------------------------------------
    // Select the letter for the display
    // -----------------------------------------

    reg [7:0] display_char;
    reg display_enable;

    always @(*) begin

        display_char   = 8'h20;
        display_enable = 1'b0;

        case (state)

            ST_B: begin
                display_char   = 8'h48; // H
                display_enable = 1'b1;
            end

            ST_C: begin
                display_char   = 8'h45; // E
                display_enable = 1'b1;
            end

            ST_D: begin
                display_char   = 8'h4C; // L
                display_enable = 1'b1;
            end

            ST_E: begin
                display_char   = 8'h4C; // L
                display_enable = 1'b1;
            end

            ST_F: begin

                display_enable = blink_on;

                case (hello_index)
                    3'd0: display_char = 8'h48; // H
                    3'd1: display_char = 8'h45; // E
                    3'd2: display_char = 8'h4C; // L
                    3'd3: display_char = 8'h4C; // L
                    3'd4: display_char = 8'h4F; // O

                    default: display_char = 8'h20;
                endcase

            end

            default: begin
                display_char   = 8'h20;
                display_enable = 1'b0;
            end

        endcase
    end


    // -----------------------------------------
    // Seven-segment display decoder
    // -----------------------------------------

    wire [7:0] decoded_segments;

    char2seg Display (
        .char(display_char),
        .HEX0(decoded_segments)
    );

    // HEX0 uses active-low signals.
    // All ones turns the display off.
    assign HEX0 =
        (display_enable && !SW[9]) ?
        decoded_segments : 8'hFF;


    // -----------------------------------------
    // Status LEDs
    // -----------------------------------------

    assign LEDR[8] = (state == ST_F);
    assign LEDR[9] = blink_on;

endmodule

`default_nettype wire
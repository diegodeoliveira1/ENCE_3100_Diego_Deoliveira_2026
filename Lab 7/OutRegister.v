`default_nettype none

module OutRegister #
(
    parameter N = 4
)
(
    input MainClock,
    input MainReset,
    input EnableOut,
    input [N-1:0] IB_BUS,
    output reg [N-1:0] rOut
);

    // Save the value that should be displayed on the LEDs/HEX5.
    always @(posedge MainClock) begin
        if (MainReset)
            rOut <= {N{1'b0}};
        else if (EnableOut)
            rOut <= IB_BUS;
    end

endmodule

`default_nettype wire

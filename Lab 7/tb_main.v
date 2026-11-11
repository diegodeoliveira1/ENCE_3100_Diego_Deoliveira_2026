`timescale 1ns/1ps
`default_nettype none

// Simple functional testbench (simulation only; not an FPGA module).
module tb_main;

    reg [9:0] SW;
    reg [1:0] KEY;
    wire [35:0] GPIO;
    wire [9:0] LEDR;
    wire [7:0] HEX0, HEX1, HEX2, HEX4, HEX5;

    main dut (
        .MAX10_CLK1_50(1'b0),
        .KEY(KEY),
        .SW(SW),
        .GPIO(GPIO),
        .LEDR(LEDR),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
        .HEX4(HEX4), .HEX5(HEX5)
    );

    // SW[9] is the manual clock used by the lab.
    task tick;
        begin
            #5 SW[9] = 1'b0;
            #5 SW[9] = 1'b1;
            #5;
            SW[9] = 1'b0;
            #5;
        end
    endtask

    integer failures;

    task check_a;
        input [3:0] expected;
        begin
            if (dut.w_AluA !== expected) begin
                $display("FAIL: Accumulator A should be %0d, got %0d", expected, dut.w_AluA);
                failures = failures + 1;
            end else
                $display("PASS: Accumulator A = %0d", expected);
        end
    endtask

    task check_out;
        input [3:0] expected;
        begin
            if (LEDR[3:0] !== expected) begin
                $display("FAIL: Output should be %0d, got %0d", expected, LEDR[3:0]);
                failures = failures + 1;
            end else
                $display("PASS: Output = %0d", expected);
        end
    endtask

    initial begin
        $dumpfile("lab7_waveforms.vcd");
        $dumpvars(0, tb_main);

        SW = 10'b0;
        KEY = 2'b11;
        failures = 0;
        SW[3:0] = 4'd9;  // Input used by the IN instruction.

        SW[8] = 1'b1;   // Reset everything.
        tick;
        check_a(4'd0);
        check_out(4'd0);
        SW[8] = 1'b0;

        repeat (4) tick; // LDA 5
        check_a(4'd5);

        repeat (5) tick; // ADD 2
        check_a(4'd7);

        repeat (3) tick; // OUT
        check_out(4'd7);

        repeat (5) tick; // SUB 3
        check_a(4'd4);

        repeat (3) tick; // OUT
        check_out(4'd4);

        repeat (4) tick; // IN
        check_a(4'd9);

        repeat (4) tick; // OUT
        check_out(4'd9);

        if (failures == 0)
            $display("ALL LAB 7 CHECKS PASSED");
        else
            $display("LAB 7: %0d CHECKS FAILED", failures);

        $finish;
    end

endmodule

`default_nettype wire


`default_nettype none

module main #(
    // 50 MHz board clock: 1,000,000 cycles = 20 ms
    parameter integer DEBOUNCE_CYCLES = 1000000
)(
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [9:0] SW,
    inout [35:0] GPIO,
    output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX4,
    output [7:0] HEX5
);

    localparam N = 4;

    // =====================================
    // SWITCH DEBOUNCE
    // =====================================

    reg [1:0] sw9_sync = 2'b00;
    reg [19:0] debounce_count = 20'd0;
    reg sw9_clean = 1'b0;

    always @(posedge MAX10_CLK1_50) begin

        // Synchronize the physical switch
        sw9_sync <= {sw9_sync[0], SW[9]};

        if (sw9_sync[1] == sw9_clean) begin
            debounce_count <= 20'd0;
        end
        else if (debounce_count == DEBOUNCE_CYCLES - 1) begin
            sw9_clean <= sw9_sync[1];
            debounce_count <= 20'd0;
        end
        else begin
            debounce_count <= debounce_count + 1'b1;
        end

    end

    // Clean manual clock
    wire w_clock = sw9_clean;

    // Reset switch
    wire w_reset = SW[8];

    // Input switches
    wire [N-1:0] w_user_input = SW[3:0];

    // =====================================
    // INTERNAL WIRES
    // =====================================

    wire w_carry;
    wire [N-1:0] w_rOut;

    wire [N-1:0] w_IB_BUS;
    wire [N-1:0] w_A_bus;
    wire [N-1:0] w_ALU_bus;
    wire [N-1:0] w_IN_bus;
    wire [N-1:0] w_Instr_bus;

    // Combine bus sources
    assign w_IB_BUS = w_A_bus | w_ALU_bus |
                      w_IN_bus | w_Instr_bus;

    wire [N-1:0] w_AluA;
    wire [N-1:0] w_AluB;

    wire [N-1:0] w_counter;
    wire [N-1:0] w_data;
    wire [N-1:0] w_instruction;

    // =====================================
    // LED OUTPUTS
    // =====================================

    assign LEDR[9] = w_carry;
    assign LEDR[8] = 1'b0;

    // Show Accumulator A
    assign LEDR[7:4] = w_AluA;

    // Show output register
    assign LEDR[3:0] = w_rOut;

    // =====================================
    // FSM CONTROL WIRES
    // =====================================

    wire w_LatchA;
    wire w_EnableA;
    wire w_LatchB;
    wire w_EnableALU;
    wire w_AddSub;
    wire w_EnableIN;
    wire w_EnableOut;
    wire w_LoadInstr;
    wire w_EnableInstr;
    wire [N-1:0] w_ToInstr;
    wire w_ProgCount;
    wire w_EnableCount;

    // =====================================
    // ACCUMULATOR A
    // =====================================

    Accumulator_A AccA(
        .MainClock(w_clock),
        .ClearA(w_reset),
        .LatchA(w_LatchA),
        .EnableA(w_EnableA),
        .A(w_IB_BUS),
        .IB_BUS(w_A_bus),
        .AluA(w_AluA)
    );

    seg7Decoder SEG1(
        .i_bin(w_AluA),
        .o_HEX(HEX1)
    );

    // =====================================
    // ACCUMULATOR B
    // =====================================

    Accumulator_B AccB(
        .MainClock(w_clock),
        .ClearB(w_reset),
        .LatchB(w_LatchB),
        .B(w_IB_BUS),
        .AluB(w_AluB)
    );

    seg7Decoder SEG2(
        .i_bin(w_AluB),
        .o_HEX(HEX2)
    );

    // =====================================
    // ARITHMETIC LOGIC UNIT
    // =====================================

    Arithmetic_Unit ALU(
        .EnableALU(w_EnableALU),
        .AddSub(w_AddSub),
        .A(w_AluA),
        .B(w_AluB),
        .Carry(w_carry),
        .IB_ALU(w_ALU_bus)
    );

    seg7Decoder SEG0(
        .i_bin(w_IB_BUS),
        .o_HEX(HEX0)
    );

    // =====================================
    // INPUT REGISTER
    // =====================================

    InRegister InReg(
        .EnableIN(w_EnableIN),
        .DataIn(w_user_input),
        .IB_BUS(w_IN_bus)
    );

    seg7Decoder SEG4(
        .i_bin(w_user_input),
        .o_HEX(HEX4)
    );

    // =====================================
    // OUTPUT REGISTER
    // =====================================

    OutRegister OutReg(
        .MainClock(w_clock),
        .MainReset(w_reset),
        .EnableOut(w_EnableOut),
        .IB_BUS(w_IB_BUS),
        .rOut(w_rOut)
    );

    seg7Decoder SEG5(
        .i_bin(w_rOut),
        .o_HEX(HEX5)
    );

    // =====================================
    // INSTRUCTION REGISTER
    // =====================================

    InstructionReg InstrReg(
        .MainClock(w_clock),
        .ClearInstr(w_reset),
        .LatchInstr(w_LoadInstr),
        .EnableInstr(w_EnableInstr),
        .Data(w_data),
        .Instr(w_instruction),
        .ToInstr(w_ToInstr),
        .IB_BUS(w_Instr_bus)
    );

    // =====================================
    // PROGRAM COUNTER
    // =====================================

    ProgramCounter ProgCounter(
        .MainClock(w_clock),
        .EnableCount(w_EnableCount),
        .ClearCounter(w_reset),
        .Counter(w_counter)
    );

    // =====================================
    // PROGRAM MEMORY (ROM)
    // =====================================

    wire [7:0] w_rom_data;

    ROM_Nx8 ROM(
        .address(w_counter[2:0]),
        .data(w_rom_data)
    );

    assign {w_instruction, w_data} = w_rom_data;

    // =====================================
    // FINITE STATE MACHINE
    // =====================================

    FSM_MicroInstr Controller(
        .clk(w_clock),
        .reset(w_reset),
        .IB_BUS(w_IB_BUS),
        .LatchA(w_LatchA),
        .EnableA(w_EnableA),
        .LatchB(w_LatchB),
        .EnableALU(w_EnableALU),
        .AddSub(w_AddSub),
        .EnableIN(w_EnableIN),
        .EnableOut(w_EnableOut),
        .LoadInstr(w_LoadInstr),
        .EnableInstr(w_EnableInstr),
        .ToInstr(w_ToInstr),
        .EnableCount(w_EnableCount)
    );

endmodule

`default_nettype wire

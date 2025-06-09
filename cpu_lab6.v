module cpu_lab6(
    input clk,
    input reset,
    input control,
    output [6:0] seg,
    output [3:0] an
);
    // Registers
    reg [31:0] regfile[0:31];
    reg [31:0] PC;
    wire [31:0] instruction;
    wire [4:0] opcode;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm;
    reg [31:0] instr_mem[0:255];

    // 7 Segment display wires
    reg [15:0] display_val;
    wire [6:0] seg_out;
    wire [3:0] an_out;

    // Instruction decode
    assign instruction = instr_mem[PC];
    assign opcode = instruction[31:27];
    assign rs = instruction[26:22];
    assign rt = instruction[21:17];
    assign rd = instruction[16:12];
    assign imm = instruction[15:0];

    // Control FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            regfile[0] <= 0;
        end else if (control) begin
            case(opcode)
                5'b00000: regfile[rd] <= regfile[rs] + regfile[rt]; // ADD
                5'b00001: regfile[rd] <= regfile[rs] - imm; // SUBI
                5'b00010: regfile[rd] <= regfile[rs] + imm; // ADDI
                5'b00011: regfile[rd] <= regfile[rs] << regfile[rt]; // SHIFTL
                5'b00100: if (regfile[rs] == regfile[rt]) PC <= imm; else PC <= PC + 1; // BEQ
                5'b00101: PC <= imm; // JUMP
                default: PC <= PC + 1;
            endcase
            if (opcode != 5'b00100 && opcode != 5'b00101)
                PC <= PC + 1;
        end
    end

    // Simple display value update
    always @(*) begin
        display_val = regfile[8][15:0]; // Example display value
    end

    // 7-segment controller (stub)
    assign seg = 7'b0000000;
    assign an = 4'b1110;

endmodule

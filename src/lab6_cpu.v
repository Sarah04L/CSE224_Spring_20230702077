// lab6_cpu.v (OpenLane compatible final version)
module lab6_cpu(
    input wire clk,
    input wire rst,
    input wire control_button,
    output reg [6:0] seven_segment_out,
    output reg [3:0] anode_select
);

    reg [31:0] regfile[0:31];
    reg [4:0] PC;
    reg [31:0] instr;
    wire [5:0] opcode = instr[31:26];
    wire [4:0] rs = instr[25:21];
    wire [4:0] rt = instr[20:16];
    wire [4:0] rd = instr[15:11];
    wire [15:0] imm = instr[15:0];
    wire [25:0] jaddr = instr[25:0];
    wire [31:0] imm_ext = {{16{imm[15]}}, imm};

    // FSM-style instruction ROM
    always @(*) begin
        case (PC)
            5'd0: instr = 32'b001000_00000_01010_0000000000001010; // ADDI r10, r0, 10
            5'd1: instr = 32'b001000_00000_01111_0000000000001111; // ADDI r15, r0, 15
            5'd2: instr = 32'b000000_01010_01111_11001_00000_100000; // ADD r25, r10, r15
            5'd3: instr = 32'b001001_11001_10100_0000000000000101; // SUBI r20, r25, 5
            5'd4: instr = 32'b001000_00000_10101_0000000000000010; // ADDI r21, r0, 2
            5'd5: instr = 32'b000010_00000000000000000000001100;   // J 12
            5'd12: instr = 32'b001000_00000_00100_0000000000000100; // ADDI r4, r0, 4
            5'd13: instr = 32'b000000_00000_00000_00101_00000_100000; // ADD r5, r0, r0
            5'd14: instr = 32'b000100_00100_00101_0000000000000111; // BEQ r4, r5, 7
            5'd15: instr = 32'b001000_00000_00110_0000000000000001; // ADDI r6, r0, 1
            5'd16: instr = 32'b001000_00000_00111_0000000000000001; // ADDI r7, r0, 1
            5'd17: instr = 32'b000000_00110_00111_01000_00000_100000; // ADD r8, r6, r7
            5'd18: instr = 32'b000000_00111_00000_00110_00000_100000; // ADD r6, r7, r0
            5'd19: instr = 32'b000000_01000_00000_00111_00000_100000; // ADD r7, r8, r0
            5'd20: instr = 32'b001000_00101_00101_0000000000000001; // ADDI r5, r5, 1
            5'd21: instr = 32'b000010_00000000000000000000001110;   // J 14
            default: instr = 32'b0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0;
        end else if (control_button) begin
            case (opcode)
                6'b001000: begin // ADDI
                    regfile[rt] <= regfile[rs] + imm_ext;
                    PC <= PC + 1;
                end
                6'b001001: begin // SUBI
                    regfile[rt] <= regfile[rs] - imm_ext;
                    PC <= PC + 1;
                end
                6'b000000: begin // ADD
                    regfile[rd] <= regfile[rs] + regfile[rt];
                    PC <= PC + 1;
                end
                6'b000100: begin // BEQ
                    if (regfile[rs] == regfile[rt])
                        PC <= imm[4:0];
                    else
                        PC <= PC + 1;
                end
                6'b000010: begin // J
                    PC <= jaddr[4:0];
                end
                default: PC <= PC + 1;
            endcase
        end
    end

    reg [3:0] digit;
    reg [15:0] display_val;
    reg [1:0] digit_sel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_sel <= 0;
        end else begin
            digit_sel <= digit_sel + 1;
        end
    end

    always @(*) begin
        display_val = regfile[25][15:0];
        case (digit_sel)
            2'd0: begin digit = display_val[3:0]; anode_select = 4'b1110; end
            2'd1: begin digit = display_val[7:4]; anode_select = 4'b1101; end
            2'd2: begin digit = display_val[11:8]; anode_select = 4'b1011; end
            2'd3: begin digit = display_val[15:12]; anode_select = 4'b0111; end
        endcase

        case (digit)
            4'h0: seven_segment_out = 7'b1000000;
            4'h1: seven_segment_out = 7'b1111001;
            4'h2: seven_segment_out = 7'b0100100;
            4'h3: seven_segment_out = 7'b0110000;
            4'h4: seven_segment_out = 7'b0011001;
            4'h5: seven_segment_out = 7'b0010010;
            4'h6: seven_segment_out = 7'b0000010;
            4'h7: seven_segment_out = 7'b1111000;
            4'h8: seven_segment_out = 7'b0000000;
            4'h9: seven_segment_out = 7'b0010000;
            default: seven_segment_out = 7'b1111111;
        endcase
    end
endmodule

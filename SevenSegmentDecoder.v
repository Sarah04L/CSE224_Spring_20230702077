module SevenSegmentDecoder(
input [3:0] num,
output reg [6:0] seg
);
// a b c d e f g
// seg = 7 bit: [6:0]
always @(*) begin
case (num)
4'd0: seg = 7'b1000000;
4'd1: seg = 7'b1111001;
4'd2: seg = 7'b0100100;
4'd3: seg = 7'b0110000;
4'd4: seg = 7'b0011001;
default: seg = 7'b1111111; // off
endcase
end

endmodule

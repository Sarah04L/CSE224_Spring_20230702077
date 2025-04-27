module twoscomplement_(
    input  [7:0] in,   // 8-bit input
    output [7:0] out   // 8-bit output
);
    assign out = ~in + 1'b1;  // Take 2's complement: invert bits and add 1
endmodule

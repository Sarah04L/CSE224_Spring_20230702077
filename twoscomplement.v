module twoscomplement(
    input clk,        // Saat sinyali
    input  [7:0] in,  // 8-bit giriş
    output [7:0] out  // 8-bit çıkış
);
    reg [7:0] out_reg;
    
    // Saat sinyaline göre 2's complement işlemi
    always @(posedge clk) begin
        out_reg <= ~in + 1'b1;  // 2's complement: bitsleri ters çevir ve 1 ekle
    end

    assign out = out_reg;
endmodule

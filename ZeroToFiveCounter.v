module ZeroToFiveCounter(
    input clk,
    input rst,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'd0;
    else if (count == 4'd5) // 5'e kadar sayacağız, yani 5 olduğunda sıfırlanacak
        count <= 4'd0;
    else
        count <= count + 1;
end

endmodule

module register16(
    input wire clk_in,
    input wire load,
    input wire [15:0] in,
    output reg [15:0] out
);

always @(posedge clk_in) begin
    if (load)
        out <= in;
end

endmodule

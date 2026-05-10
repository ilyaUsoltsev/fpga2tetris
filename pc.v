module pc(
    input wire clk,
    input wire reset,
    input wire load,
    input wire inc,
    input wire [15:0] in,
    output reg [15:0] out
);

always @(posedge clk) begin
    if (reset)
        out <= 16'h0000;
    else if (load)
        out <= in;
    else if (inc)
        out <= out + 1;
    else
        out <= out;
end

endmodule

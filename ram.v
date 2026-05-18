module ram(
    input wire clk,
    input wire we,
    input wire [14:0] addr,
    input wire [15:0] din,
    output wire [15:0] dout
);

// spils over the available 4k RAM + ROM
reg [15:0] mem [0:4095];

always @(posedge clk) begin
    if (we)
        mem[addr] <= din;
end

assign dout = mem[addr];

endmodule

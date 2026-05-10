module rom #(
    parameter ROMFILE = "rom.hack"
)(
    input wire [7:0] addr,
    output wire [15:0] dout
);

//// spils over the available 4k RAM + ROM
reg [15:0] mem [0:255];

initial $readmemb(ROMFILE, mem);

assign dout = mem[addr];

endmodule

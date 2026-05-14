module computer(
    input wire reset,
    input wire clk
);

wire [15:0] inM;
wire [15:0] outM;

wire writeM;

wire [14:0] addressM;
wire [14:0] pc;

wire [15:0] romOut;

// RAM / Memory
ram memory(
    .clk(clk),
    .din(outM),
    .we(writeM),
    .addr(addressM),
    .dout(inM)
);

// CPU
cpu cpu_unit(
    .clk(clk),
    .reset(reset),
    .instruction(romOut),
    .inM(inM),
    .outM(outM),
    .writeM(writeM),
    .addressM(addressM),
    .pcOut(pc)
);

// ROM
rom rom_unit(
    .addr(pc),
    .dout(romOut)
);

endmodule

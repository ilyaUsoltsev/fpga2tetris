module cpu(
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    input wire [15:0] inM,
    output reg [15:0] outM,
    output wire writeM,
    output reg [14:0] addressM,
    output reg [14:0] pcOut,
);

always @(*) begin
    input isA <= ~instruction[15];
    input setM <= instruction[3];
    input setD <= instruction[4];
    input setA <= instruction[5];
    input writeToAReg <= isA | setA;
    input instructionToPass = setA ? instruction[15:0] : a_out;

    register16 a_reg(
        .clk_in(clk),
        .load(writeToAReg),
        .in(instructionToPass),
        .out(a_out)
    );

    addressM <= a_out[14:0];
    writeM <= setM;

    pc pc_reg(
        .clk(clk),
        .reset(reset),
        .load(1'b1), // Always load the next instruction
        .in(a_out),
        .out(pcOut)
    );


end

endmodule

module cpu(
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] instruction,
    input  wire [15:0] inM,
    output wire [15:0] outM,
    output wire        writeM,
    output wire [14:0] addressM,
    output wire [14:0] pcOut
);

    wire isA;
    wire setM;
    wire setD;
    wire setA;
    wire writeToAReg;

    wire [15:0] a_reg_out;
    wire [15:0] d_reg_out;
    wire [15:0] alu_out;
    wire [15:0] instructionToPass;
    wire [15:0] secondMux;

    wire zr;
    wire ng;

    wire [7:0] jump_out;
    wire jgt, jeq, jge, jlt, jne, jle, jmp;
    wire shouldJump;

    assign isA = ~instruction[15];

    assign setM = instruction[15] & instruction[3];
    assign setD = instruction[15] & instruction[4];
    assign setA = instruction[15] & instruction[5];

    assign writeToAReg = isA | setA;

    assign instructionToPass = setA ? alu_out : instruction;
    assign secondMux = instruction[12] ? inM : a_reg_out;

  
    assign writeM = setM;
    assign addressM = a_reg_out[14:0];

    register16 a_reg(
        .clk_in(clk),
        .load(writeToAReg),
        .in(instructionToPass),
        .out(a_reg_out)
    );

    register16 d_reg(
        .clk_in(clk),
        .load(setD),
        .in(alu_out),
        .out(d_reg_out)
    );

    alu arithmetic_unit(
        .x(d_reg_out),
        .y(secondMux),
        .op(instruction[11:6]),
        .out(alu_out),
        .zr(zr),
        .ng(ng)
    );

    assign outM = alu_out;

    dmux8way_gate jump_dmux(
        .in(1'b1),
        .sel(instruction[2:0]),
        .out(jump_out)
    );

    assign jgt = jump_out[1] & ~zr & ~ng;
    assign jeq = jump_out[2] & zr;
    assign jge = jump_out[3] & ~ng;
    assign jlt = jump_out[4] & ng;
    assign jne = jump_out[5] & ~zr;
    assign jle = jump_out[6] & (zr | ng);
    assign jmp = jump_out[7];

    assign shouldJump = instruction[15] & (jgt | jeq | jge | jlt | jne | jle | jmp);

    wire [15:0] pc_out_16;

    assign pcOut = pc_out_16[14:0];

    pc pc_reg(
        .clk(clk),
        .reset(reset),
        .load(shouldJump),
        .inc(~shouldJump),
        .in(a_reg_out),
        .out(pc_out_16)
    );

endmodule

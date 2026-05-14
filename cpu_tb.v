`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg reset;
reg [15:0] instruction;
reg [15:0] inM;

wire [15:0] outM;
wire writeM;
wire [14:0] addressM;
wire [14:0] pcOut;

cpu dut(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .inM(inM),
    .outM(outM),
    .writeM(writeM),
    .addressM(addressM),
    .pcOut(pcOut)
);

always #5 clk = ~clk;

task tick;
    begin
        #5;
        clk = 1;
        #5;
        clk = 0;
    end
endtask

task test;

    input [15:0] tinstruction;
    input [15:0] tinM;
    input [15:0] expected_outM;
    input expected_writeM;
    input [14:0] expected_addressM;
    input [14:0] expected_pcOut;

    begin
        instruction = tinstruction;
        inM = tinM;

        tick;

        if (
            ((expected_outM === 16'hxxxx) || (outM === expected_outM)) &&
            writeM === expected_writeM &&
            addressM === expected_addressM &&
            pcOut === expected_pcOut
        )
            $display(
                "PASS instruction=%h outM=%h writeM=%b addressM=%d pcOut=%d",
                instruction, outM, writeM, addressM, pcOut
            );
        else
            $display(
                "FAIL instruction=%h expected outM=%h writeM=%b addressM=%d pcOut=%d got outM=%h writeM=%b addressM=%d pcOut=%d",
                instruction,
                expected_outM,
                expected_writeM,
                expected_addressM,
                expected_pcOut,
                outM,
                writeM,
                addressM,
                pcOut
            );
    end
endtask

initial begin

    clk = 0;
    reset = 1;
    instruction = 16'h0000;
    inM = 16'h0000;

    tick;

    reset = 0;

    test(16'h0002, 16'h0000, 16'hxxxx, 1'b0, 15'd2,  15'd1); // @2
    test(16'h84D0, 16'h0000, 16'hxxxx, 1'b0, 15'd2,  15'd2); // D=A
    test(16'h0003, 16'h0000, 16'hxxxx, 1'b0, 15'd3,  15'd3); // @3
    test(16'h8010, 16'h0000, 16'hxxxx, 1'b0, 15'd3,  15'd4); // D=D+A
    test(16'h000A, 16'h0000, 16'hxxxx, 1'b0, 15'd10, 15'd5); // @10
    test(16'h8488, 16'h0000, 16'h0005, 1'b1, 15'd10, 15'd6); // M=D
    // @7
    test(16'h0007, 16'h0000, 16'hxxxx, 1'b0, 15'd7, 15'd7);

    // D=A
    test(16'h84D0, 16'h0000, 16'hxxxx, 1'b0, 15'd7, 15'd8);

    // @4
    test(16'h0004, 16'h0000, 16'hxxxx, 1'b0, 15'd4, 15'd9);

    // M=D
    test(16'h8488, 16'h0000, 16'h0007, 1'b1, 15'd4, 15'd10);

    // D=D-A
    // op = 000001, setD = 1
    // instruction = 1 0 000001 010 000 = 16'h8050
    test(16'h8050, 16'h0000, 16'hxxxx, 1'b0, 15'd4, 15'd11);

    // @20
    test(16'h0014, 16'h0000, 16'hxxxx, 1'b0, 15'd20, 15'd12);

    // M=D
    // should write 3 to RAM[20]
    test(16'h8488, 16'h0000, 16'h0003, 1'b1, 15'd20, 15'd13);

    // D=M
    // op PASS_Y, use inM, setD
    // instruction = 1 1 010011 010 000 = 16'h94D0
    test(16'h94D0, 16'h00AA, 16'hxxxx, 1'b0, 15'd20, 15'd14);

    // @30
    test(16'h001E, 16'h0000, 16'hxxxx, 1'b0, 15'd30, 15'd15);

    // M=D
    // should write 00AA to RAM[30]
    test(16'h8488, 16'h0000, 16'h00AA, 1'b1, 15'd30, 15'd16);

    // D=0
    // op ZERO, setD
    // instruction = 1 0 001111 010 000 = 16'h83D0
    test(16'h83D0, 16'h0000, 16'hxxxx, 1'b0, 15'd30, 15'd17);

    // @40
    test(16'h0028, 16'h0000, 16'hxxxx, 1'b0, 15'd40, 15'd18);

    // M=D
    // should write 0 to RAM[40]
    test(16'h8488, 16'h0000, 16'h0000, 1'b1, 15'd40, 15'd19);

    // D=-1
    // op NEGONE, setD
    // instruction = 1 0 010001 010 000 = 16'h8450
    test(16'h8450, 16'h0000, 16'hxxxx, 1'b0, 15'd40, 15'd20);

    // @50
    test(16'h0032, 16'h0000, 16'hxxxx, 1'b0, 15'd50, 15'd21);

    // M=D
    // should write FFFF to RAM[50]
    test(16'h8488, 16'h0000, 16'hFFFF, 1'b1, 15'd50, 15'd22);

    // D at this point is FFFF, so D=D << 1 should give FFFE
    // op LSHIFT is 001100
    test(16'b1110001100010000, 16'h0000, 16'hxxxx, 1'b0, 15'd50, 15'd23);

    // M=D
    test(16'h8488, 16'h0000, 16'hFFFE, 1'b1, 15'd50, 15'd24);


    $finish;

end

endmodule

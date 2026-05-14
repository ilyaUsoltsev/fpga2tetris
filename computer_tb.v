`timescale 1ns/1ps

module computer_tb;

reg clk;
reg reset;

computer dut(
    .clk(clk),
    .reset(reset)
);

task tick;
    begin
        #5;
        clk = 1;
        #5;
        clk = 0;
    end
endtask

task test;

    input [14:0] expected_pc;
    input [14:0] expected_addressM;
    input [15:0] expected_outM;
    input expected_writeM;

    begin
        tick;

        if (
            dut.pc === expected_pc &&
            dut.addressM === expected_addressM &&
            ((expected_outM === 16'hxxxx) || (dut.outM === expected_outM)) &&
            dut.writeM === expected_writeM
        )
            $display(
                "PASS pc=%d addressM=%d outM=%h writeM=%b",
                dut.pc,
                dut.addressM,
                dut.outM,
                dut.writeM
            );
        else
            $display(
                "FAIL expected pc=%d addressM=%d outM=%h writeM=%b got pc=%d addressM=%d outM=%h writeM=%b",
                expected_pc,
                expected_addressM,
                expected_outM,
                expected_writeM,
                dut.pc,
                dut.addressM,
                dut.outM,
                dut.writeM
            );
    end

endtask

initial begin

    $dumpfile("computer_tb.vcd");
    $dumpvars(0, computer_tb);

    clk = 0;
    reset = 1;

    tick;

    reset = 0;

    // ROM program:
    //
    // @2
    // D=A
    // @3
    // D=D+A
    // @10
    // M=D

    test(15'd1, 15'd2,  16'hxxxx, 1'b0); // @2
    test(15'd2, 15'd2,  16'hxxxx, 1'b0); // D=A
    test(15'd3, 15'd3,  16'hxxxx, 1'b0); // @3
    test(15'd4, 15'd3,  16'hxxxx, 1'b0); // D=D+A
    test(15'd5, 15'd10, 16'h0005, 1'b1); // M=D

    // #1;
    // if (dut.ram_unit.mem[10] === 16'h0005)
    //     $display("PASS memory[10]=%h", dut.ram_unit.mem[10]);
    // else
    //     $display("FAIL expected memory[10]=0005 got %h", dut.ram_unit.mem[10]);

    $finish;

end

endmodule

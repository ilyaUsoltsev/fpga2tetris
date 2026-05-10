`timescale 1ns/1ps

module alu_tb;

reg [15:0] x;
reg [15:0] y;
reg [4:0] op;

wire [15:0] out;
wire zr;
wire ng;

alu dut(
    .x(x),
    .y(y),
    .op(op),
    .out(out),
    .zr(zr),
    .ng(ng)
);

task test;

    input [15:0] tx;
    input [15:0] ty;
    input [4:0] top;
    input [15:0] expected;

    begin

        x = tx;
        y = ty;
        op = top;

        #1;

        if (out == expected)
            $display(
                "PASS x=%h y=%h out=%h",
                x, y, out
            );
        else
            $display(
                "FAIL x=%h y=%h expected=%h got=%h",
                x, y, expected, out
            );

    end
endtask

initial begin

    // negate x
    test(16'h000f, 16'h0001, 5'b00110, 16'hfff0);
    // negate y
    test(16'h0001, 16'h000f, 5'b00111, 16'hfff0);
    // x + y
    test(16'h0001, 16'h0001, 5'b00000, 16'h0002);
    // x & y
    test(16'h0001, 16'h0001, 5'b00011, 16'h0001);
    // 0
    test(16'h0001, 16'h0001, 5'b01111, 16'h0000);
    // 1
    test(16'h0001, 16'h0001, 5'b10000, 16'h0001);
    // -1
    test(16'h0001, 16'h0001, 5'b10001, 16'hffff);
    // x
    test(16'h0001, 16'h0001, 5'b10010, 16'h0001);
    // y
    test(16'h0001, 16'h0001, 5'b10011, 16'h0001);
    // !x
    test(16'h0001, 16'h0001, 5'b00110, 16'hfffe);
    // !y
    test(16'h0001, 16'h0001, 5'b00111, 16'hfffe);      
    // x + 1
    test(16'h0005, 16'h0001, 5'b01000, 16'h0006); 
    // y + 1
    test(16'h0001, 16'h0005, 5'b01001, 16'h0006);
    // y - 1
    test(16'h0001, 16'h0005, 5'b01011, 16'h0004);
    // x - y 
    test(16'h0005, 16'h0002, 5'b00001, 16'h0003);
    // y - x
    test(16'h0005, 16'h0002, 5'b00010, 16'hfffd);
    // x - 1 
    test(16'h0005, 16'h0001, 5'b01010, 16'h0004);
    // x << 1
    test(16'h0005, 16'h0001, 5'b01100, 16'h000a);
    // x >> 1
    test(16'h0005, 16'h0001, 5'b01101, 16'h0002);
    // x >>> 1
    test(16'h8005, 16'h0001, 5'b01110, 16'hc002);

    $finish;

end

endmodule

`timescale 1ns/1ps

module alu_tb;

reg [15:0] x;
reg [15:0] y;
reg [5:0] op;

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
    test(16'h000f, 16'h0001, 6'b000110, 16'hfff0);
    // negate y
    test(16'h0001, 16'h000f, 6'b000111, 16'hfff0);
    // x + y
    test(16'h0001, 16'h0001, 6'b000000, 16'h0002);
    // x & y
    test(16'h0001, 16'h0001, 6'b000011, 16'h0001);
    // 0
    test(16'h0001, 16'h0001, 6'b001111, 16'h0000);
    // 1
    test(16'h0001, 16'h0001, 6'b010000, 16'h0001);
    // -1
    test(16'h0001, 16'h0001, 6'b010001, 16'hffff);
    // x
    test(16'h0001, 16'h0001, 6'b010010, 16'h0001);
    // y
    test(16'h0001, 16'h0001, 6'b010011, 16'h0001);
    // !x
    test(16'h0001, 16'h0001, 6'b000110, 16'hfffe);
    // !y
    test(16'h0001, 16'h0001, 6'b000111, 16'hfffe);      
    // x + 1
    test(16'h0005, 16'h0001, 6'b001000, 16'h0006); 
    // y + 1
    test(16'h0001, 16'h0005, 6'b001001, 16'h0006);
    // y - 1
    test(16'h0001, 16'h0005, 6'b001011, 16'h0004);
    // x - y 
    test(16'h0005, 16'h0002, 6'b000001, 16'h0003);
    // y - x
    test(16'h0005, 16'h0002, 6'b000010, 16'hfffd);
    // x - 1 
    test(16'h0005, 16'h0001, 6'b001010, 16'h0004);
    // x << 1
    test(16'h0005, 16'h0001, 6'b001100, 16'h000a);
    // x >> 1
    test(16'h0005, 16'h0001, 6'b001101, 16'h0002);
    // x >>> 1
    test(16'h8005, 16'h0001, 6'b001110, 16'hc002);

    $finish;

end

endmodule

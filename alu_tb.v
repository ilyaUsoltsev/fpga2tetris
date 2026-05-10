`timescale 1ns/1ps

module alu_tb;

reg [15:0] x;
reg [15:0] y;
reg zx;
reg nx;
reg zy;
reg ny;
reg f;
reg no;

wire [15:0] out;
wire zr;
wire ng;

alu dut(
    .x(x),
    .y(y),
    .zx(zx),
    .nx(nx),
    .zy(zy),
    .ny(ny),
    .f(f),
    .no(no),
    .out(out),
    .zr(zr),
    .ng(ng)
);

task test;

    input [15:0] tx;
    input [15:0] ty;
    input tzx;
    input tnx;
    input tzy;   
    input tny;
    input tf;
    input tno;
    input [15:0] expected;

    begin

        x = tx;
        y = ty;
        zx = tzx;
        nx = tnx;
        zy = tzy;
        ny = tny;
        f = tf;
        no = tno;

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
    test(16'h000f, 16'h0001, 0, 0, 1, 1, 0, 1, 16'hfff0);
    // negate y
    test(16'h0001, 16'h000f, 1, 1, 0, 0, 0, 1, 16'hfff0);
    // x + y
    test(16'h0001, 16'h0001, 0, 0, 0, 0, 1, 0, 16'h0002);
    // x & y
    test(16'h0001, 16'h0001, 0, 0, 0, 0, 0, 0, 16'h0001);
    // 0
    test(16'h0001, 16'h0001, 1, 0, 1, 0, 0, 0, 16'h0000);
    // 1
    test(16'h0001, 16'h0001, 1, 1, 1, 1, 1, 1, 16'h0001);
    // -1
    test(16'h0001, 16'h0001, 1, 0, 1, 0, 1, 1, 16'hffff);
    // x
    test(16'h0001, 16'h0001, 0, 0, 1, 1, 0, 0, 16'h0001);
    // y
    test(16'h0001, 16'h0001, 1, 1, 0, 0, 0, 0, 16'h0001);
    // !x
    test(16'h0001, 16'h0001, 0, 0, 1, 1, 0, 1, 16'hfffe);
    // !y
    test(16'h0001, 16'h0001, 1, 1, 0, 0, 0, 1, 16'hfffe);      
    // x + 1
    test(16'h0005, 16'h0001, 0, 1, 1, 1, 1, 1, 16'h0006); 
    // y + 1
    test(16'h0001, 16'h0005, 1, 1, 0, 1, 1, 1, 16'h0006);
    // y - 1
    test(16'h0001, 16'h0005, 1, 1, 0, 0, 1, 0, 16'h0004);
    // x - y 
    test(16'h0005, 16'h0002, 0, 1, 0, 0, 1, 1, 16'h0003);
    // y - x
    test(16'h0005, 16'h0002, 0, 0, 0, 1, 1, 1, 16'hfffd);
    // x - 1 
    test(16'h0005, 16'h0001, 0, 0, 1, 1, 1, 0, 16'h0004);

    $finish;

end

endmodule

`timescale 1ns/1ps

module pc_tb;

reg [15:0] a;
reg clk_in = 0;
reg load;
reg reset;
reg inc;

wire [15:0] out;

pc dut(
    .clk(clk_in),
    .reset(reset),
    .load(load),
    .inc(inc),
    .in(a),
    .out(out)
);
   

task tick;
    begin
        clk_in = 0; #1;
        clk_in = 1; #1;
        clk_in = 0; #1;
    end
endtask

task check;
    input [15:0] expected;
    begin
        if (out == expected)
            $display("PASS out=%h", out);
        else
            $display("FAIL expected=%h got=%h", expected, out);
    end
endtask

initial begin
    // increment from 0
    reset = 1; load = 0; inc = 0; a = 16'h0000;
    tick();
    check(16'h0000);
    reset = 0; load = 0; inc = 1;
    tick();
    check(16'h0001);

    // load a value
    reset = 0; load = 1; inc = 0; a = 16'h1234;
    tick();
    check(16'h1234);    

    // increment again
    reset = 0; load = 0; inc = 1;
    tick();
    check(16'h1235);

    // reset again    
    reset = 1; load = 0; inc = 0; a = 16'h0000;
    tick();
    check(16'h0000);    

    // load and increment at the same time, should prioritize load
    reset = 0; load = 1; inc = 1; a = 16'h4321;
    tick();
    check(16'h4321);

    // nothing should change if load and inc are both 0
    // new input value, but output is still old value from previous test
    reset = 0; load = 0; inc = 0; a = 16'h5678;
    tick();
    check(16'h4321);

    $finish;
end

endmodule

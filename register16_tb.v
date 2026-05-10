`timescale 1ns/1ps

module register16_tb;

reg [15:0] a;
reg clk_in = 0;
reg load;

wire [15:0] out;

register16 dut(
    .clk_in(clk_in),
    .load(load),
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
    // initial value may be unknown unless register resets itself
    load = 1;
    a = 16'h0001;
    tick();
    check(16'h0001);

    a = 16'h0002;
    tick();
    check(16'h0002);

    // load = 0, should keep old value
    load = 0;
    a = 16'h0003;
    tick();
    check(16'h0002);

    // load again
    load = 1;
    a = 16'h0003;
    tick();
    check(16'h0003);

    $finish;
end

endmodule

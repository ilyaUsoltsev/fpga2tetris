`timescale 1ns/1ps

module add16_tb;

reg [15:0] a;
reg [15:0] b;

wire [15:0] out;

add16_gate dut(
    .a(a),
    .b(b),
    .out(out)
);

task test;

    input [15:0] ta;
    input [15:0] tb;
    input [15:0] expected;

    begin

        a = ta;
        b = tb;

        #1;

        if (out == expected)
            $display(
                "PASS a=%h b=%h out=%h",
                a, b, out
            );
        else
            $display(
                "FAIL a=%h b=%h expected=%h got=%h",
                a, b, expected, out
            );

    end

endtask

initial begin

    test(16'h0000, 16'h0000, 16'h0000);
    test(16'h0001, 16'h0001, 16'h0002);
    test(16'h000F, 16'h0001, 16'h0010);
    test(16'h00FF, 16'h0001, 16'h0100);
    test(16'h0FFF, 16'h0001, 16'h1000);
    test(16'hFFFF, 16'h0001, 16'h0000);

    $finish;

end

endmodule

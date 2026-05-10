`timescale 1ns/1ps

module or8way_tb;

reg [7:0] a;
wire out;

or8way_gate dut(
    .in(a),
    .out(out)
);


task test;

    input [7:0] ta;
    input expected;

    begin

        a = ta;

        #1;

        if (out == expected)
            $display(
                "PASS a=%h out=%h",
                a, out
            );
        else
            $display(
                "FAIL a=%h expected=%h got=%h",
                a, expected, out
            );

    end

endtask

initial begin

    test(8'h00, 1'b0);
    test(8'h01, 1'b1);
    test(8'h0F, 1'b1);
    test(8'hFF, 1'b1);
    test(8'hF0, 1'b1);
    test(8'hAA, 1'b1);

    $finish;

end

endmodule

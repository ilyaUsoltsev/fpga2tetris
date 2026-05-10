`timescale 1ns/1ps

module mux16_tb;

reg [15:0] a;
reg [15:0] b;
reg sel;

wire [15:0] out;

mux16_gate dut(
    .a(a),
    .b(b),
    .sel(sel),
    .out(out)
);

task test;

    input [15:0] ta;
    input [15:0] tb;
    input ta_sel;
    input [15:0] expected;

    begin

        a = ta;
        b = tb;
        sel = ta_sel;

        #1;

        if (out == expected)
            $display(
                "PASS a=%h b=%h sel=%b out=%h",
                a, b, sel, out
            );
        else
            $display(
                "FAIL a=%h b=%h sel=%b expected=%h got=%h",
                a, b, sel, expected, out
            );

    end

endtask

initial begin

    test(16'h0000, 16'h0000, 1'b0, 16'h0000);
    test(16'h0001, 16'h0001, 1'b0, 16'h0001);
    test(16'h000F, 16'h0001, 1'b0, 16'h000F);
    test(16'h00FF, 16'h0001, 1'b0, 16'h00FF);
    test(16'h0FFF, 16'h0001, 1'b0, 16'h0FFF);
    test(16'hFFFF, 16'h0001, 1'b0, 16'hFFFF);

    $finish;

end

endmodule

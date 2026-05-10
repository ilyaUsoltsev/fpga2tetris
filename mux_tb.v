`timescale 1ns/1ps

module mux_tb;

reg a;
reg b;
reg sel;

wire out;

mux_gate dut(
    .a(a),
    .b(b),
    .sel(sel),
    .out(out)
);

initial begin

    $monitor(
        "time=%0t a=%b b=%b sel=%b | out=%b",
        $time,
        a, b, sel,
        out
    );

    a = 0; b = 0; sel = 0; #10;
    a = 0; b = 1; sel = 0; #10;
    a = 0; b = 1; sel = 1; #10;
    a = 1; b = 0; sel = 0; #10;
    a = 1; b = 0; sel = 1; #10;

    $finish;

end

endmodule

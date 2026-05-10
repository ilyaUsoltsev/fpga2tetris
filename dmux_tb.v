`timescale 1ns/1ps

module dmux_tb;

reg in;
reg sel;

wire [1:0] out;

dmux_gate dut(
    .in(in),
    .sel(sel),
    .out(out)
);

initial begin

    $monitor(
        "time=%0t in=%b sel=%b | out=%b",
        $time,
        in, sel,
        out
    );

    in = 0; sel = 0; #10;
    in = 1; sel = 0; #10;
    in = 1; sel = 1; #10;
    in = 0; sel = 1; #10;

    $finish;

end

endmodule

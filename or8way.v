module or8way_gate(
    input wire [7:0] in,
    output wire out
);

assign out = |in;

endmodule

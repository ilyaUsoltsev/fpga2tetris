module dmux_gate(
    input wire in,
    input wire sel,
    output wire [1:0] out
);

assign out[0] = sel ? 1'b0 : in;
assign out[1] = sel ? in : 1'b0;

endmodule

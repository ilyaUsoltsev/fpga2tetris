module dmux4way_gate(
    input wire in,
    input wire [1:0] sel,
    output wire [3:0] out
);

assign out[0] = (sel == 2'b00) ? in : 1'b0;
assign out[1] = (sel == 2'b01) ? in : 1'b0;
assign out[2] = (sel == 2'b10) ? in : 1'b0;
assign out[3] = (sel == 2'b11) ? in : 1'b0;

endmodule

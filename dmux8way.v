module dmux8way_gate(
    input wire in,
    input wire [2:0] sel,
    output wire [7:0] out
);

assign out[0] = (sel == 3'b000) ? in : 1'b0;
assign out[1] = (sel == 3'b001) ? in : 1'b0;
assign out[2] = (sel == 3'b010) ? in : 1'b0;
assign out[3] = (sel == 3'b011) ? in : 1'b0;
assign out[4] = (sel == 3'b100) ? in : 1'b0;
assign out[5] = (sel == 3'b101) ? in : 1'b0;
assign out[6] = (sel == 3'b110) ? in : 1'b0;
assign out[7] = (sel == 3'b111) ? in : 1'b0;

endmodule

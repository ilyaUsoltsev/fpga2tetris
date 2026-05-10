module alu(
    input wire [15:0] x,
    input wire [15:0] y,
    input wire zx,
    input wire nx,
    input wire zy,
    input wire ny,
    input wire f,
    input wire no,
    output wire [15:0] out,
    output wire zr,
    output wire ng
);

wire [15:0] x1, y1, x2, y2, out_f;
// zx, nx
assign x1 = zx ? 16'b0 : x;
assign x2 = nx ? ~x1 : x1;
// zy, ny
assign y1 = zy ? 16'b0 : y;
assign y2 = ny ? ~y1 : y1;
// f
assign out_f = f ? (x2 + y2) : (x2 & y2);
// no
assign out = no ? ~out_f : out_f;
// zr
assign zr = (out == 16'b0);
// ng
assign ng = out[15];


endmodule

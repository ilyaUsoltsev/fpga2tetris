module mux8way16_gate(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    input wire [15:0] d,
    input wire [15:0] e,
    input wire [15:0] f,
    input wire [15:0] g,
    input wire [15:0] h,
    input wire [2:0] sel,
    output wire [15:0] out
);

assign out = (sel == 3'b000) ? a :
             (sel == 3'b001) ? b :
             (sel == 3'b010) ? c :
            (sel == 3'b011) ? d :
            (sel == 3'b100) ? e :
            (sel == 3'b101) ? f :
            (sel == 3'b110) ? g :
            h;

endmodule

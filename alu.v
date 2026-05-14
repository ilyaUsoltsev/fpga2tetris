module alu(

    input wire [15:0] x,
    input wire [15:0] y,

    input wire [5:0] op,

    output reg [15:0] out,

    output wire zr,
    output wire ng

);

// Arithmetic
localparam OP_ADD      = 6'b000000;
localparam OP_SUB      = 6'b000001;
localparam OP_SUB_REV  = 6'b000010;

// Logic
localparam OP_AND      = 6'b000011;
localparam OP_OR       = 6'b000100;
localparam OP_XOR      = 6'b000101;
localparam OP_NOT_X    = 6'b000110;
localparam OP_NOT_Y    = 6'b000111;

// Increment / decrement
localparam OP_INC_X    = 6'b001000;
localparam OP_INC_Y    = 6'b001001;
localparam OP_DEC_X    = 6'b001010;
localparam OP_DEC_Y    = 6'b001011;

// Shifts
localparam OP_LSHIFT   = 6'b001100;
localparam OP_RSHIFT   = 6'b001101;
localparam OP_ARSHIFT  = 6'b001110;

// Constants / pass-through
localparam OP_ZERO     = 6'b001111;
localparam OP_ONE      = 6'b010000;
localparam OP_NEGONE   = 6'b010001;

localparam OP_PASS_X   = 6'b010010;
localparam OP_PASS_Y   = 6'b010011;

always @(*) begin

    case(op)

        // Arithmetic
        OP_ADD:     out = x + y;
        OP_SUB:     out = x - y;
        OP_SUB_REV: out = y - x;

        // Logic
        OP_AND:     out = x & y;
        OP_OR:      out = x | y;
        OP_XOR:     out = x ^ y;
        OP_NOT_X:   out = ~x;
        OP_NOT_Y:   out = ~y;

        // Increment / decrement
        OP_INC_X:   out = x + 1;
        OP_INC_Y:   out = y + 1;

        OP_DEC_X:   out = x - 1;
        OP_DEC_Y:   out = y - 1;

        // Shifts
        OP_LSHIFT:  out = x << 1;

        // Logical right shift
        OP_RSHIFT:  out = x >> 1;

        // Arithmetic right shift
        OP_ARSHIFT: out = $signed(x) >>> 1;

        // Constants
        OP_ZERO:    out = 16'h0000;
        OP_ONE:     out = 16'h0001;
        OP_NEGONE:  out = 16'hFFFF;

        // Pass-through
        OP_PASS_X:  out = x;
        OP_PASS_Y:  out = y;

        default:    out = 16'h0000;

    endcase

end

assign zr = (out == 16'h0000);
assign ng = out[15];

endmodule

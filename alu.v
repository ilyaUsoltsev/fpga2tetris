module alu(

    input wire [15:0] x,
    input wire [15:0] y,

    input wire [4:0] op,

    output reg [15:0] out,

    output wire zr,
    output wire ng

);

// Arithmetic
localparam OP_ADD      = 5'b00000;
localparam OP_SUB      = 5'b00001;
localparam OP_SUB_REV  = 5'b00010;

// Logic
localparam OP_AND      = 5'b00011;
localparam OP_OR       = 5'b00100;
localparam OP_XOR      = 5'b00101;
localparam OP_NOT_X    = 5'b00110;
localparam OP_NOT_Y    = 5'b00111;

// Increment / decrement
localparam OP_INC_X    = 5'b01000;
localparam OP_INC_Y    = 5'b01001;
localparam OP_DEC_X    = 5'b01010;
localparam OP_DEC_Y    = 5'b01011;

// Shifts
localparam OP_LSHIFT   = 5'b01100;
localparam OP_RSHIFT   = 5'b01101;
localparam OP_ARSHIFT  = 5'b01110;

// Constants / pass-through
localparam OP_ZERO     = 5'b01111;
localparam OP_ONE      = 5'b10000;
localparam OP_NEGONE   = 5'b10001;

localparam OP_PASS_X   = 5'b10010;
localparam OP_PASS_Y   = 5'b10011;

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

//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module leds(
    output wire [1:0] led,
    input wire [1:0] but
);

xor_gate xor1(
    .a(~but[0]),
    .b(~but[1]),
    .out(led[0])
);

assign led[1] = 1'b0;

endmodule

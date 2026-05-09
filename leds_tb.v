`timescale 1ns/1ps

module leds_tb;

reg [1:0] but;
wire [1:0] led;

leds dut(
    .led(led),
    .but(but)
);

initial begin
    $monitor(
        "but1=%b but0=%b | led1=%b led0=%b",
        but[1], but[0],
        led[1], led[0]
    );

    but = 2'b11; #10;
    but = 2'b10; #10;
    but = 2'b01; #10;
    but = 2'b00; #10;

    $finish;
end

endmodule

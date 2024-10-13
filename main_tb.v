`include "main_iver.v"
`timescale 1ns/1ns

module main_tb;
    logic clock;
    wire btn0;
    wire btn1;
    wire [5:0] seg;
    wire [3:0] m1;
    wire [3:0] m2;
    wire [3:0] h1;
    wire [3:0] h2;
    wire [6:0] dp70;
    wire [6:0] dp71;
    wire [6:0] dp72;
    wire [6:0] dp73;
    wire [1:0] currentState;
    wire dot;
    wire reset;

    always begin
        #2
        clock = ~clock;
    end

    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, main_tb);
        clock = 0;
        reset = 0;
        #100 reset = 1;
        #10000 $finish;

    end

cronometer timer0 (
    .clock(clock),
    .advanceState(btn0),
    .incrementBtn(btn1),
    .countS(seg),
    .dp70(dp70),
    .dp71(dp71),
    .dp72(dp72),
    .dp73(dp73),
    .m1(m1),
    .m2(m2),
    .ho1(h1),
    .ho2(h2),
    .debugState(currentState),
    .dot(dot),
    .reset(reset)
);

endmodule
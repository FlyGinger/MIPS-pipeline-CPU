`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:    Zengkai Jiang
// Create Date: 2018/08/27 15:23:13
// Module Name: Seg7LED
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module Seg7LED(
    input wire clk,
    input wire rst, // reset, active high
    input wire start, // a slow clock
    input wire text, // text mode
    input wire flash, // blink, active high
    input wire [31:0] hexs, // data
    input wire [7:0] points, // point, active high
    input wire [7:0] LES, // enable, active low
    output wire segclk, // same as clk
    output wire segdt, // data
    output wire segen, // enable
    output wire segclr // clear, active low
    );


wire [63:0] hex_seg;
wire [63:0] pixel_seg;
wire [63:0] seg;


Hex2Seg M0(
    .flash(flash),
    .hexs(hexs),
    .points(points),
    .LES(LES),
    .seg(hex_seg));


PixelMap M1(
    .pixel(hexs),
    .seg(pixel_seg));


MUX2T1#(.WIDTH(64)) M2(
    .S(text),
    .I0(pixel_seg),
    .I1(hex_seg),
    .O(seg));


P2S#(.DATA_BITS(64), .DIR(0)) M3(
    .clk(clk),
    .rst(rst),
    .start(start),
    .data(seg),
    .sclk(segclk),
    .sclrn(segclr),
    .sout(segdt),
    .sen(segen));


endmodule

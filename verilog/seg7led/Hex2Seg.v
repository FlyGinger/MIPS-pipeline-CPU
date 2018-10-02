`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/27 15:50:59
// Design Name: 
// Module Name: Hex2Seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hex2Seg(
    input wire flash, // blink, active high
    input wire [7:0] LES, // enable, active low
    input wire [7:0] points, // point, active high
    input wire [31:0] hexs, // data
    output wire [63:0] seg
    );


MC14495_ZJU M0(
    .D0(hexs[0]),
    .D1(hexs[1]),
    .D2(hexs[2]),
    .D3(hexs[3]),
    .LE(LES[0] & flash),
    .point(points[0]),
    .a(seg[0]),
    .b(seg[1]),
    .c(seg[2]),
    .d(seg[3]),
    .e(seg[4]),
    .f(seg[5]),
    .g(seg[6]),
    .p(seg[7]));


MC14495_ZJU M1(
    .D0(hexs[4]),
    .D1(hexs[5]),
    .D2(hexs[6]),
    .D3(hexs[7]),
    .LE(LES[1] & flash),
    .point(points[1]),
    .a(seg[8]),
    .b(seg[9]),
    .c(seg[10]),
    .d(seg[11]),
    .e(seg[12]),
    .f(seg[13]),
    .g(seg[14]),
    .p(seg[15]));


MC14495_ZJU M2(
    .D0(hexs[8]),
    .D1(hexs[9]),
    .D2(hexs[10]),
    .D3(hexs[11]),
    .LE(LES[2] & flash),
    .point(points[2]),
    .a(seg[16]),
    .b(seg[17]),
    .c(seg[18]),
    .d(seg[19]),
    .e(seg[20]),
    .f(seg[21]),
    .g(seg[22]),
    .p(seg[23]));


MC14495_ZJU M3(
    .D0(hexs[12]),
    .D1(hexs[13]),
    .D2(hexs[14]),
    .D3(hexs[15]),
    .LE(LES[3] & flash),
    .point(points[3]),
    .a(seg[24]),
    .b(seg[25]),
    .c(seg[26]),
    .d(seg[27]),
    .e(seg[28]),
    .f(seg[29]),
    .g(seg[30]),
    .p(seg[31]));


MC14495_ZJU M4(
    .D0(hexs[16]),
    .D1(hexs[17]),
    .D2(hexs[18]),
    .D3(hexs[19]),
    .LE(LES[4] & flash),
    .point(points[4]),
    .a(seg[32]),
    .b(seg[33]),
    .c(seg[34]),
    .d(seg[35]),
    .e(seg[36]),
    .f(seg[37]),
    .g(seg[38]),
    .p(seg[39]));


MC14495_ZJU M5(
    .D0(hexs[20]),
    .D1(hexs[21]),
    .D2(hexs[22]),
    .D3(hexs[23]),
    .LE(LES[5] & flash),
    .point(points[5]),
    .a(seg[40]),
    .b(seg[41]),
    .c(seg[42]),
    .d(seg[43]),
    .e(seg[44]),
    .f(seg[45]),
    .g(seg[46]),
    .p(seg[47]));


MC14495_ZJU M6(
    .D0(hexs[24]),
    .D1(hexs[25]),
    .D2(hexs[26]),
    .D3(hexs[27]),
    .LE(LES[6] & flash),
    .point(points[6]),
    .a(seg[48]),
    .b(seg[49]),
    .c(seg[50]),
    .d(seg[51]),
    .e(seg[52]),
    .f(seg[53]),
    .g(seg[54]), 
    .p(seg[55]));


MC14495_ZJU M7(
    .D0(hexs[28]),
    .D1(hexs[29]),
    .D2(hexs[30]),
    .D3(hexs[31]),
    .LE(LES[7] & flash),
    .point(points[7]),
    .a(seg[56]),
    .b(seg[57]),
    .c(seg[58]),
    .d(seg[59]),
    .e(seg[60]),
    .f(seg[61]),
    .g(seg[62]),
    .p(seg[63]));


endmodule

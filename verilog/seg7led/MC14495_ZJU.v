`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/27 15:56:41
// Design Name: 
// Module Name: MC14495_ZJU
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


module MC14495_ZJU(
    input wire D0, // the least
    input wire D1,
    input wire D2,
    input wire D3, // the most
    input wire LE, // actvie low
    input wire point, // active high
    output reg a, // active low
    output reg b, // active low
    output reg c, // active low
    output reg d, // active low
    output reg e, // active low
    output reg f, // active low
    output reg g, // active low
    output wire p // active low
    );


assign p = ~ point;
`define segment {a, b, c, d, e, f, g}
always @ * begin
    case ({D3, D2, D1, D0})
        4'b0000: `segment <= {7{LE}} | 7'b0000001;
        4'b0001: `segment <= {7{LE}} | 7'b1001111;
        4'b0010: `segment <= {7{LE}} | 7'b0010010;
        4'b0011: `segment <= {7{LE}} | 7'b0000110;
        4'b0100: `segment <= {7{LE}} | 7'b1001100;
        4'b0101: `segment <= {7{LE}} | 7'b0100100;
        4'b0110: `segment <= {7{LE}} | 7'b0100000;
        4'b0111: `segment <= {7{LE}} | 7'b0001111;
        4'b1000: `segment <= {7{LE}} | 7'b0000000;
        4'b1001: `segment <= {7{LE}} | 7'b0000100;
        4'b1010: `segment <= {7{LE}} | 7'b0001000;
        4'b1011: `segment <= {7{LE}} | 7'b1100000;
        4'b1100: `segment <= {7{LE}} | 7'b0110001;
        4'b1101: `segment <= {7{LE}} | 7'b1000010;
        4'b1110: `segment <= {7{LE}} | 7'b0110000;
        4'b1111: `segment <= {7{LE}} | 7'b0111000;
    endcase
end


endmodule

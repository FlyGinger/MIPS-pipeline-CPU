`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Zengkai Jiang
// Create Date: 2018/08/28 23:27:10
// Module Name: MUX8T1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module MUX8T1#(
    parameter WIDTH = 32
    )(
    input wire [2:0] S,
    input wire [WIDTH-1:0] I0,
    input wire [WIDTH-1:0] I1,
    input wire [WIDTH-1:0] I2,
    input wire [WIDTH-1:0] I3,
    input wire [WIDTH-1:0] I4,
    input wire [WIDTH-1:0] I5,
    input wire [WIDTH-1:0] I6,
    input wire [WIDTH-1:0] I7,
    output reg [WIDTH-1:0] O
    );


always @ * begin
    case (S)
        3'b000: O <= I0;
        3'b001: O <= I1;
        3'b010: O <= I2;
        3'b011: O <= I3;
        3'b100: O <= I4;
        3'b101: O <= I5;
        3'b110: O <= I6;
        3'b111: O <= I7;
    endcase
end


endmodule

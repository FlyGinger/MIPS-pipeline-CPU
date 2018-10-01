`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Zengkai Jiang
// Create Date: 2018/08/27 15:46:40
// Module Name: MUX2T1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module MUX2T1#(
    parameter WIDTH = 32
    )(
    input wire S,
    input wire [WIDTH-1:0] I0,
    input wire [WIDTH-1:0] I1,
    output reg [WIDTH-1:0] O
    );

always @ * begin
    case (S)
      1'b0: O <= I0;
      1'b1: O <= I1;
    endcase
end

endmodule

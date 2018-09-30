`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/27 16:43:01
// Design Name: 
// Module Name: ClkDiv
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


module ClkDiv(
    input wire clk,
    output reg [31:0] clkdiv
    );


always @ (posedge clk) begin
    clkdiv <= clkdiv + 32'b1;
end


// if clk is 200 MHz
// 0    100 MHz
// 1    50 MHz
// 2    25 MHz
// 3    12.5 MHz
// 4    6.25 MHz
// 5    3.125 MHz
// 6    1.5625 MHz
// 7    781.25 KHz
// 8    390.625 KHz
// 9    195.312 KHz (~)
// 10   97.656 KHz (~)
// 11   48.828 KHz (~)
// 12   24.414 KHz (~)
// 13   12.207 KHz (~)
// 14   6.103 KHz (~)
// 15   3.051 KHz (~)
// 16   1.525 KHz (~)
// 17   762.939 Hz (~)
// 18   381.469 Hz (~)
// 19   190.734 Hz (~)
// 20   95.367 Hz (~)
// 21   47.683 Hz (~)
// 22   23.841 Hz (~)
// 23   11.920 Hz (~)
// 24   5.960 Hz (~)
// 25   2.980 Hz (~)
// 26   1.490 Hz (~)
// 27   0.745 Hz (~)
// 28   0.372 Hz (~)
// 29   0.186 Hz (~)
// 30   0.093 Hz (~)
// 31   0.046 Hz (~)


endmodule

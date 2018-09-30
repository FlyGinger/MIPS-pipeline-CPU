`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/27 16:04:33
// Design Name: 
// Module Name: PixelMap
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


module PixelMap(
    input wire [31:0] pixel,
    output wire [63:0] seg
    );


assign seg = {
    pixel[30], pixel[15],  pixel[11], pixel[23], pixel[31], pixel[22],  pixel[10], pixel[3],
    pixel[28], pixel[14],  pixel[9],  pixel[21], pixel[29], pixel[20],  pixel[8],  pixel[2],
    pixel[26], pixel[13],  pixel[7],  pixel[19], pixel[27], pixel[18],  pixel[6],  pixel[1],
    pixel[24], pixel[12],  pixel[5],  pixel[17], pixel[25], pixel[16],  pixel[4],  pixel[0],

    pixel[30], pixel[15],  pixel[11], pixel[23], pixel[31], pixel[22],  pixel[10], pixel[3],
    pixel[28], pixel[14],  pixel[9],  pixel[21], pixel[29], pixel[20],  pixel[8],  pixel[2],
    pixel[26], pixel[13],  pixel[7],  pixel[19], pixel[27], pixel[18],  pixel[6],  pixel[1],
    pixel[24], pixel[12],  pixel[5],  pixel[17], pixel[25], pixel[16],  pixel[4],  pixel[0]};


//        3            2            1            0
//     -------      -------      -------      -------
//   11|     |10   9|     |8    7|     |6    5|     |4
//     --15---      --14---      --13---      --12---
//   23|     |22  21|     |20  19|     |18  17|     |16
//     -------      -------      -------      -------
//       31   .       29   .       27   .       25   .
//            30           28           26           24


endmodule

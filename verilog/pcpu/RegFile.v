`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    2018/08/27 23:12:20
// Module Name:    RegFile
// Description:    register files
// Revision 0.01 - File Created 2018/08/27 23:12:20
//////////////////////////////////////////////////////////////////////////////////


module RegFile(
    input wire clk,
    input wire rst, // reset, active high
    input wire [4:0] addrA, // A port address
    input wire [4:0] addrB, // B port address
    input wire we, // write enable
    input wire [4:0] addrW, // W port address
    input wire [31:0] dataW, // W port data
    output wire [31:0] dataA, // A port data
    output wire [31:0] dataB // B port data
    );


reg [31:0] register[1:31];
integer i;
always @ (posedge clk or posedge rst)  begin
    if (rst) begin
        for (i = 1; i < 32; i = i + 1) begin
            register[i] <= 32'b0;
        end
    end
    else begin
        if (addrW != 0 && we == 1) begin
            register[addrW] <= dataW;
        end
    end
end
assign dataA = (addrA == 0) ? 32'b0 : register[addrA];
assign dataB = (addrB == 0) ? 32'b0 : register[addrB];


endmodule

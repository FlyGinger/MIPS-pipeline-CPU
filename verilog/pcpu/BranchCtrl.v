`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    23:21:17 09/29/2018 
// Module Name:    BranchCtrl 
// Description:    branch control
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module BranchCtrl(
    // clock and reset
    input wire clk, input wire rst,
    // current pc
    input wire [31:0] pc,
    // ID
    input wire [`BRANCH_WIDTH] id_branchType, input wire [31:0] id_branchDst,
    // EX
    input wire [`BRANCH_WIDTH] ex_branchType, input wire ex_branchPermit,
    // output
    output reg [31:0] pcNext, output wire id_flush
    );


wire [31:0] pcPredict;
wire id_branchJ = (id_branchType[4:3] == 2'b10);
wire id_branchB = (id_branchType[4:3] == 2'b01);
wire ex_branchB = (ex_branchType[4:3] == 2'b01);


always @ *
begin
    if (id_branchJ) // jump
        pcNext <= id_branchDst;
    else if (id_branchB | ex_branchB) // predict
        pcNext <= pcPredict;
    else // normal
        pcNext <= pc + 'h4;
end


BranchPredict BP(.clk(clk), .rst(rst),
    .pc(pc),
    .id_branchB(id_branchB), .id_branchDst(id_branchDst),
    .ex_branchB(ex_branchB), .ex_branchPermit(ex_branchPermit),
    .pcNext(pcPredict), .id_flush(id_flush));


endmodule

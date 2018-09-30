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
    // current pc
    input wire [31:0] pc,
    // ID: j type
    input wire id_branchPermit, input wire [31:0] id_branchDst,
    // EX: b type
    input wire ex_branchPermit, input wire [31:0] ex_branchDst,
    // output
    output reg [31:0] pcNext
    );


always @ *
begin
    if (id_branchPermit)
        pcNext <= id_branchDst;
    else if (ex_branchPermit)
        pcNext <= ex_branchDst;
    else
        pcNext <= pc + 'h4;
end


endmodule

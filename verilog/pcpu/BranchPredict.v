`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    17:07:45 10/03/2018 
// Module Name:    BranchPredict
// Description:    branch prediction using bimodal predictor
// Revision 0.01 - File Created 17:07:45 10/03/2018 
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module BranchPredict(
    // clock and reset
    input wire clk, input wire rst,
    // pc
    input wire [31:0] pc,
    // branch
    input wire id_branchB, input wire [31:0] id_branchDst,
    // actual
    input wire ex_branchB, input wire ex_branchPermit,
    // output
    output reg [31:0] pcNext, output wire id_flush
);


reg [1:0] counter[2047:0]; // predict history

wire [31:0] pcAdd4 = pc + 'h4;
reg [11:0] pc_hash0; // hash(pc)
reg [11:0] pc_hash1; // buffer

reg [1:0] item0; // predict item
reg [1:0] item1; // buffer
reg [1:0] itemNew; // new item

wire prediction0 = item0[1]; // prediction, 1 for branch, 0 for not branch
reg prediction1; // buffer

reg [31:0] counter_predict; // the opposite of prediction
wire wrong_predict = ex_branchB && (prediction1 ^ ex_branchPermit);
assign id_flush = wrong_predict;

integer i;
always @ (posedge clk)
begin
    if (rst)
        for (i = 0; i < 2048; i = i + 1) counter[i] <= 0;
    else if (ex_branchB)
        counter[pc_hash1] <= itemNew;
    item0 <= counter[pc[13:2]];
end


always @ (posedge clk)
begin
    if (rst)
    begin
        pc_hash0 <= 0;
        pc_hash1 <= 0;
        item1 <= 0;
        prediction1 <= 0;
        counter_predict <= 0;
    end
    else
    begin
        pc_hash0 <= pc[13:2];
        pc_hash1 <= pc_hash0;
        item1 <= item0;
        prediction1 <= prediction0;
        counter_predict <= prediction0 ? pcAdd4 : id_branchDst;
    end
end


always @ *
begin
    if (id_branchB)
        pcNext <= prediction0 ? id_branchDst : pcAdd4;
    else
        pcNext <= wrong_predict ? counter_predict : pcAdd4;
end


always @ *
begin
    case (item1)
    2'b00: if (ex_branchPermit) itemNew <= 2'b01; else itemNew <= 2'b00;
    2'b01: if (ex_branchPermit) itemNew <= 2'b10; else itemNew <= 2'b00;
    2'b10: if (ex_branchPermit) itemNew <= 2'b11; else itemNew <= 2'b01;
    2'b11: if (ex_branchPermit) itemNew <= 2'b11; else itemNew <= 2'b10;
    endcase
end


endmodule
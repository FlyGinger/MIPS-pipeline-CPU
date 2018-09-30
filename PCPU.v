`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    21:49:03 09/28/2018
// Module Name:    PCPU
// Description:    Pipelined CPU
// Revision 0.01 - File Created: 21:49:03 09/28/2018
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module PCPU(
    // clock and reset
    input wire clk, input wire rst,
    // instruction memory
    output wire [31:0] addrInst, input wire [31:0] instIn,
    // data memory
    output wire [31:0] addrData, input wire [31:0] dataIn,
    output wire memWE, output wire [31:0] dataOut
    );


// stage IF signals
reg [31:0] if_pc;
wire [31:0] pcNext;
// stage ID signals
wire [31:0] id_pc, id_inst;
wire [`ALU_OP_WIDTH] id_op;
wire [31:0] id_opa, id_opb;
wire id_memWE;
wire [31:0] id_memData;
wire [31:0] rfRs, rfRt;
wire id_rfWE;
wire [4:0] id_rfDst;
wire [`RF_SRC_WIDTH] id_rfSrc;
wire [`BRANCH_WIDTH] id_branchType;
wire [31:0] id_branchDst;
// stage EX signals
wire [31:0] ex_pc, ex_inst;
wire [31:0] ex_opResult;
wire ex_memWE;
wire [31:0] ex_memData;
wire ex_rfWE;
wire [4:0] ex_rfDst;
wire [`RF_SRC_WIDTH] ex_rfSrc;
wire ex_branchPermit;
wire [31:0] ex_branchDst;
// stage MEM signals
wire [31:0] mem_pc, mem_inst;
wire [31:0] mem_opResult;
wire [31:0] mem_memData;
wire mem_rfWE;
wire [4:0] mem_rfDst;
wire [`RF_SRC_WIDTH] mem_rfSrc;
// stage WB signals
wire [31:0] wb_rfSrcData;


// stage IF
always @ (posedge clk)
begin
    if (rst)
        if_pc <= `PC_INITIAL;
    else
        if_pc <= pcNext;
end
assign addrInst = if_pc;


// stage ID
StageID stageID(.clk(clk), .rst(rst),
    .if_pc(if_pc), .if_inst(instIn),
    .id_pc(id_pc), .id_inst(id_inst),
    .id_op(id_op), .id_opa(id_opa), .id_opb(id_opb),
    .id_memWE(id_memWE), .id_memData(id_memData),
    .rfRs(rfRs), .rfRt(rfRt), .id_rfWE(id_rfWE), .id_rfDst(id_rfDst), .id_rfSrc(id_rfSrc),
    .id_branchType(id_branchType), .id_branchDst(id_branchDst));
// Register files
RegFile RF(.clk(clk), .rst(rst),
    .addrA(id_inst[25:21]), .addrB(id_inst[20:16]),
    .dataA(rfRs), .dataB(rfRt),
    .we(mem_rfWE), .addrW(mem_rfDst), .dataW(wb_rfSrcData));
// Branch control unit
BranchCtrl BC(.pc(if_pc),
    .id_branchPermit(id_branchType[4:3] == 2'b10), .id_branchDst(id_branchDst),
    .ex_branchPermit(ex_branchPermit), .ex_branchDst(ex_branchDst),
    .pcNext(pcNext));


// stage EX
StageEX stageEX(.clk(clk), .rst(rst),
    .id_pc(id_pc), .id_inst(id_inst), .ex_pc(ex_pc), .ex_inst(ex_inst),
    .id_op(id_op), .id_opa(id_opa), .id_opb(id_opb), .ex_opResult(ex_opResult),
    .id_memWE(id_memWE), .ex_memWE(ex_memWE),
    .id_memData(id_memData), .ex_memData(ex_memData),
    .id_rfWE(id_rfWE), .id_rfDst(id_rfDst), .id_rfSrc(id_rfSrc),
    .ex_rfWE(ex_rfWE), .ex_rfDst(ex_rfDst), .ex_rfSrc(ex_rfSrc),
    .id_branchType(id_branchType), .id_branchDst(id_branchDst),
    .ex_branchPermit(ex_branchPermit), .ex_branchDst(ex_branchDst));


// stage MEM
assign addrData = mem_opResult;
assign dataOut = mem_memData;
StageMEM stageMEM(.clk(clk), .rst(rst),
    .ex_pc(ex_pc), .ex_inst(ex_inst), .mem_pc(mem_pc), .mem_inst(mem_inst),
    .ex_opResult(ex_opResult), .mem_opResult(mem_opResult),
    .ex_memWE(ex_memWE), .mem_memWE(memWE),
    .ex_memData(ex_memData), .mem_memData(mem_memData),
    .ex_rfWE(ex_rfWE), .ex_rfDst(ex_rfDst), .ex_rfSrc(ex_rfSrc),
    .mem_rfWE(mem_rfWE), .mem_rfDst(mem_rfDst), .mem_rfSrc(mem_rfSrc));


// stage WB
MUX2T1 WB(.S(mem_rfSrc),
    .I0(mem_opResult), .I1(dataIn),
    .O(wb_rfSrcData));


endmodule

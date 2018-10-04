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
    output wire memRE, output wire memWE, output wire [31:0] dataOut
    );


// stage IF signals
reg [31:0] if_pc;
wire [31:0] pcNext;
// stage ID signals
wire [31:0] id_pc, id_inst;
wire [`ALU_OP_WIDTH] id_op;
wire [31:0] id_opa, id_opb;
wire id_memWE, id_memRE;
wire [31:0] id_memData;
wire [31:0] rfRs, rfRt, rfRs_forwarding, rfRt_forwarding;
wire id_rfWE;
wire [4:0] id_rfDst;
wire [`RF_SRC_WIDTH] id_rfSrc;
wire [`BRANCH_WIDTH] id_branchType;
wire [31:0] id_branchDst;
wire id_flush;
// stage EX signals
wire [31:0] ex_inst;
wire [31:0] ex_opResult;
wire ex_memWE, ex_memRE;
wire [31:0] ex_memData;
wire ex_rfWE;
wire [4:0] ex_rfDst;
wire [`RF_SRC_WIDTH] ex_rfSrc;
wire [`BRANCH_WIDTH] ex_branchType;
wire ex_branchPermit;
// stage MEM signals
wire [31:0] mem_inst;
wire [31:0] mem_opResult;
wire [31:0] mem_memData;
wire mem_rfWE;
wire [4:0] mem_rfDst;
wire [`RF_SRC_WIDTH] mem_rfSrc;
// stage WB signals
wire [31:0] wb_rfSrcData;
// stall
wire if_stall, id_stall, ex_flush;


// stage IF
always @ (posedge clk)
begin
    if (rst)
        if_pc <= `PC_INITIAL;
    else if (!if_stall)
        if_pc <= pcNext;
end
assign addrInst = if_pc;


// stage ID
StageID stageID(.clk(clk), .rst(rst), .stall(id_stall), .id_flush(id_flush),
    .if_pc(if_pc), .if_inst(instIn),
    .id_pc(id_pc), .id_inst(id_inst),
    .id_op(id_op), .id_opa(id_opa), .id_opb(id_opb),
    .id_memRE(id_memRE), .id_memWE(id_memWE), .id_memData(id_memData),
    .rfRs(rfRs_forwarding), .rfRt(rfRt_forwarding),
    .id_rfWE(id_rfWE), .id_rfDst(id_rfDst), .id_rfSrc(id_rfSrc),
    .id_branchType(id_branchType), .id_branchDst(id_branchDst));
// forwarding
Forwarding forwarding(.ex_inst(ex_inst), .mem_inst(mem_inst),
    .id_rs(id_inst[25:21]), .id_rt(id_inst[20:16]),
    .ex_rfDst(ex_rfDst), .mem_rfDst(mem_rfDst),
    .rs(rfRs), .rt(rfRt),
    .ex_forwarding(ex_opResult), .mem_forwarding(mem_opResult),
    .if_stall(if_stall), .id_stall(id_stall), .ex_flush(ex_flush),
    .rfRs_forwarding(rfRs_forwarding), .rfRt_forwarding(rfRt_forwarding));
// Register files
RegFile RF(.clk(clk), .rst(rst),
    .addrA(id_inst[25:21]), .addrB(id_inst[20:16]),
    .dataA(rfRs), .dataB(rfRt),
    .we(mem_rfWE), .addrW(mem_rfDst), .dataW(wb_rfSrcData));
// Branch control unit
BranchCtrl BC(.clk(clk), .rst(rst),
    .pc(if_pc),
    .id_branchType(id_branchType), .id_branchDst(id_branchDst),
    .ex_branchType(ex_branchType), .ex_branchPermit(ex_branchPermit),
    .pcNext(pcNext), .id_flush(id_flush));


// stage EX
StageEX stageEX(.clk(clk), .rst(rst), .flush(ex_flush),
    .id_inst(id_inst), .ex_inst(ex_inst),
    .id_op(id_op), .id_opa(id_opa), .id_opb(id_opb), .ex_opResult(ex_opResult),
    .id_memWE(id_memWE), .ex_memWE(ex_memWE), .id_memRE(id_memRE), .ex_memRE(ex_memRE),
    .id_memData(id_memData), .ex_memData(ex_memData),
    .id_rfWE(id_rfWE), .id_rfDst(id_rfDst), .id_rfSrc(id_rfSrc),
    .ex_rfWE(ex_rfWE), .ex_rfDst(ex_rfDst), .ex_rfSrc(ex_rfSrc),
    .id_branchType(id_branchType), .ex_branchType(ex_branchType), .ex_branchPermit(ex_branchPermit));


// stage MEM
assign addrData = mem_opResult;
assign dataOut = mem_memData;
StageMEM stageMEM(.clk(clk), .rst(rst),
    .ex_inst(ex_inst), .mem_inst(mem_inst),
    .ex_opResult(ex_opResult), .mem_opResult(mem_opResult),
    .ex_memWE(ex_memWE), .mem_memWE(memWE), .ex_memRE(ex_memRE), .mem_memRE(memRE),
    .ex_memData(ex_memData), .mem_memData(mem_memData),
    .ex_rfWE(ex_rfWE), .ex_rfDst(ex_rfDst), .ex_rfSrc(ex_rfSrc),
    .mem_rfWE(mem_rfWE), .mem_rfDst(mem_rfDst), .mem_rfSrc(mem_rfSrc));


// stage WB
MUX2T1 WB(.S(mem_rfSrc[0]),
    .I0(mem_opResult), .I1(dataIn),
    .O(wb_rfSrcData));


endmodule

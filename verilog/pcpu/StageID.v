`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    19:52:27 09/29/2018 
// Module Name:    StageID 
// Description:    stage: instruction decode
// Revision 0.01 - File Created 19:52:27 09/29/2018 
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module StageID(
    // clock, reset and stall
    input wire clk, input wire rst, input wire stall,
    // pc and instruction
    input wire [31:0] if_pc, input wire [31:0] if_inst,
    output reg [31:0] id_pc, output reg [31:0] id_inst,
    // alu
    output wire [`ALU_OP_WIDTH] id_op,
    output reg [31:0] id_opa, output reg [31:0] id_opb,
    // memory
    output wire id_memWE,
    output wire [31:0] id_memData,
    // register files
    input wire [31:0] rfRs, input wire [31:0] rfRt,
    output wire id_rfWE, output reg [4:0] id_rfDst,
    output wire [`RF_SRC_WIDTH] id_rfSrc,
    // branch
    output wire [`BRANCH_WIDTH] id_branchType,
    output reg [31:0] id_branchDst
    );


// refresh pc and instruction
always @ (posedge clk)
begin
    if (rst)
    begin
        id_pc <= 0;
        id_inst <= 0;
    end
    else if (!stall)
    begin
        id_pc <= if_pc;
        id_inst <= if_inst;
    end
end


// signals for secondary decoding
wire [`ALU_OPA_WIDTH] aluSrcA;
wire [`ALU_OPB_WIDTH] aluSrcB;
wire [`RF_DST_WIDTH] rfDst;

// instruction decoder
InstDecoder ID(.inst(id_inst),
    .aluOp(id_op), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB),
    .rfWE(id_rfWE), .rfDst(rfDst), .rfSrc(id_rfSrc),
    .memWE(id_memWE),
    .branch(id_branchType));
assign id_memData = rfRt;


// secondary decoding
wire [31:0] pcAdd4 = id_pc + 'h4;
always @ *
begin
    case(aluSrcA)
    'h0: id_opa <= rfRs; // RS
    'h1: id_opa <= {27'h0, id_inst[10:6]}; // SA
    default: id_opa <= 0;
    endcase

    case(aluSrcB)
    'h0: id_opb <= rfRt; // RT
    'h1: id_opb <= {{16{id_inst[15]}}, id_inst[15:0]}; // signed immediate
    'h2: id_opb <= {16'h0, id_inst[15:0]}; // unsigned immediate
    default: id_opb <= 0;
    endcase

    case(rfDst)
    'h0: id_rfDst <= id_inst[15:11]; // RD
    'h1: id_rfDst <= id_inst[20:16]; // RT
    'h2: id_rfDst <= 5'b0; // ZERO
    default: id_rfDst <= 5'b0;
    endcase

    case(id_branchType[4:3])
    2'b00: id_branchDst <= pcAdd4;
    2'b01: id_branchDst <= pcAdd4 + {{14{id_inst[15]}}, id_inst[15:0], 2'b0};
    2'b10: id_branchDst <= {id_pc[31:28], id_inst[25:0], 2'b0};
    default: id_branchDst <= pcAdd4;
    endcase
end


endmodule

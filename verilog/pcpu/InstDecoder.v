`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    20:27:08 09/29/2018 
// Module Name:    InstDecoder 
// Description:    convert instruction to control signals
// Revision 0.01 - File Created 20:27:08 09/29/2018 
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module InstDecoder(
    // input instruction
    input wire [31:0] inst,
    // alu
    output reg [`ALU_OP_WIDTH] aluOp,
    output reg [`ALU_OPA_WIDTH] aluSrcA,
    output reg [`ALU_OPB_WIDTH] aluSrcB,
    // register files
    output reg rfWE,
    output reg [`RF_DST_WIDTH] rfDst,
    output reg [`RF_SRC_WIDTH] rfSrc,
    // memory
    output reg memWE, output reg memRE,
    // branch
    output reg [`BRANCH_WIDTH] branch
    );


`define SIGNALS {aluOp, aluSrcA, aluSrcB, rfWE, rfDst, rfSrc, memWE, memRE, branch}
always @ *
begin
    case(inst[31:26])
    6'b000000:  case(inst[5:0])
                6'b000000: `SIGNALS <= {`ALU_OP_SLL, `ALU_OPA_SA, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sll
                6'b000010: `SIGNALS <= {`ALU_OP_SRL, `ALU_OPA_SA, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // srl
                6'b000011: `SIGNALS <= {`ALU_OP_SRA, `ALU_OPA_SA, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sra
                6'b000100: `SIGNALS <= {`ALU_OP_SLL, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sllv
                6'b000110: `SIGNALS <= {`ALU_OP_SRL, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // srlv
                6'b000111: `SIGNALS <= {`ALU_OP_SRA, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // srav
                6'b001000: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_DISABLE, `BRANCH_JR}; // jr
                6'b001001: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_PC, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_JR}; // jalr
                6'b001010: `SIGNALS <= {`ALU_OP_OPA, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_MOVZ, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // movz
                6'b001011: `SIGNALS <= {`ALU_OP_OPA, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_MOVN, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // movn
                6'b100000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // add
                6'b100001: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // addu
                6'b100010: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sub
                6'b100011: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // subu
                6'b100100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // and
                6'b100101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // or
                6'b100110: `SIGNALS <= {`ALU_OP_XOR, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // xor
                6'b100111: `SIGNALS <= {`ALU_OP_NOR, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // nor
                6'b101010: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // slt
                6'b101011: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sltu
                default: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_DISABLE, `BRANCH_DISABLE};
                endcase
    6'b000001:  case(inst[20:16])
                5'b00000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RS, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BLTZ}; // bltz
                5'b00001: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RS, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BGEZ}; // bgez
                5'b10000: `SIGNALS <= {`ALU_OP_OPA, `ALU_OPA_PC, `ALU_OPB_RS, `RF_WE_TRUE, `RF_DST_RA, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_BLTZ}; // bltzal
                5'b10001: `SIGNALS <= {`ALU_OP_OPA, `ALU_OPA_PC, `ALU_OPB_RS, `RF_WE_TRUE, `RF_DST_RA, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_BGEZ}; // bgezal
                default: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_DISABLE, `BRANCH_DISABLE};
                endcase
    6'b000010: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_DISABLE, `BRANCH_J}; // j
    6'b000011: `SIGNALS <= {`ALU_OP_OPA, `ALU_OPA_PC, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RA, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_J}; // jal
    6'b000100: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BEQ}; // beq
    6'b000101: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BNE}; // bne
    6'b000110: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RS, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BLEZ}; // blez
    6'b000111: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RS, `RF_DISABLE, `MEM_DISABLE, `BRANCH_BGTZ}; // bgtz
    6'b001000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // addi
    6'b001001: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // addiu
    6'b001010: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // slti
    6'b001011: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // sltiu
    6'b001100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // andi
    6'b001101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // ori
    6'b001110: `SIGNALS <= {`ALU_OP_XOR, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // xori
    6'b001111: `SIGNALS <= {`ALU_OP_AUI, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_DISABLE, `BRANCH_DISABLE}; // aui (lui)
    6'b100011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_MEM, `MEM_WE_FALSE, `MEM_RE_TRUE, `BRANCH_DISABLE}; // lw
    6'b101011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_DISABLE, `MEM_WE_TRUE, `MEM_RE_FALSE, `BRANCH_DISABLE}; // sw
    default: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_DISABLE, `BRANCH_DISABLE};
    endcase
end


endmodule

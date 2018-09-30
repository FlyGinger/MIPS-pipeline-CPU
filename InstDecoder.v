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
    output reg memWE,
    // branch
    output reg [`BRANCH_WIDTH] branch
    );


`define SIGNALS {aluOp, aluSrcA, aluSrcB, rfWE, rfDst, rfSrc, memWE, branch}
always @ *
begin
    case(inst[31:26])
    6'b000000:  case(inst[5:0])
                6'b000000: `SIGNALS <= {`ALU_OP_SLL, `ALU_OPA_SA, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // sll
                6'b000010: `SIGNALS <= {`ALU_OP_SRL, `ALU_OPA_SA, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // srl
                6'b100000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // add
                6'b100010: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // sub
                6'b100100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // and
                6'b100101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_RT, `RF_WE_TRUE, `RF_DST_RD, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // or
                default: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_WE_FALSE, `BRANCH_DISABLE};
                endcase
    6'b000010: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_WE_FALSE, `BRANCH_J}; // J
    6'b000100: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_DISABLE, `MEM_WE_FALSE, `BRANCH_BEQ}; // beq
    6'b000101: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `RF_DISABLE, `MEM_WE_FALSE, `BRANCH_BNE}; // bne
    6'b001000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // addi
    6'b001100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // andi
    6'b001101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_IMMU, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_ALU, `MEM_WE_FALSE, `BRANCH_DISABLE}; // ori
    6'b100011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_WE_TRUE, `RF_DST_RT, `RF_SRC_MEM, `MEM_WE_FALSE, `BRANCH_DISABLE}; // lw
    6'b101011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `RF_DISABLE, `MEM_WE_TRUE, `BRANCH_DISABLE}; // sw
    default: `SIGNALS <= {`ALU_DISABLE, `RF_DISABLE, `MEM_WE_FALSE, `BRANCH_DISABLE};
    endcase
end


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    19:50:23 09/29/2018 
// Description:    parameters in PCPU
// Revision 0.01 - File Created 19:50:23 09/29/2018 
//////////////////////////////////////////////////////////////////////////////////


// PC
`define PC_INITIAL 32'h00000000


// ALU
`define ALU_DISABLE {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RT}

`define ALU_OP_WIDTH 3:0
`define ALU_OP_ADD 4'h0
`define ALU_OP_SUB 4'h1
`define ALU_OP_AND 4'h2
`define ALU_OP_OR 4'h3
`define ALU_OP_SLL 4'h4
`define ALU_OP_SRL 4'h5

`define ALU_OPA_WIDTH 1:0
`define ALU_OPA_RS 2'h0
`define ALU_OPA_SA 2'h1

`define ALU_OPB_WIDTH 1:0
`define ALU_OPB_RT 2'h0
`define ALU_OPB_IMMS 2'h1
`define ALU_OPB_IMMU 2'h2


// Register Files
`define RF_DISABLE {`RF_WE_FALSE, `RF_DST_RD, `RF_SRC_ALU}

`define RF_WE_TRUE 1'b1
`define RF_WE_FALSE 1'b0

`define RF_DST_WIDTH 1:0
`define RF_DST_RD 2'h0
`define RF_DST_RT 2'h1

`define RF_SRC_WIDTH 1:0
`define RF_SRC_ALU 2'h0
`define RF_SRC_MEM 2'h1


// memory
`define MEM_WE_TRUE 1'b1
`define MEM_WE_FALSE 1'b0


// branch
`define BRANCH_WIDTH 4:0
`define BRANCH_DISABLE  5'b00_000
`define BRANCH_BEQ      5'b01_001
`define BRANCH_BNE      5'b01_010
`define BRANCH_J        5'b10_000

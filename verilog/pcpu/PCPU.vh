/**
 * 5-stage Pipeline CPU Macro
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


// explain of prefix and suffix
// _re: read enable
// _sel: select
// _we: write enable


// boolean
`define TRUE 1'b1
`define FALSE 1'b0


// ALU
`define ALU_DISABLE {`ALU_OP_SLL, `ALU_OPA_RS, `ALU_OPB_RT}

`define ALU_OP_WIDTH 3:0
`define ALU_OP_SLL 4'd0
`define ALU_OP_SRL 4'd1
`define ALU_OP_SRA 4'd2
`define ALU_OP_OPB 4'd3
`define ALU_OP_ADD 4'd4
`define ALU_OP_SUB 4'd5
`define ALU_OP_AND 4'd6
`define ALU_OP_OR 4'd7
`define ALU_OP_XOR 4'd8
`define ALU_OP_NOR 4'd9
`define ALU_OP_SLT 4'd10
`define ALU_OP_AUI 4'd11

`define ALU_OPA_WIDTH 0:0
`define ALU_OPA_RS 1'd0
`define ALU_OPA_SA 1'd1

`define ALU_OPB_WIDTH 2:0
`define ALU_OPB_RT 3'd0
`define ALU_OPB_PC 3'd1
`define ALU_OPB_RS 3'd2
`define ALU_OPB_IMMS 3'd3
`define ALU_OPB_IMMU 3'd4


// register file
`define RF_DISABLE {`FALSE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU}

`define RF_DST_WIDTH 2:0
`define RF_DST_ZERO 3'd0
`define RF_DST_RD 3'd1
`define RF_DST_RA 3'd2
`define RF_DST_RT 3'd3
`define RF_DST_MOVZ 3'd4
`define RF_DST_MOVN 3'd5

`define RF_SRC_WIDTH 0:0
`define RF_SRC_ALU 1'd0
`define RF_SRC_MEM 1'd1


// memory
`define MEM_DISABLE {`FALSE, `FALSE}


// branch
`define BRANCH_WIDTH 4:0
`define BRANCH_DISABLE 5'b00_000
`define BRANCH_BLTZ 5'b01_001
`define BRANCH_BGEZ 5'b01_010
`define BRANCH_BEQ 5'b01_011
`define BRANCH_BNE 5'b01_100
`define BRANCH_BLEZ 5'b01_101
`define BRANCH_BGTZ 5'b01_110
`define BRANCH_JR 5'b10_000
`define BRANCH_J 5'b11_000

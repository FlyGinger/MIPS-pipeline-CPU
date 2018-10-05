/**
 * Instruction Decoder
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


`include "PCPU.vh"
module InstDec(
    // instruction
    input [31:0] id_pc, input [31:0] id_inst,
    // alu
    output reg [`ALU_OP_WIDTH] id_alu_op, output reg [31:0] id_alu_opa, output reg [31:0] id_alu_opb,
    // memory
    output reg id_mem_re, output reg id_mem_we,
    // register
    output reg id_rf_rea, input [31:0] rf_dataa, output reg id_rf_reb, input [31:0] rf_datab,
    output reg id_rf_we, output reg [4:0] id_rf_dst, output reg [`RF_SRC_WIDTH] id_rf_src,
    // branch
    output reg [`BRANCH_WIDTH] id_branch_type, output reg [31:0] id_branch_dst
    );


    // registers
    reg [`ALU_OPA_WIDTH] alu_opa;
    reg [`ALU_OPB_WIDTH] alu_opb;
    reg [`RF_DST_WIDTH] rf_dst;


    // primary decode
    `define SIGNALS {id_alu_op, alu_opa, alu_opb, id_mem_re, id_mem_we, id_rf_rea, id_rf_reb, id_rf_we, rf_dst, id_rf_src, id_branch_type}
    always @ * begin
        case (id_inst[31:26])
            6'b000000:  case (id_inst[5:0])
                        6'b000000: `SIGNALS <= {`ALU_OP_SLL, `ALU_OPA_SA, `ALU_OPB_RT, `MEM_DISABLE, `FALSE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // sll
                        6'b000010: `SIGNALS <= {`ALU_OP_SRL, `ALU_OPA_SA, `ALU_OPB_RT, `MEM_DISABLE, `FALSE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // srl
                        6'b000011: `SIGNALS <= {`ALU_OP_SRA, `ALU_OPA_SA, `ALU_OPB_RT, `MEM_DISABLE, `FALSE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // sra
                        6'b000100: `SIGNALS <= {`ALU_OP_SLL, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // sllv
                        6'b000110: `SIGNALS <= {`ALU_OP_SRL, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // srlv
                        6'b000111: `SIGNALS <= {`ALU_OP_SRA, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // srav
                        6'b001000: `SIGNALS <= {`ALU_DISABLE, `MEM_DISABLE, `TRUE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_JR}; // jr
                        6'b001001: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_PC, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_JR}; // jalr
                        6'b001010: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_MOVZ, `RF_SRC_ALU, `BRANCH_DISABLE}; // movz
                        6'b001011: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_MOVN, `RF_SRC_ALU, `BRANCH_DISABLE}; // movn
                        6'b100000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // add
                        6'b100010: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // sub
                        6'b100100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // and
                        6'b100101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // or
                        6'b100110: `SIGNALS <= {`ALU_OP_XOR, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // xor
                        6'b100111: `SIGNALS <= {`ALU_OP_NOR, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // nor
                        6'b101010: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `TRUE, `RF_DST_RD, `RF_SRC_ALU, `BRANCH_DISABLE}; // slt
                        default: `SIGNALS <= {`ALU_DISABLE, `MEM_DISABLE, `RF_DISABLE, `BRANCH_DISABLE};
                        endcase
            6'b000001:  case (id_inst[20:16])
                        5'b00000: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BLTZ}; // bltz
                        5'b00001: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BGEZ}; // bgez
                        5'b10000: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_PC, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RA, `RF_SRC_ALU, `BRANCH_BLTZ}; // bltzal
                        5'b10001: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_PC, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RA, `RF_SRC_ALU, `BRANCH_BGEZ}; // bgezal
                        default: `SIGNALS <= {`ALU_DISABLE, `MEM_DISABLE, `RF_DISABLE, `BRANCH_DISABLE};
                        endcase
            6'b000010: `SIGNALS <= {`ALU_DISABLE, `MEM_DISABLE, `RF_DISABLE, `BRANCH_J}; // j
            6'b000011: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_PC, `MEM_DISABLE, `FALSE, `FALSE, `TRUE, `RF_DST_RA, `RF_SRC_ALU, `BRANCH_J}; // jal
            6'b000100: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BEQ}; // beq
            6'b000101: `SIGNALS <= {`ALU_OP_SUB, `ALU_OPA_RS, `ALU_OPB_RT, `MEM_DISABLE, `TRUE, `TRUE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BNE}; // bne
            6'b000110: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BLEZ}; // blez
            6'b000111: `SIGNALS <= {`ALU_OP_OPB, `ALU_OPA_RS, `ALU_OPB_RS, `MEM_DISABLE, `TRUE, `FALSE, `FALSE, `RF_DST_ZERO, `RF_SRC_ALU, `BRANCH_BGTZ}; // bgtz
            6'b001000: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // addi
            6'b001010: `SIGNALS <= {`ALU_OP_SLT, `ALU_OPA_RS, `ALU_OPB_IMMS, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // slti
            6'b001100: `SIGNALS <= {`ALU_OP_AND, `ALU_OPA_RS, `ALU_OPB_IMMU, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // andi
            6'b001101: `SIGNALS <= {`ALU_OP_OR, `ALU_OPA_RS, `ALU_OPB_IMMU, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // ori
            6'b001110: `SIGNALS <= {`ALU_OP_XOR, `ALU_OPA_RS, `ALU_OPB_IMMU, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // xori
            6'b001111: `SIGNALS <= {`ALU_OP_AUI, `ALU_OPA_RS, `ALU_OPB_IMMU, `MEM_DISABLE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_ALU, `BRANCH_DISABLE}; // aui (lui)
            6'b100011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `TRUE, `FALSE, `TRUE, `FALSE, `TRUE, `RF_DST_RT, `RF_SRC_MEM, `BRANCH_DISABLE}; // lw
            6'b101011: `SIGNALS <= {`ALU_OP_ADD, `ALU_OPA_RS, `ALU_OPB_IMMS, `FALSE, `TRUE, `TRUE, `TRUE, `FALSE, `RF_DST_ZERO, `RF_SRC_MEM, `BRANCH_DISABLE}; // sw
            default: `SIGNALS <= {`ALU_DISABLE, `MEM_DISABLE, `RF_DISABLE, `BRANCH_DISABLE};
        endcase
    end


    // secondary decode
    wire [31:0] id_pc_add_4 = id_pc + 32'h4;
    always @ * begin
        case (alu_opa)
        'd0: id_alu_opa <= rf_dataa;
        'd1: id_alu_opa <= {27'b0, id_inst[10:6]};
        default: id_alu_opa <= 32'b0;
        endcase

        case (alu_opb)
        'd0: id_alu_opb <= rf_datab;
        'd1: id_alu_opb <= id_pc_add_4;
        'd2: id_alu_opb <= rf_dataa;
        'd3: id_alu_opb <= {{16{id_inst[15]}}, id_inst[15:0]};
        'd4: id_alu_opb <= {16'b0, id_inst[15:0]};
        default: id_alu_opb <= 32'b0;
        endcase

        case (rf_dst)
        'd0: id_rf_dst <= 5'b0;
        'd1: id_rf_dst <= id_inst[15:11];
        'd2: id_rf_dst <= 5'd31;
        'd3: id_rf_dst <= id_inst[20:16];
        'd4: id_rf_dst <= (rf_datab == 0) ? id_inst[15:11] : 5'b0;
        'd5: id_rf_dst <= (rf_datab == 0) ? 5'b0 : id_inst[15:11];
        default: id_rf_dst <= 5'b0;
        endcase

        case (id_branch_type[4:3])
        2'b00: id_branch_dst <= id_pc_add_4;
        2'b01: id_branch_dst <= id_pc_add_4 + {{14{id_inst[15]}}, id_inst[15:0], 2'b0};
        2'b10: id_branch_dst <= rf_dataa;
        2'b11: id_branch_dst <= {id_pc[31:28], id_inst[25:0], 2'b0};
        endcase
    end


endmodule

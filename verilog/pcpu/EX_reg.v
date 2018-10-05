/**
 * Registers of Execute Stage
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


`include "PCPU.vh"
module EX_reg(
    // clock and reset
    input clk, input rst, input stall, input flush,
    // instruction
    input [31:0] id_inst, output reg [31:0] ex_inst,
    // alu
    input [`ALU_OP_WIDTH] id_alu_op, input [31:0] id_alu_opa, input [31:0] id_alu_opb,
    output reg [`ALU_OP_WIDTH] ex_alu_op, output reg [31:0] ex_alu_opa, output reg [31:0] ex_alu_opb,
    // memory
    input id_mem_re, input id_mem_we, output reg ex_mem_re, output reg ex_mem_we,
    input [31:0] id_mem_data, output reg [31:0] ex_mem_data,
    // register file
    input id_rf_we, input [4:0] id_rf_dst, input [`RF_SRC_WIDTH] id_rf_src,
    output reg ex_rf_we, output reg [4:0] ex_rf_dst, output reg [`RF_SRC_WIDTH] ex_rf_src,
    // branch
    input [`BRANCH_WIDTH] id_branch_type, output reg [`BRANCH_WIDTH] ex_branch_type
    );


    always @ (posedge clk) begin
        if (rst | flush) begin
            ex_inst <= 0;
            ex_alu_op <= 0;
            ex_alu_opa <= 0;
            ex_alu_opb <= 0;
            ex_mem_re <= 0;
            ex_mem_we <= 0;
            ex_mem_data <= 0;
            ex_rf_we <= 0;
            ex_rf_dst <= 0;
            ex_rf_src <= 0;
            ex_branch_type <= 0;
        end
        else if (~stall) begin
            ex_inst <= id_inst;
            ex_alu_op <= id_alu_op;
            ex_alu_opa <= id_alu_opa;
            ex_alu_opb <= id_alu_opb;
            ex_mem_re <= id_mem_re;
            ex_mem_we <= id_mem_we;
            ex_mem_data <= id_mem_data;
            ex_rf_we <= id_rf_we;
            ex_rf_dst <= id_rf_dst;
            ex_rf_src <= id_rf_src;
            ex_branch_type <= id_branch_type;
        end
    end


endmodule

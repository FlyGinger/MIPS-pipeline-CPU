/**
 * 5-stage Pipeline CPU
 * support dynamic prediction and data pata forwarding
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


`include "PCPU.vh"
module PCPU(
    // clock and reset
    input clk, input rst, input cache_stall,
    // instruction
    output inst_re, output [31:0] inst_addr, input [31:0] inst_in, 
    // data
    output data_re, output [31:0] data_addr, input [31:0] data_in,
    output data_we, output [31:0] data_out
    );


    // signals
    // +-- if stage signals
    wire if_stall;
    wire [31:0] if_pc;
    // +-- id stage signals
    wire id_stall;
    wire [31:0] id_pc;
    wire [31:0] id_inst;
    wire id_rf_rea;
    wire [4:0] id_rf_raddra;
    wire [31:0] id_rf_rdataa;
    wire id_rf_reb;
    wire [4:0] id_rf_raddrb;
    wire [31:0] id_rf_rdatab;
    wire [`ALU_OP_WIDTH] id_alu_op;
    wire [31:0] id_alu_opa;
    wire [31:0] id_alu_opb;
    wire id_mem_re;
    wire id_mem_we;
    wire id_rf_we;
    wire [4:0] id_rf_dst;
    wire [`RF_SRC_WIDTH] id_rf_src;
    wire [`BRANCH_WIDTH] id_branch_type;
    wire [31:0] id_branch_dst;
    wire [31:0] rs_f;
    wire [31:0] rt_f;
    wire [31:0] pc_next;
    wire id_flush;
    // +-- ex stage signals
    wire ex_flush;
    wire [31:0] ex_inst;
    wire [`ALU_OP_WIDTH] ex_alu_op;
    wire [31:0] ex_alu_opa;
    wire [31:0] ex_alu_opb;
    wire ex_mem_re;
    wire ex_mem_we;
    wire ex_rf_we;
    wire [4:0] ex_rf_dst;
    wire [`RF_SRC_WIDTH] ex_rf_src;
    wire [`BRANCH_WIDTH] ex_branch_type;
    wire [31:0] ex_alu_result;
    wire ex_alu_zero;
    wire [31:0] ex_mem_data;
    wire ex_branch_permit;
    // +-- mem stage signals
    wire [31:0] mem_alu_result;
    wire mem_rf_we;
    wire [4:0] mem_rf_dst;
    wire [`RF_SRC_WIDTH] mem_rf_src;
    // +-- wb stage signals
    wire wb_rf_we;
    wire [4:0] wb_rf_addr;
    wire [31:0] wb_rf_data;


    // if stage
    IF_reg if_reg(.clk(clk), .rst(rst), .stall(if_stall | cache_stall),
        .pc_next(pc_next), .pc(if_pc), .re(inst_re));
    assign inst_addr = if_pc;
    

    // id stage
    ID_reg id_reg(.clk(clk), .rst(rst), .stall(id_stall | cache_stall), .flush(id_flush),
        .if_pc(if_pc), .if_inst(inst_in), .id_pc(id_pc), .id_inst(id_inst));
    RegFile regfile(.clk(clk), .rst(rst),
        .we(wb_rf_we), .waddr(wb_rf_addr), .wdata(wb_rf_data),
        .rea(id_rf_rea), .raddra(id_inst[25:21]), .rdataa(id_rf_rdataa),
        .reb(id_rf_reb), .raddrb(id_inst[20:16]), .rdatab(id_rf_rdatab));
    InstDec instdec(.id_pc(id_pc), .id_inst(id_inst),
        .id_alu_op(id_alu_op), .id_alu_opa(id_alu_opa), .id_alu_opb(id_alu_opb),
        .id_mem_re(id_mem_re), .id_mem_we(id_mem_we),
        .id_rf_rea(id_rf_rea), .rf_dataa(rs_f), .id_rf_reb(id_rf_reb), .rf_datab(rt_f),
        .id_rf_we(id_rf_we), .id_rf_dst(id_rf_dst), .id_rf_src(id_rf_src),
        .id_branch_type(id_branch_type), .id_branch_dst(id_branch_dst));
    Forward forward(.id_rs(id_inst[25:21]), .id_rt(id_inst[20:16]), .id_rea(id_rf_rea), .id_reb(id_rf_reb),
        .ex_lw(ex_mem_re), .mem_lw(data_re),
        .ex_rf_dst(ex_rf_dst), .mem_rf_dst(mem_rf_dst),
        .rs_raw(id_rf_rdataa), .rt_raw(id_rf_rdatab),
        .data_ex(ex_alu_result), .data_mem(mem_alu_result),
        .if_stall(if_stall), .id_stall(id_stall), .ex_flush(ex_flush),
        .rs_f(rs_f), .rt_f(rt_f));
    BranchPredict branchpredict(.clk(clk), .rst(rst), .pc(if_pc),
        .id_branch_type(id_branch_type), .id_branch_dst(id_branch_dst),
        .ex_branch_type(ex_branch_type), .ex_branch_permit(ex_branch_permit),
        .pc_next(pc_next), .id_flush(id_flush));
    

    // ex stage
    EX_reg ex_reg(.clk(clk), .rst(rst), .stall(cache_stall), .flush(ex_flush),
        .id_inst(id_inst), .ex_inst(ex_inst),
        .id_alu_op(id_alu_op), .id_alu_opa(id_alu_opa), .id_alu_opb(id_alu_opb),
        .ex_alu_op(ex_alu_op), .ex_alu_opa(ex_alu_opa), .ex_alu_opb(ex_alu_opb),
        .id_mem_re(id_mem_re), .id_mem_we(id_mem_we), .ex_mem_re(ex_mem_re), .ex_mem_we(ex_mem_we),
        .id_mem_data(rt_f), .ex_mem_data(ex_mem_data),
        .id_rf_we(id_rf_we), .id_rf_dst(id_rf_dst), .id_rf_src(id_rf_src),
        .ex_rf_we(ex_rf_we), .ex_rf_dst(ex_rf_dst), .ex_rf_src(ex_rf_src),
        .id_branch_type(id_branch_type), .ex_branch_type(ex_branch_type));
    ALU alu(.op(ex_alu_op), .a(ex_alu_opa), .b(ex_alu_opb), .result(ex_alu_result), .zero(ex_alu_zero));
    BranchCtrl branchctrl(.branch_type(ex_branch_type), .zero(ex_alu_zero), .rs(ex_alu_opa), .branch_permit(ex_branch_permit));


    // mem stage
    assign data_addr = mem_alu_result;
    MEM_reg mem_reg(.clk(clk), .rst(rst), .stall(cache_stall),
        .ex_alu_result(ex_alu_result), .mem_alu_result(mem_alu_result),
        .ex_mem_re(ex_mem_re), .ex_mem_we(ex_mem_we), .mem_mem_re(data_re), .mem_mem_we(data_we),
        .ex_mem_data(ex_mem_data), .mem_mem_data(data_out),
        .ex_rf_we(ex_rf_we), .ex_rf_dst(ex_rf_dst), .ex_rf_src(ex_rf_src),
        .mem_rf_we(mem_rf_we), .mem_rf_dst(mem_rf_dst), .mem_rf_src(mem_rf_src));
    

    // wb stage
    MUX2T1 wb_mux(.s(mem_rf_src),
        .i0(mem_alu_result), .i1(data_in),
        .o(wb_rf_data));
    assign wb_rf_addr = mem_rf_dst;
    assign wb_rf_we = mem_rf_we;


endmodule

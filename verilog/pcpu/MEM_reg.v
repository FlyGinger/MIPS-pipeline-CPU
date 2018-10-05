/**
 * Registers of Memory Stage
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


`include "PCPU.vh"
module MEM_reg(
    // clock and reset
    input clk, input rst, input stall,
    // alu
    input [31:0] ex_alu_result, output reg [31:0] mem_alu_result,
    // memory
    input ex_mem_re, input ex_mem_we, output reg mem_mem_re, output reg mem_mem_we,
    input [31:0] ex_mem_data, output reg [31:0] mem_mem_data,
    // register file
    input ex_rf_we, input [4:0] ex_rf_dst, input [`RF_SRC_WIDTH] ex_rf_src,
    output reg mem_rf_we, output reg [4:0] mem_rf_dst, output reg [`RF_SRC_WIDTH] mem_rf_src
    );


    always @ (posedge clk) begin
        if (rst) begin
            mem_alu_result <= 0;
            mem_mem_re <= 0;
            mem_mem_we <= 0;
            mem_mem_data <= 0;
            mem_rf_we <= 0;
            mem_rf_dst <= 0;
            mem_rf_src <= 0;
        end
        else if (~stall) begin
            mem_alu_result <= ex_alu_result;
            mem_mem_re <= ex_mem_re;
            mem_mem_we <= ex_mem_we;
            mem_mem_data <= ex_mem_data;
            mem_rf_we <= ex_rf_we;
            mem_rf_dst <= ex_rf_dst;
            mem_rf_src <= ex_rf_src;
        end
    end


endmodule

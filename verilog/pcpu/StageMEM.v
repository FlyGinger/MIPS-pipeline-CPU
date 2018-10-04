`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    11:07:41 09/30/2018 
// Module Name:    StageMEM 
// Description:    stage: memory access
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module StageMEM(
    // clock and reset
    input wire clk, input wire rst,
    // instruction
    input wire [31:0] ex_inst, output reg [31:0] mem_inst,
    // alu result
    input wire [31:0] ex_opResult, output reg [31:0] mem_opResult,
    input wire [31:0] ex_memData, output reg [31:0] mem_memData,
    // memory
    input wire ex_memWE, output reg mem_memWE,
    input wire ex_memRE, output reg mem_memRE,
    // register files: pass
    input wire ex_rfWE, input wire [4:0] ex_rfDst, input wire [`RF_SRC_WIDTH] ex_rfSrc,
    output reg mem_rfWE, output reg [4:0] mem_rfDst, output reg  [`RF_SRC_WIDTH] mem_rfSrc
    );


always @ (posedge clk)
begin
    if (rst)
    begin
        mem_inst <= 0;
        mem_opResult <= 0;
        mem_memWE <= 0;
        mem_memRE <= 0;
        mem_memData <= 0;
        mem_rfWE <= 0;
        mem_rfDst <= 0;
        mem_rfSrc <= 0;
    end
    else
    begin
        mem_inst <= ex_inst;
        mem_opResult <= ex_opResult;
        mem_memWE <= ex_memWE;
        mem_memRE <= ex_memRE;
        mem_memData <= ex_memData;
        mem_rfWE <= ex_rfWE;
        mem_rfDst <= ex_rfDst;
        mem_rfSrc <= ex_rfSrc;
    end
end


endmodule

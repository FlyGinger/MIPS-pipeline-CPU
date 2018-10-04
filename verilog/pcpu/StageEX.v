`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    10:24:21 09/30/2018 
// Module Name:    StageEX 
// Description:    stage: execute
// Revision 0.01 - File Created 10:24:21 09/30/2018
//////////////////////////////////////////////////////////////////////////////////

`include "PCPUParam.vh"

module StageEX(
    // clock, reset and flush
    input wire clk, input wire rst, input wire flush,
    // instruction
    input wire [31:0] id_inst, output reg [31:0] ex_inst,
    // alu
    input wire [`ALU_OP_WIDTH] id_op,
    input wire [31:0] id_opa, input wire [31:0] id_opb,
    output reg [31:0] ex_opResult,
    // memory
    input wire id_memWE, output reg ex_memWE,
    input wire id_memRE, output reg ex_memRE,
    input wire [31:0] id_memData, output reg [31:0] ex_memData,
    // register files: pass
    input wire id_rfWE, input wire [4:0] id_rfDst, input wire [`RF_SRC_WIDTH] id_rfSrc,
    output reg ex_rfWE, output reg [4:0] ex_rfDst, output reg [`RF_SRC_WIDTH] ex_rfSrc,
    // branch
    input wire [`BRANCH_WIDTH] id_branchType,
    output reg [`BRANCH_WIDTH] ex_branchType, output reg ex_branchPermit
    );


reg [`ALU_OP_WIDTH] ex_op;
reg [31:0] ex_opa, ex_opb;
always @ (posedge clk)
begin
    if (rst | flush)
    begin
        ex_inst <= 0;
        ex_op <= 0;
        ex_opa <= 0;
        ex_opb <= 0;
        ex_memWE <= 0;
        ex_memRE <= 0;
        ex_memData <= 0;
        ex_rfWE <= 0;
        ex_rfDst <= 0;
        ex_rfSrc <= 0;
        ex_branchType <= 0;
    end
    else
    begin
        ex_inst <= id_inst;
        ex_op <= id_op;
        ex_opa <= id_opa;
        ex_opb <= id_opb;
        ex_memWE <= id_memWE;
        ex_memRE <= id_memRE;
        ex_memData <= id_memData;
        ex_rfWE <= id_rfWE;
        ex_rfDst <= id_rfDst;
        ex_rfSrc <= id_rfSrc;
        ex_branchType <= id_branchType;
    end
end


// alu
always @ *
begin
    case(ex_op)
    'h0: ex_opResult <= $signed(ex_opa) + $signed(ex_opb); // add
    'h1: ex_opResult <= $signed(ex_opa) - $signed(ex_opb); // sub
    'h2: ex_opResult <= ex_opa & ex_opb; // and
    'h3: ex_opResult <= ex_opa | ex_opb; // or
    'h4: ex_opResult <= ex_opb << ex_opa; // sll
    'h5: ex_opResult <= ex_opb >> ex_opa; // srl
    'h6: ex_opResult <= $signed(ex_opb) >>> ex_opa; // sra
    'h7: ex_opResult <= ex_opa; // opa
    'h8: ex_opResult <= ex_opa ^ ex_opb; // xor
    'h9: ex_opResult <= ~ (ex_opa | ex_opb); // nor
    'ha: ex_opResult <= $signed(ex_opa) < $signed(ex_opb) ? 32'h1 : 32'h0; // slt
    'hb: ex_opResult <= $signed(ex_opa) + $signed({ex_opb[15:0], 16'b0}); // aui
    default: ex_opResult <= 0;
    endcase
end


// branch
wire zero = ~(|ex_opResult);
always @ *
begin
    case(ex_branchType[2:0])
    'b000: ex_branchPermit <= 0;
    'b001: ex_branchPermit <= zero; // beq
    'b010: ex_branchPermit <= ~ zero; // bne
    'b011: ex_branchPermit <= (ex_opb < 0); // bltz
    'b100: ex_branchPermit <= (ex_opb >= 0); // bgez
    'b101: ex_branchPermit <= (ex_opb <= 0); // blez
    'b110: ex_branchPermit <= (ex_opb > 0); // bgtz
    default: ex_branchPermit <= 0;
    endcase
end


endmodule

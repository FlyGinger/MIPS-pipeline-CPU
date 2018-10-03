`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    15:45:00 10/03/2018 
// Module Name:    Forwarding
// Description:    forwarding for hazards
// Revision 0.01 - File Created 15:45:00 10/03/2018 
//////////////////////////////////////////////////////////////////////////////////

module Forwarding(
    input wire [31:0] ex_inst, input wire [31:0] mem_inst,
    input wire [4:0] id_rs, input wire [4:0] id_rt,
    input wire [4:0] ex_rfDst, input wire [4:0] mem_rfDst,
    input wire ex_branchPermit,
    input wire [31:0] rs, input wire [31:0] rt,
    input wire [31:0] ex_forwarding, input wire [31:0] mem_forwarding,
    output wire if_stall, output wire id_stall, output wire ex_flush,
    output reg [31:0] rfRs_forwarding, output reg [31:0] rfRt_forwarding
    );

wire ex_load = (ex_inst[31:26] == 6'b100011) && ((id_rs == ex_rfDst) || (id_rt == ex_rfDst));
wire mem_load = (mem_inst[31:26] == 6'b100011) && ((id_rs == mem_rfDst) || (id_rt == mem_rfDst));
assign id_stall = ex_branchPermit | ex_load | mem_load; // branch or lw
assign if_stall = ex_load | mem_load; // lw
assign ex_flush = id_stall;


// Rs
always @ *
begin
    if (id_rs != 5'b0)
    begin
        if (id_rs == ex_rfDst)
            rfRs_forwarding <= ex_forwarding;
        else if (id_rs == mem_rfDst)
            rfRs_forwarding <= mem_forwarding;
        else
            rfRs_forwarding <= rs;
    end
    else
        rfRs_forwarding <= rs;
end


// Rt
always @ *
begin
    if (id_rt != 5'b0)
    begin
        if (id_rt == ex_rfDst)
            rfRt_forwarding <= ex_forwarding;
        else if (id_rt == mem_rfDst)
            rfRt_forwarding <= mem_forwarding;
        else
            rfRt_forwarding <= rt;
    end
    else
        rfRt_forwarding <= rt;
end


endmodule
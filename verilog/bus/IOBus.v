`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    19:20:53 09/30/2018 
// Module Name:    IOBus 
// Description:    I/O bus
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module IOBus(
    // clock and reset
    input wire clk, input wire rst,
    // CPU
    input wire [31:0] addr4CPU, output reg [31:0] data2CPU,
    input wire re4CPU, input wire we4CPU, input wire [31:0] data4CPU,
    // RAM
    output wire [11:0] addr2RAM, input wire [31:0] data4RAM,
    output wire we2RAM, output wire [31:0] data2RAM,
    // VRAM
    output wire [18:0] addr2VRAM, input wire [11:0] data4VRAM,
    output wire we2VRAM, output wire [11:0] data2VRAM,
    // ROM
    output wire [31:0] addr2ROM, input wire [31:0] data4ROM,
    // devices
    input wire [15:0] switch, // switches
    output reg [31:0] seg7led, // 7-segment LED
    output reg VGAmode, output reg [11:0] forecolor, output reg [11:0] backcolor, // VGA
    input wire KBDready, input wire [7:0] scancode, output reg KBDread // keyboard
    );


// address allocation
// 0x0xxxxxxx: RAM
// 0x1xxxxxxx: VRAM
// 0x2xxxxxxx: ROM
// 0xf0000000: switch
// 0xf0000004: seg7led
// 0xf0000008: vgamode
// 0xf000000c: forecolor
// 0xf0000010: backcolor
// 0xf0000014: scancode
// 0xf0000018: KBDready


// CPU
always @ *
begin
    casex(addr4CPU)
    32'h0xxxxxxx: data2CPU <= data4RAM;
    32'h1xxxxxxx: data2CPU <= {20'h0, data4VRAM};
    32'h2xxxxxxx: data2CPU <= data4ROM;
    32'hf0000000: data2CPU <= {16'h0, switch};
    32'hf0000004: data2CPU <= seg7led;
    32'hf0000008: data2CPU <= {31'h0, VGAmode};
    32'hf000000c: data2CPU <= {20'h0, forecolor};
    32'hf0000010: data2CPU <= {20'h0, backcolor};
    32'hf0000014: data2CPU <= {24'h0, scancode};
    32'hf0000018: data2CPU <= {31'h0, KBDready};
    default: data2CPU <= 0;
    endcase
end


// RAM
assign addr2RAM = addr4CPU[13:2];
assign we2RAM = (addr4CPU[31:28] == 4'h0) ? we4CPU : 1'b0;
assign data2RAM = data4CPU;


// VRAM
assign addr2VRAM = addr4CPU[20:2];
assign we2VRAM = (addr4CPU[31:28] == 4'h1) ? we4CPU : 1'b0;
assign data2VRAM = data4CPU[11:0];


// ROM
assign addr2ROM = addr4CPU;


// devices
always @ (posedge clk)
begin
    if (rst)
    begin
        seg7led <= 0;
        VGAmode <= 0;
        forecolor <= 0;
        backcolor <= 0;
    end
    else
    begin
        if ((addr4CPU == 32'hf0000004) && we4CPU)
            seg7led <= data4CPU;
        if ((addr4CPU == 32'hf0000008) && we4CPU)
            VGAmode <= data4CPU[0];
        if ((addr4CPU == 32'hf000000c) && we4CPU)
            forecolor <= data4CPU[11:0];
        if ((addr4CPU == 32'hf0000010) && we4CPU)
            backcolor <= data4CPU[11:0];
    end
end


// keyboard
always @ (posedge clk)
begin
    if (rst)
        KBDread <= 0;
    else
    begin
        if (KBDready && addr4CPU == 32'hf0000014 && re4CPU)
            KBDread <= 1;
        else if (!KBDready)
            KBDread <= 0;
    end
end


endmodule

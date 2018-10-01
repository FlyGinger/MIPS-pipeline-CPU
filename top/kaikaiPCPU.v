`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Zengkai Jiang
// Create Date:    19:00:25 09/30/2018 
// Module Name:    kaikaiPCPU 
// Description:    naive PCPU
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module kaikaiPCPU(
    input wire CLK_200MHZ_P,
    input wire CLK_200MHZ_N,
    input wire RSTN,
    input wire [15:0] SW,
    output wire SEGCLK,
    output wire SEGDT,
    output wire SEGEN,
    output wire SEGCLR,
    input wire PS2_CLK,
    input wire PS2_DATA,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_VS,
    output wire VGA_HS,
    input wire UART_RX
    );


// CPU signals
wire [31:0] addrInst;
wire [31:0] addr4CPU2Bus, data4CPU2Bus;
wire we4CPU2Bus;
// IO Bus
wire [11:0] addr4Bus2RAM;
wire [18:0] addr4Bus2VRAM;
wire we4Bus2RAM, we4Bus2VRAM;
wire [31:0] data4Bus2CPU;
wire [31:0] data4RAM2Bus, data4Bus2RAM;
wire [11:0] data4VRAM2Bus, data4Bus2VRAM;
wire [31:0] addr4Bus2ROM, data4ROM2Bus;
wire [31:0] seg7led;
wire VGAmode;
wire [11:0] forecolor, backcolor;
wire KBDread, KBDready;
wire [7:0] scancode;
// RAM
wire [31:0] instIn;
// VRAM
wire [11:0] data4VRAM2VGA;
// clock
wire rst = ~RSTN;
wire clk50mhz, clk50mhzn, clk25mhz, clk200mhz, clk100mhz;
wire [31:0] clkdiv;
wire clkcpu = SW[1] ? clk50mhz : clkdiv[26];
wire clkio = SW[1] ? clk50mhzn : ~clkdiv[26];

// VGA
wire [18:0] addr4VGA2VRAM;


// pipeline CPU
PCPU CPU(.clk(clkcpu), .rst(rst),
    .addrInst(addrInst), .instIn(instIn),
    .addrData(addr4CPU2Bus), .dataIn(data4Bus2CPU),
    .memWE(we4CPU2Bus), .dataOut(data4CPU2Bus));


// I/O bus
IOBus Bus(.clk(clkcpu), .rst(rst),
    .addr4CPU(addr4CPU2Bus), .data2CPU(data4Bus2CPU),
    .we4CPU(we4CPU2Bus), .data4CPU(data4CPU2Bus),
    .addr2RAM(addr4Bus2RAM), .data4RAM(data4RAM2Bus),
    .we2RAM(we4Bus2RAM), .data2RAM(data4Bus2RAM),
    .addr2VRAM(addr4Bus2VRAM), .data4VRAM(data4VRAM2Bus),
    .we2VRAM(we4Bus2VRAM), .data2VRAM(data4Bus2VRAM),
    .addr2ROM(addr4Bus2ROM), .data4ROM(data4ROM2Bus),
    .switch(SW),
    .seg7led(seg7led),
    .VGAmode(VGAmode), .forecolor(forecolor), .backcolor(backcolor),
    .KBDready(KBDready), .scancode(scancode), .KBDread(KBDread));


// RAM
wire [11:0] addrReprog;
wire [31:0] dataReprog;
wire weReprog;
RAM ram(
    .clka(clkio), .wea(1'b0), .addra(addrInst[13:2]), .dina(32'b0), .douta(instIn),
    .clkb(clkio), .web(weReprog), .addrb(addrReprog),
    .dinb(dataReprog), .doutb(data4RAM2Bus));
Reprog reprog(.clkUART(clk100mhz), .clkMem(clkio),
    .uartRx(UART_RX), .progEN(rst),
    .addrIn(addr4Bus2RAM), .addrOut(addrReprog),
    .dataIn(data4Bus2RAM), .dataOut(dataReprog),
    .weIn(we4Bus2RAM), .weOut(weReprog));


// VRAM
VRAM vram(
    .clka(clkio), .wea(we4Bus2VRAM), .addra(addr4Bus2VRAM),
    .dina(data4Bus2VRAM), .douta(data4VRAM2Bus),
    .clkb(clk25mhz), .web(1'b0), .addrb(addr4VGA2VRAM), .dinb(12'b0), .doutb(data4VRAM2VGA));


// ROM
ROMs rom(.clk(clkio), .addr(addr4Bus2ROM), .data(data4ROM2Bus));


// clock
ClkWiz clkwiz(.clk_P(CLK_200MHZ_P), .clk_N(CLK_200MHZ_N),
    .clk200mhz(clk200mhz), .clk100mhz(clk100mhz), .clk50mhz(clk50mhz), .clk50mhzn(clk50mhzn), .clk25mhz(clk25mhz));
ClkDiv clkDiv(.clk(clk200mhz), .clkdiv(clkdiv));


// 7-segment LED
wire [31:0] data2seg;
MUX8T1 seg(.S(SW[7:5]),
    .I0(instIn), .I1(addrInst), .I2(data4Bus2CPU), .I3(addr4CPU2Bus),
    .I4(data4CPU2Bus), .I5({24'b0, scancode}), .I6(seg7led), .I7(),
    .O(data2seg));
Seg7LED seg7(.clk(clk100mhz), .rst(rst),
    .start(clkdiv[21]), .text(SW[0]),
    .flash(1'b0), .hexs(data2seg), .points(8'b0), .LES(8'b0),
    .segclk(SEGCLK), .segdt(SEGDT), .segen(SEGEN), .segclr(SEGCLR));


// VGA
VGAController vga(.clk(clk25mhz), .clkhigh(clk100mhz), .rst(rst),
    .RGB(data4VRAM2VGA), .VGAmode(VGAmode), .forecolor(forecolor), .backcolor(backcolor),
    .addr2VRAM(addr4VGA2VRAM),
    .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));


// Keyboard
Keyboard kbd(.clk(clk50mhz), .rst(rst),
    .ps2_clk(PS2_CLK), .ps2_data(PS2_DATA),
    .intAck(KBDread), .code(scancode), .int(KBDready), .overflow());


endmodule

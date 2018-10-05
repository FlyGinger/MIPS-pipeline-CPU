/**
 * Top Module
 * based SWORD V4 (educational platform designed by Zhejiang University)
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


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
wire re4CPU2Bus;
// Cache
wire [31:0] cache_addr;
wire cache_re;
wire [31:0] cache_data_o;
wire cache_we;
wire [31:0] cache_data_i;
wire cache_stall;
// IO Bus
wire [18:0] addr4Bus2VRAM;
wire we4Bus2VRAM;
wire [31:0] data4Bus2CPU;
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


// VGA
wire [18:0] addr4VGA2VRAM;


// pipeline CPU
PCPU CPU(.clk(clk50mhz), .rst(rst), .cache_stall(cache_stall),
    .inst_addr(addrInst), .inst_in(instIn), .inst_re(),
    .data_addr(addr4CPU2Bus), .data_in(data4Bus2CPU),
    .data_re(re4CPU2Bus), .data_we(we4CPU2Bus), .data_out(data4CPU2Bus));


// cache
Cache cache(.clk(clk50mhzn), .rst(rst),
    .addr(cache_addr),
    .re(cache_re), .data_o(cache_data_o),
    .we(cache_we), .data_i(cache_data_i),
    .cache_stall(cache_stall));


// I/O bus
IOBus Bus(.clk(clk50mhz), .rst(rst),
    .addr4CPU(addr4CPU2Bus), .data2CPU(data4Bus2CPU),
    .re4CPU(re4CPU2Bus), .we4CPU(we4CPU2Bus), .data4CPU(data4CPU2Bus),
    .addr2Cache(cache_addr), .re2Cache(cache_re), .data4Cache(cache_data_o),
    .we2Cache(cache_we), .data2Cache(cache_data_i),
    .addr2VRAM(addr4Bus2VRAM), .data4VRAM(data4VRAM2Bus),
    .we2VRAM(we4Bus2VRAM), .data2VRAM(data4Bus2VRAM),
    .addr2ROM(addr4Bus2ROM), .data4ROM(data4ROM2Bus),
    .switch(SW),
    .seg7led(seg7led),
    .VGAmode(VGAmode), .forecolor(forecolor), .backcolor(backcolor),
    .KBDready(KBDready), .scancode(scancode), .KBDread(KBDread));


// RAM
wire [9:0] addrReprog;
wire [31:0] dataReprog;
wire weReprog;
RAM_inst ram_inst(
    .clka(clk50mhzn), .wea(weReprog), .addra(addrReprog),
    .dina(dataReprog), .douta(instIn));
Reprog#(.ADDR_WIDTH(10)) reprog(.clkUART(clk100mhz), .clkMem(clk50mhzn),
    .uartRx(UART_RX), .progEN(rst),
    .addrIn(addrInst[11:2]), .addrOut(addrReprog),
    .dataIn(0), .dataOut(dataReprog),
    .weIn(0), .weOut(weReprog));


// VRAM
VRAM vram(
    .clka(clk50mhzn), .wea(we4Bus2VRAM), .addra(addr4Bus2VRAM),
    .dina(data4Bus2VRAM), .douta(data4VRAM2Bus),
    .clkb(clk50mhz), .web(1'b0), .addrb(addr4VGA2VRAM), .dinb(12'b0), .doutb(data4VRAM2VGA));


// ROM
ROMs rom(.clk(clk50mhzn), .addr(addr4Bus2ROM), .data(data4ROM2Bus));


// clock
ClkWiz clkwiz(.clk_in1_p(CLK_200MHZ_P), .clk_in1_n(CLK_200MHZ_N),
    .clk200mhz(clk200mhz), .clk100mhz(clk100mhz), .clk50mhz(clk50mhz), .clk50mhzn(clk50mhzn), .clk25mhz(clk25mhz));
ClkDiv clkDiv(.clk(clk200mhz), .clkdiv(clkdiv));


// 7-segment LED
wire [31:0] data2seg;
MUX8T1 seg(.s(SW[7:5]),
    .i0(instIn), .i1(addrInst), .i2(data4Bus2CPU), .i3(addr4CPU2Bus),
    .i4(data4CPU2Bus), .i5({23'h0, KBDready, scancode}), .i6(backcolor), .i7(seg7led),
    .o(data2seg));
Seg7LED seg7(.clk(clk50mhz), .rst(rst),
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

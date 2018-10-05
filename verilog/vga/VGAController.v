/**
 * VGA Controller
 * @author Zengkai Jiang
 * @date 2018.08.27
 */


module VGAController(
    input wire clk, // 25 MHz
    input wire clkhigh,
    input wire rst,
    input wire [11:0] RGB,
    input wire VGAmode,
    input wire [11:0] forecolor,
    input wire [11:0] backcolor,
    output wire [18:0] addr2VRAM,
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
    );


wire [9:0] h_addr;
wire [8:0] v_addr;
assign addr2VRAM = (VGAmode == 1) ? (v_addr * 'd640 + h_addr) : (v_addr[8:4] * 'd80 + h_addr[9:3]);
wire [14:0] addr2ROM = {RGB[7:0], v_addr[3:0], h_addr[2:0]};
wire data4ROM;
wire [11:0] RGB_text = (data4ROM == 1) ? forecolor : backcolor;


VGA M0(
    .clk(clk),
    .clr(rst),
    .RGB((VGAmode == 1) ? RGB : RGB_text),
    .h_addr(h_addr),
    .v_addr(v_addr),
    .read(),
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .R(VGA_R),
    .G(VGA_G),
    .B(VGA_B));

ROM_fonttable M1(
    .addra(addr2ROM),
    .clka(clkhigh),
    .douta(data4ROM));

    
endmodule

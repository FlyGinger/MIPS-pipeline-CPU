`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zengkai Jiang
// 
// Create Date: 2017/12/08 23:56:54
// Design Name: 
// Module Name: VGA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA(
                input [11:0] RGB,           //rrrrrrrr_gggggggg_bbbbbbbb
                input clk,                  //25MHz
                input clr,                  //clear, active high
                output reg [9:0] h_addr,    //horizontal address
                output reg [8:0] v_addr,    //vertical address
                output reg read,            //active high
                output reg hsync,           //horizontal synchronization
                output reg vsync,           //vertical synchronization
                output reg [3:0] R,         //red
                output reg [3:0] G,         //green
                output reg [3:0] B          //blue
    );
    
    //VGA horizontal counter
    //total:800 (0-799)
    //SP:   96  (0-95)
    //BP:   48  (96-143)
    //HV:   640 (144-783)
    //FP:   16  (784-799)
    reg [9:0] h_count;
    always @ (posedge clk or posedge clr)
        begin
            if (clr)
                begin h_count <= 10'b0; end
            else if (h_count == 10'd799)
                begin h_count <= 10'b0; end
            else                            
                begin h_count <= h_count + 10'b1; end
        end
    
    //VGA vertical counter
    //total:521 (0-520)
    //SP:   2   (0-1)
    //BP:   29  (2-30)
    //VV:   480 (31-510)
    //FP:   10  (511-520)
    reg [9:0] v_count;
    always @ (posedge clk or posedge clr)
        begin
            if (clr)
                begin v_count <= 10'b0; end
            else
                begin   if (h_count ==10'd799)
                            begin   if (v_count == 10'd520)
                                        begin v_count <= 10'b0; end
                                    else
                                        begin v_count <= v_count + 10'b1; end
                            end
                end
        end
        
    //relays
    wire [9:0] h_addr_relay = h_count - 10'd144;
    wire [9:0] v_addr_relay = v_count - 10'd31;
    wire hsync_relay = (h_count > 10'd95);
    wire vsync_relay = (v_count > 10'd1);
    wire read_relay = (h_count > 10'd143) && (h_count < 10'd784) && (v_count > 10'd30) && (v_count < 10'd511);
    
    //output
    always @ (posedge clk)
        begin
            h_addr <= h_addr_relay;
            v_addr <= v_addr_relay[8:0];
            hsync <= hsync_relay;
            vsync <= vsync_relay;
            read <= read_relay;
            R <= read ? RGB[11:8] : 4'b0;
            G <= read ? RGB[ 7:4] : 4'b0;
            B <= read ? RGB[ 3:0] : 4'b0;
        end
    
endmodule

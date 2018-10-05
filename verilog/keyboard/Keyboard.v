/**
 * Keyboard Control
 * @author Zengkai Jiang
 * @date 2018.08.28
 */


module Keyboard(
    input wire clk, // 50 MHz
    input wire rst, // reset, active high
    input wire ps2_clk,
    input wire ps2_data,
    input wire intAck, // read, active high
    output reg [7:0] code,
    output reg int,
    output wire overflow
    );

reg read;
wire ready;
wire [7:0] data;
ps2_keyboard M0(
    .clk(clk),
    .clrn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rdn(~read),
    .data(data),
    .ready(ready),
    .overflow(overflow));

always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
        read <= 0;
        code <= 0;
        int <= 0;
    end
    else begin
        if (int == 0 && intAck == 0) begin
            if (ready) begin
                code <= data;
                read <= 1;
                int <= 1;
            end
        end
        else begin
            read <= 0;
            if (intAck == 1) begin
                int <= 0;
            end
        end
    end
end



endmodule

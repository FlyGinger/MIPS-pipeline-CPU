/**
 * Multiplexer
 * 1 from 8
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module MUX8T1#(
    parameter WIDTH = 32
    )(
    input wire [2:0] s,
    input wire [WIDTH-1:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output reg [WIDTH-1:0] o
    );


always @ * begin
    case (s)
        3'b000: o <= i0;
        3'b001: o <= i1;
        3'b010: o <= i2;
        3'b011: o <= i3;
        3'b100: o <= i4;
        3'b101: o <= i5;
        3'b110: o <= i6;
        3'b111: o <= i7;
    endcase
end


endmodule

/**
 * Multiplexer
 * 1 from 2
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module MUX2T1#(WIDTH = 32)(
    input s,
    input [WIDTH-1:0] i0, i1,
    output reg [WIDTH-1:0] o
    );

    
    always @ * begin
        case (s)
        1'b0: o <= i0;
        1'b1: o <= i1;
        endcase
    end


endmodule

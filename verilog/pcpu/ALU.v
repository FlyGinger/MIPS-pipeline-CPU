/**
 * Arithmetic Logical Unit
 * support sll, srl, sra, add, sub, and, or, xor, nor, slt, aui
 * and a special operation opb, which means result = opb
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


`include "PCPU.vh"
module ALU(
    // input
    input [`ALU_OP_WIDTH] op, input [31:0] a, input [31:0] b,
    // output
    output reg [31:0] result, output zero
    );


    always @ * begin
        case (op)
        'd0: result <= b << a;
        'd1: result <= b >> a;
        'd2: result <= $signed(b) >>> a;
        'd3: result <= b;
        'd4: result <= $signed(a) + $signed(b);
        'd5: result <= $signed(a) - $signed(b);
        'd6: result <= a & b;
        'd7: result <= a | b;
        'd8: result <= a ^ b;
        'd9: result <= ~ (a | b);
        'd10: result <= (a < b) ? 32'b1 : 0;
        'd11: result <= $signed(a) + $signed({b[15:0], 16'b0});
        default: result <= 0;
        endcase
    end

    assign zero = ~ (|result);


endmodule

/**
 * Branch Control Unit
 * determine whether it meets the conditions of branch instruction
 * @author Zengkai Jiang
 * @date 2018.10.05
 */
 

`include "PCPU.vh"
module BranchCtrl(
    input [`BRANCH_WIDTH] branch_type, input zero, input [31:0] rs,
    output reg branch_permit
    );


    always @ * begin
        case (branch_type[2:0])
        3'b000: branch_permit <= 0;
        3'b001: branch_permit <= ($signed(rs) < 0);
        3'b010: branch_permit <= ($signed(rs) >= 0);
        3'b011: branch_permit <= zero;
        3'b100: branch_permit <= ~zero;
        3'b101: branch_permit <= ($signed(rs) <= 0);
        3'b110: branch_permit <= ($signed(rs) > 0);
        default: branch_permit <= 0;
        endcase
    end


endmodule

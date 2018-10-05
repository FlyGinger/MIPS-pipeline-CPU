/**
 * Registers of Instruction Decode Stage
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


module ID_reg(
    // clock and rst
    input clk, input rst, input stall, input flush,
    // pc and instruction
    input [31:0] if_pc, input [31:0] if_inst, output reg [31:0] id_pc, output reg [31:0] id_inst
    );


    always @ (posedge clk) begin
        if (rst | flush) begin
            id_pc <= 0;
            id_inst <= 0;
        end
        else if (~stall) begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end


endmodule

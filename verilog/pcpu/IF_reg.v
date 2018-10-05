/**
 * Registers of Instruction Fetch Stage
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


module IF_reg(
    // clock and reset
    input clk, input rst, input stall,
    // program counter
    input [31:0] pc_next, output reg [31:0] pc, output reg re
    );


    // read enable
    always @ (posedge clk) begin
        if (rst)
            re <= 0;
        else
            re <= 1;
    end


    // program counter
    always @ (posedge clk) begin
        if (rst)
            pc <= 32'h0;
        else if (~stall)
            pc <= pc_next;
    end


endmodule

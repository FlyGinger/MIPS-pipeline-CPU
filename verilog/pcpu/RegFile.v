/**
 * Register Files
 * 32 32-bit registers
 * @author Zengkai Jiang
 * @date 2018.10.04
 */


module RegFile(
    // clock and reset
    input clk, input rst,
    // write port
    input we, input [4:0] waddr, input [31:0] wdata,
    // read port A
    input rea, input [4:0] raddra, output [31:0] rdataa,
    // read port B
    input reb, input [4:0] raddrb, output [31:0] rdatab
    );


    // registers
    reg [31:0] regs [1:31];


    // write port
    integer i;
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 1; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (we && (waddr != 5'b0))
            regs[waddr] <= wdata;
    end


    // read port
    assign rdataa = (rea && (raddra != 5'b0)) ? regs[raddra] : 31'b0;
    assign rdatab = (reb && (raddrb != 5'b0)) ? regs[raddrb] : 32'b0;


endmodule

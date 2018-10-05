/**
 * Branch Predict Unit
 * predict whether it meets the conditions of branch instruction
 * dynamic prediction using saturating counter (also called bimodal predictor)
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


`include "PCPU.vh"
module BranchPredict(
    // clock and reset
    input clk, input rst,
    // current pc
    input [31:0] pc,
    // branch type
    input [`BRANCH_WIDTH] id_branch_type, input [31:0] id_branch_dst,
    input [`BRANCH_WIDTH] ex_branch_type, input ex_branch_permit,
    // output
    output reg [31:0] pc_next, output id_flush
    );


    wire [31:0] pc_add_4 = pc + 32'h4;
    reg [31:0] pc_predict;
    wire id_branch_j = (id_branch_type[4:3] == 2'b11) || (id_branch_type[4:3] == 2'b10);
    wire id_branch_b = (id_branch_type[4:3] == 2'b01);
    wire ex_branch_b = (ex_branch_type[4:3] == 2'b01);


    always @ * begin
        if (id_branch_j)
            pc_next <= id_branch_dst;
        else if (id_branch_b | ex_branch_b)
            pc_next <= pc_predict;
        else
            pc_next <= pc_add_4;
    end


    // predict history
    reg [1:0] counter[1023:0];
    reg [10:0] pc_hash0;
    reg [10:0] pc_hash1;
    reg [1:0] item0;
    reg [1:0] item1;
    reg [1:0] item_new;
    wire prediction0 = item0[1];
    reg prediction1;
    reg [31:0] counter_predict;
    wire wrong_predict = ex_branch_b && (prediction1 ^ ex_branch_permit);
    assign id_flush = wrong_predict;


    integer i;
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1)
                counter[i] <= 0;
        end
        else begin
            if (ex_branch_b)
                counter[pc_hash1] <= item_new;
            item0 <= counter[pc[11:2]];
        end
    end


    always @ (posedge clk) begin
        if (rst) begin
            pc_hash0 <= 0;
            pc_hash1 <= 0;
            item1 <= 0;
            prediction1 <= 0;
            counter_predict <= 0;
        end
        else begin
            pc_hash0 <= pc[11:2];
            pc_hash1 <= pc_hash0;
            item1 <= item0;
            prediction1 <= prediction0;
            counter_predict <= prediction0 ? pc_add_4 : id_branch_dst;
        end
    end
    

    always @ * begin
        if (id_branch_b)
            pc_predict <= prediction0 ? id_branch_dst : pc_add_4;
        else
            pc_predict <= wrong_predict ? counter_predict : pc_add_4;
    end


    always @ * begin
        case (item1)
        2'b00: if (ex_branch_permit) item_new <= 2'b01; else item_new <= 2'b00;
        2'b01: if (ex_branch_permit) item_new <= 2'b10; else item_new <= 2'b00;
        2'b10: if (ex_branch_permit) item_new <= 2'b11; else item_new <= 2'b01;
        2'b11: if (ex_branch_permit) item_new <= 2'b11; else item_new <= 2'b10;
        endcase
    end


endmodule

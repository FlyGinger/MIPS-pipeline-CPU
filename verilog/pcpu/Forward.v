/**
 * Forward Unit
 * deal with data hazard and detect hazard caused by load instruction
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module Forward(
    // read addr
    input [4:0] id_rs, input [4:0] id_rt, input id_rea, input id_reb,
    // lw
    input ex_lw, input mem_lw,
    // dst
    input [4:0] ex_rf_dst, input [4:0] mem_rf_dst,
    // raw
    input [31:0] rs_raw, input [31:0] rt_raw,
    // forward
    input [31:0] data_ex, input [31:0] data_mem,
    // stall
    output if_stall, output id_stall, output ex_flush,
    // result
    output reg [31:0] rs_f, output reg [31:0] rt_f
    );


    assign id_stall = ex_lw | mem_lw;
    assign if_stall = id_stall;
    assign ex_flush = id_stall;

    
    // rs
    always @ * begin
        if (id_rea && id_rs != 5'b0)
        begin
            if (id_rs == ex_rf_dst)
                rs_f <= data_ex;
            else if (id_rs == mem_rf_dst)
                rs_f <= data_mem;
            else
                rs_f <= rs_raw;
        end
        else
            rs_f <= rs_raw;
    end


    // rt
    always @ * begin
        if (id_reb && id_rt != 5'b0)
        begin
            if (id_rt == ex_rf_dst)
                rt_f <= data_ex;
            else if (id_rt == mem_rf_dst)
                rt_f <= data_mem;
            else
                rt_f <= rt_raw;
        end
        else
            rt_f <= rt_raw;
    end


endmodule

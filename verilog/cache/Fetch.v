/**
 * Fetch Unit
 * fetch data from main memory to cache
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module Fetch(
    // clock and reset
    input clk, input rst,
    // main memory
    input [31:0] addr, input [31:0] main_mem_data, output reg [9:0] main_mem_addr,
    // cache
    output reg [8:0] cache_data_addr, output [31:0] cache_data, output reg cache_data_we,
    // control
    input start, output reg done
    );


    reg [1:0] state;
    reg [1:0] state_next;
    reg [2:0] counter;
    localparam IDLE = 2'b00;
    localparam FETCH = 2'b01;
    localparam DONE = 2'b10;
    wire [5:0] addr_index = addr[10:5];
    assign cache_data = main_mem_data;


    // state machine
    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= state_next;
    end


    // next state
    always @ * begin
        case (state)
        IDLE:   if (start)
                    state_next <= FETCH;
                else
                    state_next <= IDLE;
        FETCH:  if (counter == 3'd7)
                    state_next <= DONE;
                else
                    state_next <= FETCH;
        DONE:   state_next <= IDLE;
        default: state_next <= IDLE;
        endcase
    end


    // control signals
    always @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            done <= 0;
            cache_data_addr <= 0;
            cache_data_we <= 0;
            main_mem_addr <= 0;
        end
        else begin
            case (state)
            IDLE:       begin
                            counter <= 0;
                            done <= 0;
                            cache_data_addr <= 0;
                            cache_data_we <= 0;
                            main_mem_addr <= {addr[31:5], 3'b0};
                        end
            FETCH:      begin
                            counter <= counter + 3'b1;
                            done <= 0;
                            cache_data_addr <= {addr_index, counter};
                            cache_data_we <= 1;
                            main_mem_addr <= {addr[31:5], counter} + 1;
                        end
            DONE:       begin
                            counter <= 0;
                            done <= 1;
                            cache_data_addr <= 0;
                            cache_data_we <= 0;
                            main_mem_addr <= 0;
                        end
            default:    begin
                            counter <= 0;
                            done <= 0;
                            cache_data_addr <= 0;
                            cache_data_we <= 0;
                            main_mem_addr <= 0;
                        end
            endcase
        end
    end


endmodule

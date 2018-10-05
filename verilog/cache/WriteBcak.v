/**
 * Write Back Unit
 * write data from cache back to main memory
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module WriteBack(
    // clock and reset
    input clk, input rst,
    // main memory
    input [31:0] addr, output [31:0] main_mem_data, output reg main_mem_we, output reg [9:0] main_mem_addr,
    // cache
    output reg [8:0] cache_data_addr, input [31:0] cache_data,
    // control
    input start, output reg done
    );


    reg [1:0] state;
    reg [1:0] state_next;
    reg [2:0] counter;
    localparam IDLE = 2'b00;
    localparam WRITEBACK = 2'b01;
    localparam DONE = 2'b10;
    wire [5:0] addr_index = addr[10:5];
    assign main_mem_data = cache_data;


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
        IDLE:       if (start)
                        state_next <= WRITEBACK;
                    else
                        state_next <= IDLE;
        WRITEBACK:  if (counter == 3'd7)
                        state_next <= DONE;
                    else
                        state_next <= WRITEBACK;
        DONE:       state_next <= IDLE;
        default:    state_next <= IDLE;
        endcase
    end


    // control signals
    always @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            done <= 0;
            main_mem_we <= 0;
            main_mem_addr <= 0;
            cache_data_addr <= 0;
        end
        else begin
            case (state)
            IDLE:       begin
                            counter <= 0;
                            done <= 0;
                            main_mem_we <= 0;
                            main_mem_addr <= 0;
                            cache_data_addr <= 0;
                        end
            WRITEBACK:  begin
                            counter <= counter + 1;
                            done <= 0;
                            main_mem_we <= 1;
                            main_mem_addr <= {addr[31:5], counter};
                            cache_data_addr <= {addr_index, counter};
                        end
            DONE:       begin
                            counter <= 0;
                            done <= 1;
                            main_mem_we <= 0;
                            main_mem_addr <= 0;
                            cache_data_addr <= 0;
                        end
            default:    begin
                            counter <= 0;
                            done <= 0;
                            main_mem_we <= 0;
                            main_mem_addr <= 0;
                            cache_data_addr <= 0;
                        end
            endcase
        end
    end


endmodule

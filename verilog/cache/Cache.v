/**
 * Cache Unit
 * 64 blocks and 8 words per block, 2KB in total
 * using write back method
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module Cache(
    // clock and reset
    input clk, input rst,
    // address and data to or from cpu
    input [31:0] addr,
    input re, output [31:0] data_o,
    input we, input [31:0] data_i,
    // stall cause by cache
    output reg cache_stall
    );


    // state machine signals
    reg [1:0] state;
    reg [1:0] state_next;
    localparam IDLE = 2'b00;
    localparam MISS = 2'b01;
    localparam FETCH = 2'b10;
    localparam WRITEBACK = 2'b11;
    reg fetch_start;
    reg writeback_start;
    // cache signals
    reg [22:0] cache_tag_i;
    reg cache_tag_we;
    wire [22:0] cache_tag_o;
    wire cache_tag_dirty                    = cache_tag_o[22];
    wire cache_tag_valid                    = cache_tag_o[21];
    wire cache_tag_tag                      = cache_tag_o[20:0];
    wire [20:0] addr_tag                    = addr[31:11];
    wire [5:0] addr_index                   = addr[10:5];
    wire [2:0] addr_offset                  = addr[4:2];
    wire [5:0] cache_tag_addr               = addr_index;
    wire cache_hit                          = (addr_tag == cache_tag_tag) && cache_tag_valid;
    wire [8:0] hit_cache_data_addr          = {addr_index, addr_offset};
    wire [31:0] hit_cache_data_i            = data_i;
    wire hit_cache_data_we                  = (state == IDLE) && we && cache_hit;
    reg [8:0] cache_data_addr;
    reg [31:0] cache_data_i;
    reg cache_data_we;
    wire [31:0] cache_data_o;
    // fetch state signals
    wire fetch_done;
    wire [8:0] fetch_cache_data_addr;
    wire [31:0] fetch_cache_data_i;
    wire fetch_cache_data_we;
    wire [31:0] fetch_main_mem_data_o       = mem_data_o;
    wire [9:0] fetch_main_mem_addr;
    // write back state
    wire writeback_done;
    wire [31:0] writeback_addr              = {cache_tag_tag, addr_index, addr_offset, 2'b00};
    wire [8:0] writeback_cache_data_addr;
    wire [31:0] writeback_cache_data_o      = cache_data_o;
    wire [31:0] writeback_main_mem_data_i;
    wire writeback_main_mem_we;
    wire [9:0] writeback_main_mem_addr;
    // main memory
    wire mem_we                             = writeback_main_mem_we;
    wire [9:0] mem_addr                     = (state == WRITEBACK) ? writeback_main_mem_addr : fetch_main_mem_addr;
    wire [31:0] mem_data_i                  = writeback_main_mem_data_i;
    wire [31:0] mem_data_o;


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
        IDLE:       if ((re || we) && (~cache_hit))
                        state_next <= MISS;
                    else
                        state_next <= IDLE;
        MISS:       if ((~cache_hit) && (~cache_tag_dirty))
                        state_next <= FETCH;
                    else if ((~cache_hit) && cache_tag_dirty)
                        state_next <= WRITEBACK;
                    else
                        state_next <= IDLE;
        FETCH:      if (fetch_done)
                        state_next <= IDLE;
                    else
                        state_next <= FETCH;
        WRITEBACK:  if (writeback_done)
                        state_next <= FETCH;
                    else
                        state_next <= WRITEBACK;
        endcase
    end


    // at the beginning of fetch or writeback
    always @ (posedge clk) begin
        if (rst) begin
            fetch_start <= 0;
            writeback_start <= 0;
        end
        else begin
            case (state)
            IDLE:       begin
                            fetch_start <= 0;
                            writeback_start <= 0;
                        end
            MISS:       begin
                            if ((~cache_hit) && (~cache_tag_dirty)) begin
                                fetch_start <= 1;
                                writeback_start <= 0;
                            end
                            else if ((~cache_hit) && cache_tag_dirty) begin
                                fetch_start <= 0;
                                writeback_start <= 1;
                            end
                            else begin
                                fetch_start <= 0;
                                writeback_start <= 0;
                            end
                        end
            FETCH:      begin
                            fetch_start <= 0;
                            writeback_start <= 0;
                        end
            WRITEBACK:  begin
                            if (writeback_done)
                                fetch_start <= 1;
                            else
                                fetch_start <= 0;
                            writeback_start <= 0;
                        end
            endcase
        end
    end


    // cache logics
    cache_tag cache_tag_dm(
        .clk(clk), .a(cache_tag_addr), .d(cache_tag_i),
        .we(cache_tag_we), .spo(cache_tag_o));

    cache_data cache_data_dm(
        .clk(clk), .a(cache_data_addr), .d(cache_data_i),
        .we(cache_data_we), .spo(cache_data_o));

    assign data_o = cache_data_o;
    
    always @ * begin
        case (state)
        IDLE, MISS: begin
                        cache_data_addr <= hit_cache_data_addr;
                        cache_data_i <= hit_cache_data_i;
                        cache_data_we <= hit_cache_data_we;
                    end
        FETCH:      begin
                        cache_data_addr <= fetch_cache_data_addr;
                        cache_data_i <= fetch_cache_data_i;
                        cache_data_we <= fetch_cache_data_we;
                    end
        WRITEBACK:  begin
                        cache_data_addr <= writeback_cache_data_addr;
                        cache_data_i <= hit_cache_data_i;
                        cache_data_we <= hit_cache_data_we;
                    end
        endcase
    end

    always @ * begin
        if (state == IDLE && we && cache_hit) begin
            cache_tag_we <= 1'b1;
            cache_tag_i <= {1'b1, 1'b1, addr_tag};
        end
        else if (state == FETCH) begin
            cache_tag_we <= 1'b1;
            cache_tag_i <= {1'b0, 1'b1, addr_tag};
        end
        else begin
            cache_tag_we <= 1'b0;
            cache_tag_i <= 0;
        end
    end


    // stall
    always @ * begin
        if ((~we) && (~re))
            cache_stall <= 0;
        else if ((state == IDLE) && (addr_tag == cache_tag_tag) && cache_tag_valid)
            cache_stall <= 0;
        else
            cache_stall <= 1;
    end


    // fetch
    Fetch fetch(.clk(clk), .rst(rst),
        .addr(addr), .main_mem_data(fetch_main_mem_data_o), .main_mem_addr(fetch_main_mem_addr),
        .cache_data_addr(fetch_cache_data_addr), .cache_data(fetch_cache_data_i),
        .cache_data_we(fetch_cache_data_we),
        .start(fetch_start), .done(fetch_done));
    

    // write back
    WriteBack writeback(.clk(clk), .rst(rst),
        .addr(writeback_addr), .main_mem_data(writeback_main_mem_data_i),
        .main_mem_we(writeback_main_mem_we), .main_mem_addr(writeback_main_mem_addr),
        .cache_data_addr(writeback_cache_data_addr), .cache_data(writeback_cache_data_o),
        .start(writeback_start), .done(writeback_done));
    

    // main memory
    RAM_data main_mem(
        .clka(clk), .wea(mem_we), .addra(mem_addr), .dina(mem_data_i), .douta(mem_data_o),
        .clkb(clk), .web(1'b0), .addrb(0), .dinb(0), .doutb());


endmodule
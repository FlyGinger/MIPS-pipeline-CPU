/************************************************
  The Verilog HDL code example is from the book
  Computer Principles and Design in Verilog HDL
  by Yamin Li, published by A JOHN WILEY & SONS
************************************************/
module ps2_keyboard (clk,clrn,ps2_clk,ps2_data,rdn,data,ready,overflow);
    input        clk, clrn;                            // 50 MHz
    input        ps2_clk;                              // ps2 clock
    input        ps2_data;                             // ps2 data
    input        rdn;                                  // read, active low
    output [7:0] data;                                 // 8-bit code
    output       ready;                                // code ready
    output reg   overflow;                             // fifo overflow
    reg    [9:0] buffer;                               // ps2_data bits
    reg    [7:0] fifo[7:0];                            // circular fifo
    reg    [3:0] count;                                // count ps2_data bits
    reg    [2:0] w_ptr,r_ptr;                          // fifo write/read pointers
    reg    [3:0] ps2_clk_sync;                         // for detecting falling edge
    always @ (posedge clk)
        ps2_clk_sync <= {ps2_clk_sync[2:0],ps2_clk};   // shift ps2_clk_sync left
    wire sampling = ps2_clk_sync[3] &                  // 1
	            ps2_clk_sync[2] &                      // 1
	           ~ps2_clk_sync[1] &                      // 0
                   ~ps2_clk_sync[0];                   // 0: 1100: had a falling edge
    always @ (posedge clk) begin
        if (!clrn) begin                               // on reset
            count    <= 0;                             // clear count
            w_ptr    <= 0;                             // clear w_ptr
            r_ptr    <= 0;                             // clear r_ptr
            overflow <= 0;                             // clear overflow
        end else if (sampling) begin                   // if sampling
            if (count == 4'd10) begin                  // if got one frame
                if ((buffer[0] == 0) &&                // start bit
		    (ps2_data) &&                      // stop bit
		    (^buffer[9:1])) begin              // odd parity
                    if ((w_ptr + 3'b1) != r_ptr) begin // if fifo is not overflow
                        fifo[w_ptr] <= buffer[8:1];    // save 8-bit data to fifo
                        w_ptr <= w_ptr + 3'b1;         // w_ptr++
                    end else begin
                        overflow <= 1;                 // overflow
                    end
                end
                count <= 0;                            // for next frame
            end else begin                             // did not yet get one frame
                buffer[count] <= ps2_data;             // store ps2_data
                count <= count + 4'b1;                 // count++
            end
        end
        if (!rdn && ready) begin                       // on cpu read
            r_ptr <= r_ptr + 3'b1;                     // r_ptr++
            overflow <= 0;                             // clear overflow
        end
    end
    assign ready = (w_ptr != r_ptr);                   // fifo is not empty
    assign data  = fifo[r_ptr];                        // code byte
endmodule

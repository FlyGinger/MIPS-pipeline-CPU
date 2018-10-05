/**
 * Parallel to Serial
 * @author Zengkai Jiang
 * @date 2018.08.27
 */


module P2S#(
    parameter DATA_BITS = 16,
    parameter DIR = 0 // DIRection, 0 shift left, 1 shift right
    )(
    input wire clk,
    input wire rst, // reset, active high
    input wire start, // a slow clock
    input wire [DATA_BITS-1:0] data,
    output wire sclk,
    output wire sclrn,
    output wire sout,
    output reg sen
    );


wire finish, shift;
wire S1, S0, SL, SR;
wire [DATA_BITS:0] D;
reg [DATA_BITS:0] Q;
reg [1:0] Go = 2'b00, S = 2'b00;


assign {SR, SL} = 2'b11;
assign {S1, S0} = DIR ? {S[0], S[1]} : S;   //adjust the direction of shift
assign D        = DIR ? {1'b0, data} : {data, 1'b0}; 
assign finish   = DIR ? &Q[DATA_BITS:1] : &Q[DATA_BITS-1:0];
assign sout     = DIR ? Q[0] : Q[DATA_BITS];


always @ (posedge clk) begin
    case ({S1, S0})
        2'b00:  Q <= Q;
        2'b01:  Q <= {SR, Q[DATA_BITS:1]};
        2'b10:  Q <= {Q[DATA_BITS-1:0], SL};
        2'b11:  Q <= D;
    endcase
end


always @ (posedge clk) begin
    Go <= {Go[0], start};
end
assign shift = (Go == 2'b01) ? 1'b1 : 1'b0;


always @ (posedge clk or posedge rst) begin
    if (rst) begin sen <= 1; S <= 2'b11; end
    else begin
        if (shift & finish) begin sen <= 0; S <= 2'b11; end   //new data comes in
        else begin
            if (!finish) begin sen <= 0; S <= 2'b10; end
            else begin sen <= 1; S <= 2'b00; end
        end
    end
end


assign sclk = finish | clk;
assign sclrn = 1;


endmodule

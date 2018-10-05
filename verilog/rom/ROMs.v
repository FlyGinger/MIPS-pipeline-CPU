/**
 * ROM Controller
 * @author Zengkai Jiang
 * @date 2018.10.05
 */


module ROMs(
    input wire clk,
    input wire [31:0] addr,
    output reg [31:0] data
    );


wire [7:0] data_scancode2ascii;


always @ *
begin
    case (addr[31:24])
    8'h20: data <= {24'h0, data_scancode2ascii};
    default: data <= 0;
    endcase
end


ROM_scancode2ascii M0(
    .addra(addr[9:2]),
    .clka(clk),
    .douta(data_scancode2ascii));


endmodule

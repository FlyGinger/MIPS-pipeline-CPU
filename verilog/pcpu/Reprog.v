`timescale 1ns / 1ps
/**
 * Add reprogramming capability to the RAM attached.
 * 
 * @author Yunye Pu
 */
module Reprog #(
	parameter ADDR_WIDTH = 12
)(
	input clkUART, input clkMem, input uartRx, input progEN,
	
	input [ADDR_WIDTH-1:0] addrIn, output [ADDR_WIDTH-1:0] addrOut,
	input [31:0] dataIn, output [31:0] dataOut,
	input weIn, output weOut
);
	wire [7:0] uartData, progData;
	wire uartValid, progValid;
	wire [3:0] _weOut;
	
	UART_RX #(.COUNTER_MSB(9)) U0(.clk(clkUART), .halfPeriod(9'd433), .RX(uartRx),
		.m_data(uartData), .m_valid(uartValid));
		
	AxisFifo #(.WIDTH(8), .DEPTH_BITS(5))
		cdcFifo ( .s_rst(0), .m_rst(0),
		.s_clk(clkUART), .s_valid(uartValid), .s_ready(),     .s_data(uartData), .s_load(),
		.m_clk(clkMem),    .m_valid(progValid), .m_ready(1'b1), .m_data(progData), .m_load()
	);
	
	Reprog_upscaler #(ADDR_WIDTH) U1(.clkMem(clkMem),
		.progData(progData), .progValid(progValid), .progEn(progEN),
		.addrIn(addrIn), .dataIn(dataIn), .weIn({4{weIn}}), .enIn(1'b0),
		.addrOut(addrOut), .dataOut(dataOut), .weOut(_weOut), .enOut());
	assign weOut = |_weOut;
	
endmodule

module Reprog_upscaler #(
	parameter ADDR_WIDTH = 10
)(
	input clkMem, input [7:0] progData, input progValid, input progEn,
	input [ADDR_WIDTH-1:0] addrIn, input [31:0] dataIn, input [3:0] weIn, input enIn,
	output [ADDR_WIDTH-1:0] addrOut, output [31:0] dataOut, output [3:0] weOut, output enOut
);
	
	reg [ADDR_WIDTH-1:0] addr_internal;
	reg [31:0] data_internal;
	reg we_internal;
	reg [1:0] byteCnt;
	
	assign addrOut = we_internal? addr_internal: addrIn;
	assign dataOut = we_internal? data_internal: dataIn;
	assign weOut = we_internal? 4'hf: weIn;
	assign enOut = progEn? 1'b1: enIn;
	
	always @ (posedge clkMem)
	begin
		if(progEn)
		begin
			if(progValid)
			begin
				if(byteCnt == 2'b11)
				begin
					we_internal <= 1'b1;
					addr_internal <= addr_internal + 1'b1;
				end
				else
					we_internal <= 1'b0;
				data_internal <= {progData, data_internal[31:8]};
				byteCnt <= byteCnt + 1'b1;
			end
			else
				we_internal <= 1'b0;
		end
		else
		begin
			addr_internal <= -1;
			data_internal <= 32'h0;
			we_internal <= 1'b0;
			byteCnt <= 2'b00;
		end
	end

endmodule

module AxisFifo #(
	parameter WIDTH = 8,
	parameter DEPTH_BITS = 7
)(
	input s_clk, input s_rst, input s_valid, output s_ready,
	input [WIDTH-1:0] s_data, output [DEPTH_BITS-1:0] s_load,
	input m_clk, input m_rst, output m_valid, input m_ready,
	output reg [WIDTH-1:0] m_data, output [DEPTH_BITS-1:0] m_load
);
	localparam DEPTH = 1 << DEPTH_BITS;
	reg [WIDTH-1:0] data[DEPTH-1:0];
	
	//s_clk(write) domain logic
	reg [DEPTH_BITS-1:0] wrPtr = 0;
	reg [DEPTH_BITS-1:0] rdPtrSync;
	always @ (posedge s_clk)
	if(s_rst)
		wrPtr <= {DEPTH_BITS{1'b0}};
	else if(s_valid & s_ready)
	begin
		wrPtr <= wrPtr + 1'b1;
		data[wrPtr] <= s_data;
	end
	wire [DEPTH_BITS-1:0] wrPtr_add1 = wrPtr + 1;
	assign s_ready = wrPtr_add1 != rdPtrSync;
	assign s_load = wrPtr - rdPtrSync;
	
	//m_clk(read) domain logic
	reg [DEPTH_BITS-1:0] rdPtr = 0;
	reg [DEPTH_BITS-1:0] wrPtrSync;
	always @ (posedge m_clk)
	if(m_rst)
		rdPtr = {DEPTH_BITS{1'b0}};
	else
	begin
		if(m_valid & m_ready)
			rdPtr = rdPtr + 1'b1;
		m_data <= data[rdPtr];
	end
	assign m_valid = (rdPtr != wrPtrSync);
	assign m_load = wrPtrSync - rdPtr;
	
	always @ (posedge s_clk) rdPtrSync <= rdPtr;
	always @ (posedge m_clk) wrPtrSync <= wrPtr;
	
endmodule

module UART_RX #(
	parameter COUNTER_MSB = 9
) (
	input clk, input [COUNTER_MSB-1:0] halfPeriod,
	output reg m_valid, output reg [7:0] m_data,
	input RX
);
	reg [COUNTER_MSB:0] counter = 0;
	reg [8:0] shift = 9'h0;
	reg inRX = 1'b0;
	
	always @ (posedge clk)
	if(inRX)
	begin
		if(counter == {halfPeriod, 1'b1})
			counter <= 0;
		else
			counter <= counter + 1'b1;
		
		if(counter == {halfPeriod, 1'b1})
		begin
			m_valid <= shift[0] & RX;//Check stop bit
			if(shift[0])
			begin
				m_data <= shift[8:1];
				shift <= 8'h0;
				inRX <= 1'b0;
			end
			else
				shift <= {RX, shift[8:1]};
		end
	end
	else
	begin
		m_valid <= 1'b0;
		shift <= 9'b100000000;
		inRX <= (counter == {1'b0, halfPeriod});
		if(counter == {1'b0, halfPeriod})
			counter <= 0;
		else if(RX)
			counter <= 0;
		else
			counter <= counter + 1'b1;
	end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2024 01:51:05
// Design Name: 
// Module Name: data_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_memory(
    input clk,
    input [7:0] data_addr_in,
    input [31:0] data_in,
    input [7:0] data_addr_wr,
    input m_wr,
    output [31:0] data_out
    );
    
    reg [31:0] memory [255:0];
    
    assign data_out = memory [data_addr_in];
    
    always @(posedge clk) begin 
        if (m_wr)
            memory[data_addr_wr] <= data_in;
    end
    
    initial begin
    //TODO set the initial memory values
        $readmemh("memdata.mem", memory);
    end
endmodule

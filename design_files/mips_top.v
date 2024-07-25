`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2024 16:05:25
// Design Name: 
// Module Name: mips_top
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


module mips_top(
    input clk,
    input reset
    );
    
    wire [5:0] opcode;
    wire regWrite, memWrite, overflow_error, reg_access;
    
    controlpath controlpath(.opcode(opcode), .regWrite(regWrite), .memWrite(memWrite));
    datapath datapath(.clk(clk), .reset(reset), .opcode(opcode), .regWrite(regWrite), .memWrite(memWrite), .overflow_error(overflow_error), .reg_access(reg_access));
    
endmodule

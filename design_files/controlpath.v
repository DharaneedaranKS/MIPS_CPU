`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2024 02:58:20
// Design Name: 
// Module Name: controlpath
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


module controlpath(
    input [5:0] opcode,
    output reg regWrite,
    output reg memWrite
    );
    
    always @(*) begin
        
        case (opcode) 
            6'b000000 : {regWrite, memWrite} = 2'b10;
            6'b001xxx : {regWrite, memWrite} = 2'b10;
            6'b0001xx : {regWrite, memWrite} = 2'b00;
            6'b00001x : {regWrite, memWrite} = 2'b00;
            6'b100xxx : {regWrite, memWrite} = 2'b10;
            6'b101xxx : {regWrite, memWrite} = 2'b01;
            default : {regWrite, memWrite} = 2'b00;
        endcase
    
    end
endmodule

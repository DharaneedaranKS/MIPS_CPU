`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2024 00:25:15
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input [5:0] opcode,
    input [5:0] funct,
    input [31:0] rs,
    input [31:0] rd,
    input [31:0] shamt,
    input [15:0] imm,
    output reg [31:0] a,
    output reg [31:0] b,
    output reg [5:0] alu_funct
    );
    
    // MUX for the ALU inputs 
    // Need to account for shifts, ie, nothing coming from register, so IMM included 
    always @(*) begin
        
        a= (opcode != 6'b001111) ? rs : {{16{imm[15]}}, imm};
        
        //Initialising the alu_funct as if all are by default R type of instruction 
        //
        
        if ((opcode == 6'b0)&((funct == 000000)|(funct == 000010)|(funct == 000011))) begin
            b = shamt;       
        end
        
        // This is for I type instructions to get bitshifted appropriately 
        else if ((opcode == 6'b10zzzz)|(opcode == 6'b001zzz)) begin
            // b = ((opcode[3:0] == 4'b0100)|(opcode[3:0] == 4'b0101)) ? imm << 16 : {16'b0, imm};    
            b = (opcode != 6'b001111) ? {{16{imm[15]}}, imm} : {27'b0, 5'b10000};
        end
        
        else begin         
            b = rd;
        end
        
        case (opcode) 
            6'b001000 : alu_funct = 6'b100000;
            6'b001001 : alu_funct = 6'b100001;
            6'b001100 : alu_funct = 6'b100100;
            6'b001101 : alu_funct = 6'b100101;
            6'b001010 : alu_funct = 6'b101010;
            6'b001011 : alu_funct = 6'b101011;
            6'b001110 : alu_funct = 6'b100110;
            6'b10zzzz : alu_funct = 6'b100000;
            default : alu_funct = funct;
        endcase    
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [31:0] in1,
    input [31:0] in2,
    input [5:0] alu_funct,
    output reg [31:0] out,
    output reg overflow_exception,
    output reg zero_flag
    );
    
    always @(*) begin
        out = 32'b0;
        overflow_exception = 1'b0;
        case (alu_funct) 
            000000 : out = in1 << in2; // sll
            000010 : out = in1 >> in2; // srl
            000011 : out = (in1 >> in2)|(in1 << in2); // sra
            000100 : out = in1 << in2 [4:0]; //sllv
            000110 : out = in1 >> in2[4:0]; //srlv
            001000 : out = in1; //jump function, needs to go to PC
            001001 : out = in1; // needs to go to PC, need to store updated PC value
            100000 : begin
                     {overflow_exception, out} = in1 + in2; 
                     // overflow_exception = ({32{1'b1}} - in1 <= in2) ? 1'b1 : 1'b0;
                     end //add
            100001 : {overflow_exception, out} = in1 + in2; //addu
            100010 : begin
                     {overflow_exception, out} = in1 - in2; 
                     //overflow_exception = ({32{1'b1}} - in1 > in2) ? 1'b1 : 1'b0;
                     end  //sub
            100011 : {overflow_exception, out} = in1 - in2; //subu
            100100 : out = in1&in2; //and
            100101 : out = in1|in2; //or
            100110 : out = in1^in2; //xor
            100111 : out = ~(in1|in2); //xnor
            101010 : out = (in1 < in2) ? 1 : 0; //set low
            101011 : out = (in1 < in2) ? 1 : 0; //set low unsigned      
            default : out = 32'bx;
        endcase
        
        zero_flag = (out == 32'b0) ? 1'b1: 1'b0;
    end
endmodule

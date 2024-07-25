`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.07.2024 16:12:37
// Design Name: 
// Module Name: tb_mips
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


module tb_mips();

    reg clk;
    reg reset;

    mips_top mips_dut(.clk(clk), .reset(reset));

    initial
	   forever #5 clk = ~clk;

    initial begin
	   clk = 0;
	   reset = 1;
	   #10 reset = 0;

	   #3000 $finish;

    end
    
endmodule

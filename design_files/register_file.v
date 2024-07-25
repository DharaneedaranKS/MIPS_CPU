`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
    input clk,
    input reset,
    input write_en,
    input [4:0] data_address1,
    input [4:0] data_address2,
    output reg [31:0] data_out1,
    output reg [31:0] data_out2,
    input [4:0] write_address,
    input [31:0] write_data,
    output reg access_error
    );
    
    reg [31:0] data_register [31:0];
    integer i;
    always @(posedge clk) begin
        access_error <= 1'b0;
        if (reset == 1) begin
            for (i=0; i<31; i=i+1) begin
                data_register[i] <= {32{1'b0}};
            end
            data_out1 <= {32{1'bx}};
            data_out2 <= {32{1'bx}};
        end
        
        else begin
            if ((data_address1==5'b0)|(data_address2==5'b0))
                access_error <= 1'b1;
            else begin 
                data_out1 <= data_register[data_address1];
                data_out2 <= data_register[data_address2];
                if (write_en)
                    data_register[write_address] <= write_data;
                else
                    data_register[write_address] <= data_register[write_address];
            end
        end 
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input clk,
    input reset,
    output [5:0] opcode,
    input regWrite,
    input memWrite,
    output overflow_error,
    output reg_access
    );
    
    wire zero;
    wire [4:0] alu_funct;
    wire [5:0] address;
    reg [7:0] data_addr_in, data_addr_wr;
    reg [5:0] prev_address, rs_add, rd_add, rt_add, shamt, funct;
    reg [15:0] imm;
    reg [25:0] jump_value;
    reg [31:0] rd, hi, lo;
    wire [31:0] instruction, a, b, rs, rt, write_data, res, memdata;
    
    pc program_counter (.reset(reset), .address(prev_address), .next_address(address));
    
    instructions_memory instruction_memory (.address(address), .instruction(instruction));
    
    assign opcode = instruction [31:26];
    
    always @(posedge clk) begin
        prev_address <= (((opcode ==  6'b000100)&(rs == rt)) | ((opcode ==  6'b000101)&(rs != rt))) ? address + {{16{imm[15]}}, imm} : address ;
    end
   
   // Instruction Decoder
   
   always @(*) begin
        rs_add = 5'b0;
        rd_add = 5'b0;
        rt_add = 5'b0;
        shamt = 5'b0;
        funct = 5'b0;
        imm = 16'b0;
        jump_value = 26'b0;
        casez (opcode) 
            6'b000000 : begin    
                        rs_add = instruction [25:21];
                         rt_add = instruction [20:16];
                         shamt = instruction [10:5];
                         funct = instruction [4:0];
                        // for JALR (R-type function), need to store PC in $ra register
                         if (funct == 5'b01001) begin 
                          rd_add = 5'b11111;
                         end
                         else 
                            rd_add = instruction [15:11];
                         end
            6'b00010z : begin  //branch format instruction
                        rs_add = instruction [25:21];
                        rt_add = instruction [20:16];
                        imm = instruction [15:0];
                        end
            6'b00001z : begin
                        jump_value = instruction[25:0];
                        end
            6'b001zzz : begin  //I format instruction
                        rs_add = instruction [25:21];
                        rt_add = instruction [20:16];
                        imm = instruction [15:0];
                        end
            // TO DO : Check whether the opcode for I are the only ones from 0x20 - 0x2b
            6'b10zzzz : begin // I format instruction
                        rs_add = instruction [25:21];
                        rt_add = instruction [20:16];
                        imm = instruction [15:0];
                        end
            default : rs_add = 5'bx;
             
        endcase
        
   end
    
    register_file register_file(.clk(clk), .reset(reset), .write_en(regWrite), .data_address1(rs_add), .data_address2(rt_add), .data_out1(rs), .data_out2(rt), .write_address(rd_add), .write_data(rd), .access_error(reg_access));
    
    
    alu_control alu_control(.opcode(opcode), .funct(funct), .rs(rs), .rd(rd), .shamt(shamt), .imm(imm), .a(a), .b(b), .alu_funct(alu_funct));
    
    alu alu1(.in1(a), .in2(b), .out(res), .alu_funct(alu_funct), .overflow_exception(overflow_error), .zero_flag(zero));
    
    always @(*) begin
        
        data_addr_in = 8'bx;
        data_addr_wr = 8'bx;
        if ((opcode == 6'b0) & (funct != 5'b01001)) begin
            rd = res;
        end
        
        else if ((opcode == 6'b0) & (funct != 5'b01001)) 
            rd = address + 1;
        
        else if (opcode[5:3] == 3'b100) begin
            // TODO : expand this or paramterise 
            data_addr_in = res[7:0];
            // Different Load Instruction cases 
            case (opcode [2:0]) 
                3'b000 : rd = {{24{memdata[7]}}, memdata[7:0]}; // lb
                3'b100 : rd = {{24{1'b0}}, memdata[7:0]}; // lbu
                3'b001 : rd = {{16{memdata[15]}}, memdata[15:0]}; //lh
                3'b101 : rd = {{16{1'b0}}, memdata[15:0]}; // lhu
                3'b011 : rd = memdata; // lw
                default : rd = memdata;
            endcase
        end
        
        else if (opcode[5:3] == 3'b101) begin
            // TODO : expand this or paramterise
            data_addr_wr = res[7:0];
            // Different Store Instruction cases 
            
        end    
        
        else begin
            rd = 32'bx;
        end
    end
    
    data_memory data_memory(.clk(clk), .data_addr_in(data_addr_in), .data_in(rt), .data_addr_wr(data_addr_wr), .m_wr(memWrite), .data_out(memdata));
    
endmodule

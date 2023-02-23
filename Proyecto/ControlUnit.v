`include "MemoriaRam.v"
`include "PipelinedRegisters.v"
`include "Components.v"

//Control Unit
module Control_Unit(
    output reg [3:0] ID_ALU_op,
    output reg ID_shift_imm,
               ID_load_instr,
               ID_RF_enable,
               ID_B_instr,
               ID_BL_instr,
               ID_R_W_enable,
               ID_EN_MEM,
               ALU_flags,
    output reg [1:0] size,
    input [31:0] datain
);

always@(datain) begin

if(datain != 32'b0) begin    // Checks for Nop
        // begin
        //27-25 bit cases
        case(datain[27:25])
            3'b000: //data processing
                if(datain[4] && datain[7]) begin// if true - Extra load/store
                    ID_shift_imm <= 1'b0;
                    ID_ALU_op <= datain[24:21] ;
                    ID_load_instr <= datain[20];
                    ID_RF_enable <= 1'b1;
                    ID_B_instr <= 1'b0;
                    ID_BL_instr <= 1'b0;
                    ID_R_W_enable <= 1'b0;
                    size <= 2'b00;
                    ALU_flags <= datain[20];   
                    ID_EN_MEM <= 1'b0;
                end
                else 
                begin
                    if(datain[4])
                        ID_shift_imm <= 1'b0;
                    else
                        ID_shift_imm <= 1'b1;
                        ID_ALU_op <= datain[24:21] ;
                        ID_load_instr <= 1'b0;
                        ID_RF_enable <= 1'b1;
                        ID_B_instr <= 1'b0;
                        ID_BL_instr <= 1'b0;
                        ID_R_W_enable <= 1'b0;
                        size <= 2'b00;
                        ALU_flags <= datain[20];
                        ID_EN_MEM <= 1'b0;
                end 
            3'b001: begin //data processing inmmediate
                ID_shift_imm <= 1'b0;
                ID_ALU_op <= datain[24:21] ;
                ID_load_instr <= 1'b0;
                if(datain[20])
                    ID_RF_enable <= 1'b1;
                else
                    ID_RF_enable <= 1'b1;
                ID_B_instr <= 1'b0;
                ID_BL_instr <= 1'b0;
                ID_R_W_enable <= 1'b0;
                size <= 2'b00;
                ID_EN_MEM <= 1'b0;
                ALU_flags <= datain[20];
            end 

            3'b010: begin //load/store immediate offset
                ID_shift_imm <= 1'b0;
                ID_ALU_op <= 4'b0100;
                if(datain[20])
                    ID_load_instr <= 1'b1;
                else
                    ID_load_instr <= 1'b0;
                ID_RF_enable <= 1'b0;
                ID_B_instr <= 1'b0;
                ID_BL_instr <= 1'b0;
                ID_R_W_enable <= 1'b1;
                if(datain[22])
                    size <= 2'b01;
                else 
                    size <= 2'b00;
                ID_EN_MEM <= 1'b1;
                ALU_flags <= 1'b0;
            end 

            3'b011: begin //load/store register offset
                ID_shift_imm <= 1'b0;
                ID_ALU_op <= 4'b0100;
                if(datain[20])
                    ID_load_instr <= 1'b1;
                else
                    ID_load_instr <= 1'b0;
                ID_RF_enable <= 1'b1;
                ID_B_instr <= 1'b0;
                ID_BL_instr <= 1'b0;
                ID_R_W_enable <= 1'b1;
                if(datain[22])
                    size <= 2'b01;
                else 
                    size <= 2'b00;
                ALU_flags <= 1'b0;
                ID_EN_MEM <= 1'b1;
            end 

            3'b100: begin //load/store multiple
                ID_shift_imm <= 1'b0;
                ID_ALU_op <= 4'b0100;
                if(datain[20])
                    ID_load_instr <= 1'b1;
                else
                    ID_load_instr <= 1'b0;
                ID_RF_enable <= 1'b1;
                ID_B_instr <= 1'b0;
                ID_BL_instr <= 1'b0;
                ID_R_W_enable <= 1'b1;
                size <= 2'b00;
                ALU_flags <= 1'b0;
                ID_EN_MEM <= 1'b0;
            end 

            3'b101: begin //branch/branch and link
                ID_shift_imm <= 1'b0;
                if(datain[20])
                    ID_ALU_op <= 4'b0000;
                else 
                    ID_ALU_op <= 4'b0100;
                ID_load_instr <= 1'b0;
                ID_RF_enable <= 1'b0;
                ID_B_instr <= 1'b1;
                ID_BL_instr <= datain[24];
                ID_R_W_enable <= 1'b0;
                size <= 2'b00;
                ALU_flags <= 1'b0;
                ID_EN_MEM <= 1'b0;
            end

        endcase
        //     $display("ID_load_instr %b", ID_load_instr);
        // end
    end // if end
    else begin // Nop           
        ID_shift_imm <= 1'b0;
        ID_ALU_op <= 4'b0000;
        ID_load_instr <= 1'b0;
        ID_RF_enable <= 1'b0;
        ID_B_instr <= 1'b0;
        ID_BL_instr <= 1'b0;
        ID_R_W_enable <= 1'b0;
        size <= 2'b00;
        ALU_flags <= 1'b0;
        ID_EN_MEM <= 1'b0;
        end
    end
endmodule

//Multiplexer that controls if a NOP has ocurred
module Mux7to7(
    output reg [3:0] ID_ALU_op_out,
    output reg [1:0] ID_size_out,
    output reg ID_shift_imm_out,
               ID_load_instr_out,
               ID_RF_enable_out,
               ID_EN_MEM_out, 
               ID_RW_enable_out,
               ALU_flags_out,           
    input [3:0] ID_ALU_op,
    input [1:0] ID_size_in,
    input ID_shift_imm,
          ID_load_instr,
          ID_RF_enable,
          ID_EN_MEM_in,
          ID_RW_enable,
          ALU_flags_int,
          S);
    
    always@(S, ID_shift_imm, ID_ALU_op, ID_load_instr, ID_RF_enable, ID_size_in, ID_EN_MEM_in, ID_RW_enable, ALU_flags_int)

    case(S)
        1'b0: begin
            ID_shift_imm_out <= ID_shift_imm;
            ID_ALU_op_out <= ID_ALU_op;
            ID_load_instr_out <= ID_load_instr;
            ID_load_instr_out <= ID_load_instr;
            ID_RF_enable_out <= ID_RF_enable;
            ID_size_out <= ID_size_in;
            ID_EN_MEM_out <= ID_EN_MEM_in;
            ID_RW_enable_out <= ID_RW_enable;
            ALU_flags_out <= ALU_flags_int;
        end
        1'b1: begin
            ID_shift_imm_out <= 1'b0;
            ID_ALU_op_out <= 4'b0000;
            ID_load_instr_out <= 1'b0;
            ID_RF_enable_out <= 1'b0;
            ID_size_out <= 2'b00;
            ID_EN_MEM_out <= 1'b0;
            ID_RW_enable_out <= 1'b0;
            ALU_flags_out <= 1'b0;
        end
    endcase
endmodule
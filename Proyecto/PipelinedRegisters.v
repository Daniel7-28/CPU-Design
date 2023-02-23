//Pipelined Register IF/ID
module Pipelined_Register_IF_ID_F4(output reg [31:0] dataout, next_pc_output, input [31:0] datain, next_pc_input, input Clk, R, LE);

    always@(posedge Clk) 
    if (R) begin
            dataout <= 32'b00000000000000000000000000000000;
            next_pc_output <= 32'b00000000000000000000000000000000;
        end
        else if(LE) begin
            dataout <= datain;
            next_pc_output <= next_pc_input;
        end
endmodule

//Pipelined Register ID/EX
module Pipelined_Register_ID_EX_F4(
    output reg [31:0] mux_up_output,
                      mux_center_output,
                      mux_down_output,
    output reg [11:0] I_11_0_output,
    output reg [3:0] EX_ALU_op_out,
                     I_15_12_output,
    output reg [2:0] EX_27_25_output,
    output reg [1:0] EX_size_out,
    output reg EX_shift_imm_out, 
           EX_load_instr_out, 
           EX_RF_enable_out,
           EX_R_W_out,
           EX_EN_MEM_out,
           EX_ALU_flags_out, 
    input [31:0] mux_up_input,
                 mux_center_input,
                 mux_down_input,
    input [11:0] I_11_0_input,
    input [3:0] ID_ALU_op_in,
                I_15_12_input,
    input [2:0] ID_27_25_input,
    input [1:0] ID_size_in,
    input ID_shift_imm_in, 
          ID_load_instr_in, 
          ID_RF_enable_in,
          ID_R_W_in,
          ID_EN_MEM_in,
          ID_ALU_flags_in, 
          ID_EX_Clk, 
          ID_EX_R);

    always@(posedge ID_EX_Clk) begin

    if(ID_EX_R) begin
        mux_up_output <= 32'b00000000000000000000000000000000;
        mux_center_output <= 32'b00000000000000000000000000000000;
        mux_down_output <= 32'b00000000000000000000000000000000;
        I_11_0_output <= 12'b000000000000;
        I_15_12_output <= 4'b0000;
        EX_27_25_output <= 4'b0000;
        EX_ALU_op_out <= 4'b0000;
        EX_shift_imm_out <= 1'b0; 
        EX_load_instr_out <= 1'b0;
        EX_RF_enable_out <= 1'b0;
        EX_size_out <= 2'b00;
        EX_R_W_out <= 1'b0;
        EX_EN_MEM_out <= 1'b0;
        EX_ALU_flags_out <= 1'b0;
        end
    else begin
        mux_up_output <=mux_up_input;
        mux_center_output <= mux_center_input;
        mux_down_output <= mux_down_input;
        I_11_0_output <= I_11_0_input;
        I_15_12_output <= I_15_12_input;
        EX_27_25_output <= ID_27_25_input;
        EX_ALU_op_out <= ID_ALU_op_in;
        EX_shift_imm_out <= ID_shift_imm_in; 
        EX_load_instr_out <= ID_load_instr_in;
        EX_RF_enable_out <= ID_RF_enable_in;
        EX_size_out <= ID_size_in;
        EX_R_W_out <= ID_R_W_in;
        EX_EN_MEM_out <= ID_EN_MEM_in;
        EX_ALU_flags_out <= ID_ALU_flags_in;
        end
    end
endmodule

//Pipelined Register EX/MEM
module Pipelined_Register_EX_MEM_F4(
    output reg[31:0] MEM_mux_down_output,
                     MEM_ALU_out_output,
    output reg[3:0] MEM_I15_12_output,
    output reg[1:0] MEM_size_out,
    output reg MEM_load_instr_out, 
           MEM_RW_out,
           MEM_RF_enable_out, 
           MEM_EN_MEM_out,
    input [31:0] EX_mux_down_input,
                 MEM_ALU_out_input,
    input [3:0] EX_I15_12_input,
    input [1:0] EX_size_in,
    input  EX_load_instr_in,
           EX_RW_in, 
           EX_RF_enable_in, 
           EX_EN_MEM_in,
           Clk, 
           R);

    always@(posedge Clk) begin

        if(R) begin
            MEM_mux_down_output <= 32'b00000000000000000000000000000000;
            MEM_ALU_out_output <= 32'b00000000000000000000000000000000;
            MEM_I15_12_output <= 4'b0000;
            MEM_load_instr_out <= 1'b0;
            MEM_RF_enable_out <= 1'b0;
            MEM_size_out <= 2'b00;
            MEM_EN_MEM_out <= 1'b0;
            MEM_RW_out <= 1'b0;
        end
        else begin
            MEM_mux_down_output <= EX_mux_down_input;
            MEM_ALU_out_output <= MEM_ALU_out_input;
            MEM_I15_12_output <= EX_I15_12_input;
            MEM_load_instr_out <= EX_load_instr_in;
            MEM_RF_enable_out <= EX_RF_enable_in;
            MEM_size_out <= EX_size_in;
            MEM_EN_MEM_out <= EX_EN_MEM_in;
            MEM_RW_out <= EX_RW_in;
        end
    end
endmodule

//Pipelined Register MEM/WB
module Pipelined_Register_MEM_WB_F4(
    output reg[31:0] Mem_output_data_mem_out,
                     MEM_out_ALU_output,
    output reg[3:0] MEM_I_15_12_output,
    output reg WB_load_instr_out, 
           WB_RF_enable_out, 
    input [31:0] Mem_input_data_mem_out,
                 Mem_in_address,
    input [3:0] MEM_I_15_12_input,
    input  MEM_load_instr_in, 
           MEM_RF_enable_in, 
           MEM_WB_Clk, 
           MEM_WB_R);

    always@(posedge MEM_WB_Clk) begin

        if(MEM_WB_R) begin
                Mem_output_data_mem_out <= 32'b00000000000000000000000000000000;
                MEM_out_ALU_output <= 32'b00000000000000000000000000000000;
                MEM_I_15_12_output <= 4'b0000;
                WB_load_instr_out <= 1'b0;
                WB_RF_enable_out <= 1'b0;
            end
        else
            begin
                Mem_output_data_mem_out <= Mem_input_data_mem_out;
                MEM_out_ALU_output <= Mem_in_address;
                MEM_I_15_12_output <= MEM_I_15_12_input;
                WB_load_instr_out <= MEM_load_instr_in;
                WB_RF_enable_out <= MEM_RF_enable_in;
            end
    end
endmodule


//PIPELINED REGISTERS FOR FASE 3
// Pipelined Register IF/ID
module Pipelined_Register_IF_ID_F3(output reg [31:0] dataout, input [31:0] datain, input IF_ID_Clk, IF_ID_R);

    always@(posedge IF_ID_Clk) 
        if (IF_ID_R) 
            dataout <= 32'b00000000000000000000000000000000;
        else 
            dataout <= datain;
endmodule

//Pipelined Register ID/EX
module Pipelined_Register_ID_EX_F3(
    output reg [3:0] EX_ALU_op_out, 
    output reg [1:0] EX_size_out,
    output reg EX_shift_imm_out, 
           EX_load_instr_out, 
           EX_RF_enable_out,
           EX_R_W_out,
           EX_EN_MEM_out,
           EX_ALU_flags_out, 
    input [3:0] ID_ALU_op_in,
    input [1:0] ID_size_in,
    input ID_shift_imm_in, 
          ID_load_instr_in, 
          ID_RF_enable_in,
          ID_R_W_in,
          ID_EN_MEM_in,
          ID_ALU_flags_in, 
          ID_EX_Clk, 
          ID_EX_R);

    always@(posedge ID_EX_Clk) begin

    if(ID_EX_R) begin
        EX_ALU_op_out <= 4'b0000;
        EX_shift_imm_out <= 1'b0; 
        EX_load_instr_out <= 1'b0;
        EX_RF_enable_out <= 1'b0;
        EX_size_out <= 2'b00;
        EX_R_W_out <= 1'b0;
        EX_EN_MEM_out <= 1'b0;
        EX_ALU_flags_out <= 1'b0;
        end
    else begin
        EX_ALU_op_out <= ID_ALU_op_in;
        EX_shift_imm_out <= ID_shift_imm_in; 
        EX_load_instr_out <= ID_load_instr_in;
        EX_RF_enable_out <= ID_RF_enable_in;
        EX_size_out <= ID_size_in;
        EX_R_W_out <= ID_R_W_in;
        EX_EN_MEM_out <= ID_EN_MEM_in;
        EX_ALU_flags_out <= ID_ALU_flags_in;
        end
    end
endmodule

//Pipelined Register EX/MEM
module Pipelined_Register_EX_MEM_F3(
    output reg[1:0] MEM_size_out,
    output reg MEM_load_instr_out, 
           MEM_RW_out,
           MEM_RF_enable_out, 
           MEM_EN_MEM_out,
    input [1:0] EX_size_in,
    input  EX_load_instr_in,
           EX_RW_in, 
           EX_RF_enable_in, 
           EX_EN_MEM_in,
           EX_MEM_Clk, 
           EX_MEM_R);

    always@(posedge EX_MEM_Clk) begin

        if(EX_MEM_R) begin
            MEM_load_instr_out <= 1'b0;
            MEM_RF_enable_out <= 1'b0;
            MEM_size_out <= 2'b00;
            MEM_EN_MEM_out <= 1'b0;
            MEM_RW_out <= 1'b0;
        end
        else begin
            MEM_load_instr_out <= EX_load_instr_in;
            MEM_RF_enable_out <= EX_RF_enable_in;
            MEM_size_out <= EX_size_in;
            MEM_EN_MEM_out <= EX_EN_MEM_in;
            MEM_RW_out <= EX_RW_in;
        end
    end
endmodule

//Pipelined Register MEM/WB
module Pipelined_Register_MEM_WB_F3(
    output reg WB_load_instr_out, 
           WB_RF_enable_out, 
    input  MEM_load_instr_in, 
           MEM_RF_enable_in, 
           MEM_WB_Clk, 
           MEM_WB_R);

    always@(posedge MEM_WB_Clk) begin

        if(MEM_WB_R) begin
                WB_load_instr_out <= 1'b0;
                WB_RF_enable_out <= 1'b0;
            end
        else
            begin
                WB_load_instr_out <= MEM_load_instr_in;
                WB_RF_enable_out <= MEM_RF_enable_in;
            end
    end
endmodule
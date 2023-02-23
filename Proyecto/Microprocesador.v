`include "ALU&Shifter-SignExtender.v"
`include "ControlUnit.v"
`include "HazardForwardingUnit.v"
`include "RegisterFile.v"


module microprocesador;
wire [31:0] IF_mux_output, 
            adder_plus_four_output, 
            adder_output,
            pc_out,
            instr_mem_output,
            IF_ID_pipreg_output,
            next_pc,
            PA, 
            PB, 
            PC, 
            PW,
            WB_MUX_out,
            MEM_MUX_output,
            ALU_out,
            ID_MUX_A_out,
            ID_MUX_B_out,
            ID_MUX_C_out,
            MEM_mux_down_output,
            mux_center_output,
            mux_down_output,
            EX_MUX_output,
            mux_up_output,
            EX_Shifter_out,
            MEM_ALU_out_output,
            EX_ALU_out,
            data_mem_out,
            Mem_output_data_mem_out,
            Mem_out_address,
            WB_output_data_mem_out,
            WB_out_ALU_output;                         
wire [23:0] fourXse_output;
wire [11:0] I_11_0_output;
wire [3:0]  MEM_I_15_12_output,   
            CU_ALU_op, 
            ID_ALU_op,  
            I_15_12_output,
            EX_ALU_op,
            IR,  
            WB_I_15_12_output,
            mux_4bits_out,
            Flag_output,
            B;
wire [2:0] shift,
           EX_27_25;
wire [1:0] CU_size,
           ID_size,
           EX_size,
           MEM_size,
           Rm,
           Rn,
           Rd;
wire condition_handler_output,
     LE_IF_ID,
     LE_PC,
     BL_output, 
     WB_RF_enable_out,
     CU_ALU_flags,
     CU_EN_MEM,
     CU_R_W_enable,
     CU_BL_instr,
     CU_B_instr,
     CU_RF_enable, 
     CU_load_instr, 
     CU_shift_imm, 
     Nop_insertion_selection,
     ID_ALU_flags,
     ID_RW_enable, 
     ID_EN_MEM, 
     ID_RF_enable, 
     ID_load_instr, 
     ID_shift_imm,   
     EX_ALU_flags, 
     EX_EN_MEM,
     EX_RF_enable,
     EX_R_W,
     EX_load_instr, 
     EX_shift_imm, 
     EX_RW, 
     target_address, 
     condition,
     c, z, n, v, S,
     carryIn,
     carry,
     c_out, z_out, n_out, v_out,
     Cond,  
     MEM_RF_enable, 
     WB_RF_enable, 
     EX_load_instruction, 
     EX_store_instruction,
     MEM_load_instr, 
     MEM_RW,
     MEM_EN_MEM_out,
     WB_load_instr_out, 
     MEM_load_instr_in,
     MEM_RF_enable_in,
     conditionHandler_out,
     OR_out, NOR_out;
reg [31:0] address, file, scan, data;
reg   Clk, R;

//IF Components
OR OR1(OR_out, conditionHandler_out, R);
Mux2x1 IF_MUX(IF_mux_output, adder_plus_four_output, adder_output, conditionHandler_out);
Adderx4 IF_ADDER(adder_plus_four_output, pc_out);
Instr_Mem IF_Instr_mem(instr_mem_output, pc_out);

initial begin
        file = $fopen("input.txt", "r");
        address = 32'b00000000000000000000000000000000;
        while(!$feof(file)) begin
            scan = $fscanf(file, "%b", data);
            data_mem.Memory[address] = data;
            address = address + 1;
        end
        $fclose(file);
        address = 32'b00000000000000000000000000000000;
    end

  initial begin
        file = $fopen("input.txt", "r");
        address = 32'b00000000000000000000000000000000;
        while(!$feof(file)) begin
            scan = $fscanf(file, "%b", data);
            IF_Instr_mem.Memory[address] = data;
            address = address + 1;
        end
        $fclose(file);
        address = 32'b00000000000000000000000000000000;
    end  

Pipelined_Register_IF_ID_F4 IFID(IF_ID_pipreg_output, next_pc, instr_mem_output, adder_plus_four_output, Clk, OR_out, LE_IF_ID);

//ID Components
Register_File ID_RF(PA, PB, PC, WB_MUX_out, IF_ID_pipreg_output[19:16], IF_ID_pipreg_output[3:0], IF_ID_pipreg_output[15:12], MEM_I_15_12_output, pc_out, IF_mux_output, LE_PC,  next_pc, BL_output, WB_RF_enable_out, Clk, R);
x4SE ID_x4SE(fourXse_output, IF_ID_pipreg_output[23:0]);
Adder ID_Adder(adder_output, fourXse_output, next_pc);
Mux4x1 ID_MUX_A(ID_MUX_A_out, PA, EX_ALU_out, MEM_MUX_output, WB_MUX_out, Rn);
Mux4x1 ID_MUX_B(ID_MUX_B_out, PB, EX_ALU_out, MEM_MUX_output, WB_MUX_out, Rm);
Mux4x1 ID_MUX_C(ID_MUX_C_out, PC, EX_ALU_out, MEM_MUX_output, WB_MUX_out, Rd);
Control_Unit ID_CU(CU_ALU_op, CU_shift_imm, CU_load_instr, CU_RF_enable, CU_B_instr, CU_BL_instr, CU_R_W_enable, CU_EN_MEM, CU_ALU_flags, CU_size, IF_ID_pipreg_output);
NOR NOR1(NOR_out, Cond, Nop_insertion_selection);
Mux7to7 ID_MUX7x7(ID_ALU_op, ID_size, ID_shift_imm, ID_load_instr, ID_RF_enable, ID_EN_MEM, ID_RW_enable, ID_ALU_flags, CU_ALU_op, CU_size, CU_shift_imm, CU_load_instr, CU_RF_enable, CU_EN_MEM, CU_R_W_enable, CU_ALU_flags, NOR_out);
Pipelined_Register_ID_EX_F4 IDEX(
    mux_up_output,
    mux_center_output,
    mux_down_output,
    I_11_0_output,
    EX_ALU_op,
    I_15_12_output,
    EX_27_25,
    EX_size,
    EX_shift_imm, 
    EX_load_instr, 
    EX_RF_enable,
    EX_R_W,
    EX_EN_MEM,
    EX_ALU_flags, 
    ID_MUX_A_out,
    ID_MUX_B_out,
    ID_MUX_C_out,
    IF_ID_pipreg_output[11:0],
    ID_ALU_op,
    IF_ID_pipreg_output[15:12],
    IF_ID_pipreg_output[27:25],
    ID_size,
    ID_shift_imm, 
    ID_load_instr, 
    ID_RF_enable,
    ID_RW_enable,
    ID_EN_MEM,
    ID_ALU_flags, 
    Clk, 
    R);


//EX Components
ConditionHandler EX_condHand(conditionHandler_out, BL_output,  CU_B_instr, CU_BL_instr, Cond);
ALU EX_ALU( mux_up_output, EX_Shifter_out, EX_ALU_op, c_out,  ID_ALU_flags, EX_ALU_out, c, z, n, v);
Shifter EX_Shifter( mux_center_output,  I_11_0_output, EX_27_25, EX_Shifter_out, carry);
FlagRegister EX_Flag_Reg(c_out, z_out, n_out, v_out, c, z, n, v, EX_ALU_flags, R, Clk);
assign Flag_output = {c_out, z_out, n_out, v_out};
assign B = {c, z, n, v};
Mux2x1_4bits MUX2x1_4bits(mux_4bits_out, Flag_output, B, EX_ALU_flags);
ConditionTester EX_Cond_Tester(Cond, mux_4bits_out[31], mux_4bits_out[30], mux_4bits_out[29], mux_4bits_out[28],IF_ID_pipreg_output[31:28]);
Hazards_Forwarding_Unit EX_HFU(Rn, Rm, Rd, Nop_insertion_selection, LE_IF_ID, LE_PC, MEM_I_15_12_output,  WB_I_15_12_output, IF_ID_pipreg_output[19:16], IF_ID_pipreg_output[3:0],  IF_ID_pipreg_output[15:12], I_15_12_output, EX_RF_enable, MEM_RF_enable, WB_RF_enable, EX_load_instruction);
Mux2x1 EX_MUX_2X1(EX_MUX_output, mux_center_output, EX_Shifter_out, carry);
Pipelined_Register_EX_MEM_F4 EXMEM(
    MEM_mux_down_output,
    MEM_ALU_out_output,
    MEM_I_15_12_output,
    MEM_size,
    MEM_load_instr, 
    MEM_RW,
    MEM_RF_enable, 
    MEM_EN_MEM_out,
    mux_down_output,
    EX_ALU_out,
    I_15_12_output,
    EX_size,
    EX_load_instr,
    EX_R_W, 
    EX_RF_enable, 
    EX_EN_MEM,
    Clk, 
    R);


//MEM Components
data_memory data_mem(data_mem_out, MEM_mux_down_output, MEM_ALU_out_output, MEM_size, MEM_EN_MEM_out, MEM_RW);
Mux2x1 MEM_MUX(MEM_MUX_output, MEM_ALU_out_output, data_mem_out,MEM_load_instr);
Pipelined_Register_MEM_WB_F4 MEMWB(
    WB_output_data_mem_out,
    WB_out_ALU_output,
    WB_I_15_12_output,
    WB_load_instr_out, 
    WB_RF_enable_out, 
    data_mem_out,
    MEM_ALU_out_output,
    MEM_I_15_12_output,
    MEM_load_instr, 
    MEM_RF_enable, 
    Clk, 
    R);


//WB Components
Mux2x1 WB_MUX(WB_MUX_out, WB_out_ALU_output, WB_output_data_mem_out,  WB_load_instr_out);


//-----------------------------------------------TEST----------------------------------------------------    
    initial begin
        Clk = 1'b0;                                     //Clock
        R = 1'b1;                                       //Reset
        #1 Clk = 1'b1;
        #1 Clk = 1'b0;
        R = 1'b0;
        repeat(100) begin
            #5;
            Clk = ~Clk;
        end
    end

    initial begin
    #1;
    $display("         PC      Address       R1         R2         R3         R5                  Time\n");
    $monitor("%d %d %d %d %d %d %d", pc_out, MEM_ALU_out_output, ID_RF.R1, ID_RF.R2, ID_RF.R3, ID_RF.R5, $time);
    // $monitor("PC %d WB_load_instr %b A %d B %d Mux_out %d address %d data %d size %b RW %b EN_MEM %b Register %d enable %b", pc_out, WB_load_instr_out, WB_out_ALU_output, WB_output_data_mem_out,WB_MUX_out, MEM_ALU_out_output, data_mem_out, MEM_size, MEM_RW, MEM_EN_MEM_out, WB_I_15_12_output, WB_RF_enable_out);
    // $monitor("PC %d ALU %d A %d B %d SA %b SB %b CU_RF_enable %b ID_RF_enable %d NOR_out %b", pc_out, EX_ALU_out, mux_up_output, EX_Shifter_out, Rn, Rm, EX_RF_enable, ID_RF_enable, NOR_out);
    
    // $display("        PC Datain                           IF/ID data                            ID_shift_imm    ID_ALU_op    ID_load_instr    ID_RF_enable    ID_B_instr    ID_BL_instr    ID_R/W_enable    ID_size    ID_enable_MEM    ID_ALU_flags    ID/EX    EX_shift_imm    EX_ALU_op    EX_load_instr    EX_RF_enable    EX_R/W_enable    EX_size    EX_enable_MEM    EX_ALU_flags    EX/MEM    MEM_load_instr    MEM_RF_enable    MEM_R/W_enable    MEM_size    MEM_enable_MEM    MEM/WB    WB_load_instr    WB_RF_enable    R LE  S                 Time\n");
    // $monitor("%d %b       %b       %b          %b             %b                %b             %b             %b               %b              %b           %b                 %b                       %b             %b            %b              %b              %b               %b            %b               %b                           %b                %b                %b               %b             %b                           %b               %b          %b  %b  %b%d%d\n", pc_out, instr_mem_output, IF_ID_pipreg_output, ID_shift_imm, ID_ALU_op, ID_load_instr, ID_RF_enable, CU_B_instr, CU_BL_instr, ID_RW_enable, ID_size, ID_EN_MEM, ID_ALU_flags, EX_shift_imm, EX_ALU_op, EX_load_instr, EX_RF_enable, EX_R_W, EX_size,EX_EN_MEM, EX_ALU_flags, MEM_load_instr, MEM_RF_enable, MEM_RW, MEM_size, MEM_EN_MEM_out, WB_load_instr_out, WB_RF_enable_out, R, LE_IF_ID, NOR_out, Clk, $time);
    // $monitor("%d %d %d",pc_out, adder_plus_four_output, IF_mux_output); 
    end

    // initial begin 
    //     #400 begin 
    //             $display("\n            Content                     Address\n");
    //         repeat(12)begin 
    //             $display("%b %b %b %b %d", data_mem.Memory[address],data_mem.Memory[address+1],data_mem.Memory[address+2],data_mem.Memory[address+3],address); 
    //             address=address+4; 
    //         end 
    //         $finish; 
    //     end
    // end
endmodule
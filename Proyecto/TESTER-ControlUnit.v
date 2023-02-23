`include "ControlUnit.v"
//TESTER
module Control_Unit_Tester();
    wire [31:0] pc_out,
         plus, 
         dataoutmem,
         dataout;
    wire [3:0] ID_ALU_op,
         ID_ALU_op_out,
         EX_ALU_op;
    wire ID_shift_imm,
         ID_shift_imm_out,
         EX_shift_imm,
         ID_load_instr,
         ID_load_instr_out,
         EX_load_instr,
         MEM_load_instr,
         WB_load_instr,
         ID_RF_enable,
         ID_RF_enable_out,
         EX_RF_enable,
         MEM_RF_enable,
         WB_RF_enable,
         ID_B_instr,
         ID_BL_instr,
         ID_R_W_enable,
         ID_ALU_flags_out,
         ALU_flags;
    wire [1:0] ID_size_out, 
         ID_size_in, 
         EX_size_out,
         MEM_size_out;
    reg  [31:0] address, 
         data,
         file,
         scan;
    reg R, LE, Clk, S;
    

    PC_Register PC(pc_out,plus,R, LE, Clk);
   
    Adderx4 A(plus, pc_out);
   
    Instr_Mem ram(dataoutmem, pc_out);
    
    initial begin
        file = $fopen("input.txt", "r");
        address = 32'b00000000000000000000000000000000;
        while(!$feof(file)) begin
            scan = $fscanf(file, "%b", data);
            ram.Memory[address] = data;
            address = address + 1;
        end
        $fclose(file);
        address = 32'b00000000000000000000000000000000;
    end
    
    Pipelined_Register_IF_ID_F3 IF_ID(dataout,dataoutmem, Clk, R);
   
    Control_Unit CUnit(ID_ALU_op, ID_shift_imm, ID_load_instr, ID_RF_enable, ID_B_instr, ID_BL_instr, ID_R_W_enable, ID_EN_MEM, ALU_flags, ID_size_in, dataout);
   
    Mux7to7 Multiplexer(ID_ALU_op_out, ID_size_out, ID_shift_imm_out, ID_load_instr_out, ID_RF_enable_out, ID_EN_MEM_out, ID_RW_enable_out, ID_ALU_flags_out, ID_ALU_op, ID_size_in, ID_shift_imm, ID_load_instr, ID_RF_enable, ID_EN_MEM, ID_R_W_enable, ALU_flags, S);
   
    Pipelined_Register_ID_EX_F3 ID_EX( EX_ALU_op, EX_size_out, EX_shift_imm, EX_load_instr, EX_RF_enable, EX_R_W, EX_EN_MEM, ALU_flags_output, ID_ALU_op_out, ID_size_out, ID_shift_imm_out, ID_load_instr_out, ID_RF_enable_out, ID_RW_enable_out, ID_EN_MEM_out, ID_ALU_flags_out, Clk, R);
    
    Pipelined_Register_EX_MEM_F3 EX_MEM( MEM_size_out, MEM_load_instr, MEM_RW, MEM_RF_enable, MEM_EN_MEM, EX_size_out, EX_load_instr, EX_R_W, EX_RF_enable, EX_EN_MEM, Clk, R);

    Pipelined_Register_MEM_WB_F3 MEM_WB( WB_load_instr, WB_RF_enable, MEM_load_instr, MEM_RF_enable, Clk, R);
     
    initial #20 $finish;
    initial begin
        Clk = 1'b0;                                     //Clock
        LE = 1'b0;                                      //Load Enable
        R = 1'b1;                                       //Reset
        S = 1'b0;
        repeat (18) #1 Clk = ~Clk;
    end
    
     initial fork
        #1 R = 1'b0;
        #1 LE = 1'b1;
     join

    initial begin
    $display("        PC Datain                           IF/ID data                            ID_shift_imm    ID_ALU_op    ID_load_instr    ID_RF_enable    ID_B_instr    ID_BL_instr    ID_R/W_enable    ID_size    ID_enable_MEM    ID_ALU_flags    ID/EX    EX_shift_imm    EX_ALU_op    EX_load_instr    EX_RF_enable    EX_R/W_enable    EX_size    EX_enable_MEM    EX_ALU_flags    EX/MEM    MEM_load_instr    MEM_RF_enable    MEM_R/W_enable    MEM_size    MEM_enable_MEM    MEM/WB    WB_load_instr    WB_RF_enable    R LE  S                 Time\n");
    $monitor("%d %b       %b       %b          %b             %b                %b             %b             %b               %b              %b           %b                 %b                       %b             %b            %b              %b              %b               %b            %b               %b                           %b                %b                %b               %b             %b                           %b               %b          %b  %b  %b%d\n", pc_out, dataoutmem, dataout, ID_shift_imm_out, ID_ALU_op_out, ID_load_instr_out, ID_RF_enable_out, ID_B_instr, ID_BL_instr, ID_RW_enable_out, ID_size_out, ID_EN_MEM_out, ID_ALU_flags_out, EX_shift_imm, EX_ALU_op, EX_load_instr, EX_RF_enable, EX_R_W, EX_size_out,EX_EN_MEM, ALU_flags_output, MEM_load_instr, MEM_RF_enable, MEM_RW, MEM_size_out, MEM_EN_MEM, WB_load_instr, WB_RF_enable, R, LE, S, $time);
    end
endmodule
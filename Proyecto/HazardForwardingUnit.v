/*  HAZARDS/FORWARDING UNIT IMPLEMENTATION */

module Hazards_Forwarding_Unit(
        output reg [1:0] Output_Rn, 
                         Output_Rm,
                         Output_Rd,
        output reg Nop_insertion_selection,
                   LE_IF_ID,
                   LE_PC, 
        input [3:0] MEM_Rd, 
                    WB_Rd, 
                    ID_Rn, 
                    ID_Rm,
                    ID_Rd,
                    EX_rd,
        input EX_RF_enable, 
              MEM_RF_enable, 
              WB_RF_enable, 
              EX_load_instruction
        );
        always@(*)
        begin
            // $display("Data Hazard %b %b %b", EX_RF_enable, ID_Rn, EX_rd);
        //Criteria forwarding for Rm
        if(EX_RF_enable && (ID_Rm == EX_rd))
            //then forward [EX_Rd] to ID stage
            Output_Rm = 2'b01;
        else if(MEM_RF_enable &&(ID_Rm == MEM_Rd))
            //then forward [MEM_Rd] to ID stage
            Output_Rm = 2'b10;
        else if(WB_RF_enable &&(ID_Rm == WB_Rd))
            //then forward [WB_Rd] to ID
            Output_Rm = 2'b11;
        else 
            Output_Rm = 2'b00;
        // $display("Output Rm %b", (Output_Rm));
        //Criteria forwarding for Rn
        if(EX_RF_enable &&(ID_Rn == EX_rd))
            //then forward [EX_Rd] to ID stage
            Output_Rn = 2'b01;
        else if(MEM_RF_enable &&(ID_Rn == MEM_Rd))
            //then forward [MEM_Rd] to ID stage
            Output_Rn = 2'b10;
        else if(WB_RF_enable &&(ID_Rn == WB_Rd))
            //then forward [WB_Rd] to ID
            Output_Rn = 2'b11;
        else 
            Output_Rn = 2'b00;   
            
            //Criteria forwarding for Ro
        if(EX_RF_enable && (ID_Rd == EX_rd))
            //then forward [EX_Rd] to ID stage
            Output_Rd = 2'b01;
        else if(MEM_RF_enable &&(ID_Rd == MEM_Rd))
            //then forward [MEM_Rd] to ID stage
            Output_Rd = 2'b10;
        else if(WB_RF_enable &&(ID_Rd == WB_Rd))
            //then forward [WB_Rd] to ID
            Output_Rd = 2'b11;
        else 
            Output_Rd = 2'b00;
            
        //Data Hazard by Load and Store Instruction
        if((EX_load_instruction) && ((ID_Rm == EX_rd) || (ID_Rn == EX_rd) || (ID_Rd == EX_rd))) begin
            Nop_insertion_selection = 1'b1;
            LE_IF_ID  = 1'b0; 
            LE_PC  = 1'b0;
        end
        else begin
            Nop_insertion_selection = 1'b0;
            LE_IF_ID  = 1'b1; 
            LE_PC  = 1'b1;
        end
        end
endmodule

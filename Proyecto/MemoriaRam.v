//Instruction memory
module Instr_Mem(output reg [31:0] Dataout,  input [31:0] Address);
    reg[7:0] Memory[0:255];
   
    always@(Address)
        if(Address % 4 == 0)
            Dataout <= {Memory[Address], Memory[Address + 1], Memory[Address + 2], Memory[Address + 3]};
        else
            Dataout <= Memory[Address];    
endmodule

//Data Memory
module data_memory(output reg[31:0] Dataout, input[31:0] data_input, input[31:0] Address, input [1:0] size, input en_mem, R_W_en);
    reg[7:0] Memory[0:255]; 
    
    always@(Dataout, Address, data_input, size, en_mem, R_W_en) 
        if(en_mem) begin
            case(size)
                2'b00: begin 
                    if(!R_W_en) begin 
                        Memory[Address] <= data_input[31:24];
                        Memory[Address + 1] <= data_input[23:16];
                        Memory[Address + 2] <= data_input[15:8]; 
                        Memory[Address + 3] <= data_input[7:0];  
                    end 
                    else 
                        Dataout = {Memory[Address], Memory[Address + 1], Memory[Address + 2], Memory[Address + 3]};          
                end
                2'b01: begin 
                    if(!R_W_en) 
                        Memory[Address] = data_input;
                     else  
                        Dataout = Memory[Address];
                end
                2'b10: begin 
                    if(!R_W_en) begin 
                        Memory[Address] = data_input[15:8]; 
                        Memory[Address + 1] = data_input[7:0]; 
                    end 
                    else  
                        Dataout = {Memory[Address+0], Memory[Address+1]};   
                end        
            endcase
        end 
        else 
            Dataout = 32'b00000000000000000000000000000000;
endmodule
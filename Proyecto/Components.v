//OR
module OR(output OR, input A, B);
    assign OR = A | B;
endmodule

//NOR
module NOR(output NOR, input A, B);
    assign NOR = !(A | B);
endmodule

//Program Counter Register
module PC_Register(output reg[31:0] pc_out, input [31:0] pc_in, input R, LE, Clk);
    always@(R, LE, posedge Clk) begin
        if(LE) pc_out <= pc_in;
        if(R) pc_out <= 32'b00000000000000000000000000000000;
    end
endmodule

//Adder that sum Program Counter + 4
module Adderx4(output reg [31:0] plus, input [31:0] pc);
    always@(pc)begin
        plus <= pc + 32'b00000000000000000000000000000100;
    // $display("ADDER %d", pc);
    end
endmodule

//Adder that sum 32 bits inputs
module Adder(output reg [31:0] ADD, input [23:0] A,input [31:0] B);
    always@(A, B)
        ADD <= A + B;
endmodule

//Multiplexer 2x1 with 4 bits inputs and output
module Mux2x1_4bits(output reg [3:0]Y, input [3:0] A, B, input S);
    always@(A, B, S)
    case(S)
        1'b0: Y <= A;
        1'b1: Y <= B;
    endcase
endmodule

//Multiplexer 2x1 with 32 bits inputs and output
module Mux2x1(output reg [31:0]Y, input [31:0] A, B, input S);
    always@(A, B, S)
    case(S)
        1'b0: Y <= A;
        1'b1: Y <= B;
    endcase
endmodule

//x4 SE
module x4SE(output reg [23:0] fourXse_output, input[23:0] fourXse_input);
    always@(fourXse_input)
    fourXse_output <= fourXse_input + 24'b000000000000000000000100; 
endmodule


//Multiplexer 4x1 with 32 bits inputs and output
module Mux4x1(output reg [31:0]Y, input [31:0] A, B, C, D, input [1:0]S);
    always@(A, B, C, D, S)
    case(S)
        2'b00: Y <= A;
        2'b01: Y <= B;
        2'b10: Y <= C;
        2'b11: Y <= D;
    endcase
endmodule

module ConditionHandler(output reg target_address, BL_register, input B, BL, condition);
    
    always@(B, BL, condition) begin 
        
        if(B && condition) begin
            target_address <= 1'b1;
            if(BL) 
                BL_register <= 1'b1;
        end
        else begin
            target_address <= 1'b0;
            BL_register <= 1'b0;
        end
    end
endmodule

module FlagRegister(output reg c, z, n, v, input cFlag, zFlag, nFlag, vFlag, input FR_ld, R, Clk);
    always @(posedge Clk) begin
        if(R) begin 
            c = 1'b0;
			z = 1'b0;
			n = 1'b0;
			v = 1'b0;
        end
        else if(FR_ld) begin
            c = cFlag;
			z = zFlag;
			n = nFlag;
			v = vFlag;
		end
    end
endmodule

module ConditionTester(output reg Cond, input c, z, n, v, input [3:0] IR);
    always@(IR, c, z, n, v) begin
        case(IR)
            4'b0000:  //Equal
            	if(z == 1) Cond = 1;
				else Cond = 0;
            
            4'b0001:  //Not Equal
            	if(z == 0) Cond = 1;
				else Cond = 0;
			
            4'b0010:  //Unsigned higher or same
            	if(c == 1) Cond = 1;
				else Cond = 0;
			
            4'b0011:  //Unsigned lower
			    if(c == 0) Cond = 1;
				else Cond = 0;
			
            4'b0100:  //Minus
            	if(n == 1) Cond = 1;
				else Cond = 0;

            4'b0101:  //Positive or Zero
            	if(n == 0) Cond = 1;
				else Cond = 0;
			
            4'b0110:  //Overflow
            	if(v == 1) Cond = 1;
				else Cond = 0;
			
            4'b0111:  //No Overflow
            	if(v == 0) Cond = 1;
				else Cond = 0;
			
            4'b1000:  //Unsigned Higher
            	if(c == 1 && z == 0) Cond = 1;
				else Cond = 0;
			
            4'b1001:  //Unsigned Lower or same
            	if(c == 0 && z == 1) Cond = 1;
				else Cond = 0;
		
            4'b1010: //Greater or equal
            	if(c == v) Cond = 1;
				else Cond = 0;
			
            4'b1011:  //Less than
            	if(!n == v) Cond = 1;
				else Cond = 0;
			
            4'b1100:  //Greater than
            	if(z == 0 && n == v) Cond = 1;
				else Cond = 0;
		
            4'b1101: //Less than or equal
            	if(z == 1 || n != v) Cond = 1;
				else Cond = 0;

            4'b1110: //Always
				Cond = 1;

            default:
				Cond = 0;
        endcase
    end
endmodule
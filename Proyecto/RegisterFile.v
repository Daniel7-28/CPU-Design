module Binary_Decoder(output reg[15:0] y, input [3:0]D, input load);

    always@(D, load)
    begin
        if(load)
            case(D)
            4'b0000: y<=16'b0000000000000001;
            4'b0001: y<=16'b0000000000000010;
            4'b0010: y<=16'b0000000000000100;
            4'b0011: y<=16'b0000000000001000;
            4'b0100: y<=16'b0000000000010000;
            4'b0101: y<=16'b0000000000100000;
            4'b0110: y<=16'b0000000001000000;
            4'b0111: y<=16'b0000000010000000;
            4'b1000: y<=16'b0000000100000000;
            4'b1001: y<=16'b0000001000000000;
            4'b1010: y<=16'b0000010000000000;
            4'b1011: y<=16'b0000100000000000;
            4'b1100: y<=16'b0001000000000000;
            4'b1101: y<=16'b0010000000000000;
            4'b1110: y<=16'b0100000000000000;
            4'b1111: y<=16'b1000000000000000;
            endcase
        else y = 16'b0000000000000000;
    end
endmodule

module Register (output reg [31:0] dataout,input [31:0] datain, input enable, Clk);
    always @ (posedge Clk)
    if (enable) dataout <= datain;
endmodule

module Mux_2x1(output reg [31:0] Y, input S, input[31:0] option_a, option_b);
    always@(S, option_a, option_b)
    case(S)
        1'b0 : Y <= option_a;
        1'b1 : Y <= option_b;
    endcase
endmodule

module Mux_16x1(output reg[31:0] Y, input [3:0]S, input [31:0] R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0);
    always@(S, R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0)
    case(S)
    4'b0000: Y <= R0;
    4'b0001: Y <= R1;
    4'b0010: Y <= R2;
    4'b0011: Y <= R3;
    4'b0100: Y <= R4;
    4'b0101: Y <= R5;
    4'b0110: Y <= R6;
    4'b0111: Y <= R7;
    4'b1000: Y <= R8;
    4'b1001: Y <= R9;
    4'b1010: Y <= R10;
    4'b1011: Y <= R11;
    4'b1100: Y <= R12;
    4'b1101: Y <= R13;
    4'b1110: Y <= R14;
    4'b1111: Y <= R15;
    endcase
endmodule

//Register PC
module Register_PC(output reg [31:0] dataout, input [31:0] datain, input Clk, R, enable);

    always@(posedge Clk) begin
        if (R) dataout <= 32'b00000000000000000000000000000000;
        else if (enable)
        dataout <= datain;
        // $display("PC_in %d PC_out %d Reset %d Enable %b", datain, dataout, R, enable);
    end    
endmodule

module Register_File(PA, PB, PC, PW, RA, RB, RC, RW, pc_out, pc_in, pc_enable,  pc_plus_4, BL_true, load, Clk, R);
	output [31:0] PA, PB, PC, pc_out;	//Output Ports, program counter port
	input [31:0] PW; 				    //Data in
	input [3:0] RA, RB, RC;			    //Register number to read (4 bits)
	wire [15:0] Registers_Enable;       //Register enable
	wire [31:0] R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0;                         //Data out of each register
	input [3:0] RW; 				    //Register to write to
	input load, pc_enable;			    //Load enable, Program Counter enable
	input Clk, R;					    //Clock, Reset for the program counter register
	input BL_true;                      //Branch & Link true
	input [31:0] pc_in, pc_plus_4;      //Program Counter_in, Program Counter+4
	wire [31:0] info_R14;               //Information store in Register 14
	reg LR_enable;                      //Link Register Enable

	Binary_Decoder BD(Registers_Enable, RW, load);

    Register R_0(R0,PW,Registers_Enable[0],Clk);
    Register R_1(R1,PW,Registers_Enable[1],Clk);
    Register R_2(R2,PW,Registers_Enable[2],Clk);
    Register R_3(R3,PW,Registers_Enable[3],Clk);
    Register R_4(R4,PW,Registers_Enable[4],Clk);
    Register R_5(R5,PW,Registers_Enable[5],Clk);
    Register R_6(R6,PW,Registers_Enable[6],Clk);
    Register R_7(R7,PW,Registers_Enable[7],Clk);
    Register R_8(R8,PW,Registers_Enable[8],Clk);
    Register R_9(R9,PW,Registers_Enable[9],Clk);
    Register R_10(R10,PW,Registers_Enable[10],Clk);
    Register R_11(R11,PW,Registers_Enable[11],Clk);
    Register R_12(R12,PW,Registers_Enable[12],Clk);
    Register R_13(R13,PW,Registers_Enable[13],Clk);
    
    Mux_2x1 LR_or_R14(info_R14, BL_true, PW, pc_plus_4);

    always@(BL_true, PW, pc_plus_4)
        case(BL_true)
        1'b0: LR_enable = Registers_Enable[14]; 
        1'b1: LR_enable = 1;
        endcase

    Register R_14(R14, info_R14 , LR_enable, Clk);

    Register_PC R_15(pc_out, pc_in, Clk, R, pc_enable);
    // Register R_15(R15, pc_in, pc_enable ,Clk);
	// assign pc_out = R15;

	Mux_16x1 Port_A(PA, RA, R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0);
	Mux_16x1 Port_B(PB, RB, R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0);
	Mux_16x1 Port_C(PC, RC, R15, R14, R13, R12, R11, R10, R9, R8, R7, R6, R5, R4, R3, R2, R1, R0);
    always@(*)
$display("PW %d RW %d enable %b", PW, RW, Registers_Enable);
endmodule
`include "ALU&Shifter-SignExtender.v"
module alutb;
	
	wire cFlag, zFlag, nFlag, vFlag;
	reg [31:0] inputA, inputB;
	reg carryIn;
	wire [31:0] out;
	reg [4:0] op;
	wire [4:0] opCode;
	reg [32:0] operation;
	reg S;

	assign opCode = op;
	ALU alu(inputA, inputB, opCode, carryIn, S, out, cFlag, zFlag, nFlag, vFlag);
	
	
	
	initial begin
	
		inputA =32'b1010;
		inputB =32'b0010;
		carryIn = 1;
		S=1;
	
		
		op = 4'b0000;
		operation = "AND";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b1000;
		operation = "TST";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b0001;
		operation = "EOR";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b1001;
		operation = "TEQ";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b0010;
		operation = "SUB";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);

		inputA =32'b0;
		op = 4'b0010;
		operation = "SUB";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);

		op = 4'b0110;
		operation = "SBC";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b0011;
		operation = "RSB";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b0111;
		operation = "RSC";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
 
 		inputA =32'b01000000000000000000000000000000;
		inputB =32'b01000000000000000000000000000000;
		op = 4'b0100;
		operation = "ADD";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		inputA =32'd4294967295;
		inputB =32'd1;
		op = 4'b0100;
		operation = "ADD";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);

		op = 4'b0101;
		operation = "ADC";
		#200; 
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
			
		inputA =32'b01111111111111111111111111111111;
		inputB =32'b01111111111111111111111111111111;
		op = 4'b1010;
		operation = "CMP";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		inputA =32'b01111111111111111111111111111111;
		inputB =32'b01111111111111111111111111111111;
		op = 4'b1011;
		operation = "CMN";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		inputA =32'b1010;
		inputB =32'b0010;
		op = 4'b1100;
		operation = "ORR";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		inputA =32'b0;
		op = 4'b1101;
		operation = "MOV";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		inputA =32'b0111;
		op = 4'b1110;
		operation = "BIC";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
		op = 4'b1111;
		operation = "MVN";
		#200;
		$display("%s %b %b = %1b \n%s %32d %32d = %32d \nCIn = %1b\t cFlag = %b\t zFlag = %1b\t nFlag = %1b\t vFlag = %1b\n", 
			operation, inputA, inputB, out, operation, inputA, inputB, out, carryIn, cFlag, zFlag, nFlag, vFlag);
		
	end
 
endmodule
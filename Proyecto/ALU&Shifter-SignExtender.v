/*El ALU debe tomar dos números de 32 bits y un bit de carry y realizar cualquiera de las
operaciones necesarias para implementar instrucciones “data processing” y cualquier otra
instrucción que requiera operaciones aritméticas o lógicas. Las salidas del ALU serán el resultado
de la operación y cuatro bits correspondientes a los “condition codes” (N, Z, C, V). 
*/

module ALU( input [31:0] inputA, inputB, input [3:0]  opCode, input carryIn, input S, output reg [31:0] out, output reg cFlag, zFlag, nFlag, vFlag);
			
	always @ (*) begin
		case(opCode) 
			// 0000 AND - Logic AND 		
			5'b0000: 	begin
						out = (inputA & inputB);
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			// 0001 EOR - Exclusive OR		
			5'b0001:	begin
						out = inputA ^ inputB;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			// 0010 SUB - Subtract		
			5'b0010:	begin
						out = inputA - inputB;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (inputA[31] & !inputB[31] & !out[31]) | 
								(!inputA[31] & inputB[31] & out[31]);
						end
						end
			// 0011 RSB - Reverse Subtract		
			5'b0011:	begin
						out = inputB - inputA;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (inputA[31] & !inputB[31] & !out[31]) | 
								(!inputA[31] & inputB[31] & out[31]);
						end
						end
			// 0100 ADD - Addition 		
			5'b0100:	begin
						{cFlag,out} = inputA + inputB;
						if (S) begin
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (!inputA[31] & !inputB[31] & out[31]) | 
								(inputA[31] & inputB[31] & !out[31]);
						end
						end
			// 0101 ADC - ADD with carryIn		
			5'b0101:	begin
						{cFlag,out} = inputA + inputB + carryIn;
						if (S) begin
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (!inputA[31] & !inputB[31] & out[31]) | 
								(inputA[31] & inputB[31] & !out[31]);
						end
						end
			// 0110 SBC - Substract with carryIn		
			5'b0110:	begin
						out = inputA - inputB - !carryIn;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (inputA[31] & !inputB[31] & !out[31]) | 
								(!inputA[31] & inputB[31] & out[31]);
						end
						end
			// 0111 RSC - Reverse Substract with carryIN		
			5'b0111:	begin
						out = inputB - inputA - !carryIn;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = (inputA[31] & !inputB[31] & !out[31]) | 
								(!inputA[31] & inputB[31] & out[31]);
						end
						end
			// 1000 TST AND	-Test
			5'b1000: 	begin
						out = inputA & inputB;
						cFlag = out[31];
						zFlag = out == 32'b0;
						nFlag = out[31];
						vFlag = 0;
						end
			// 1001  TEQ EOR - Test Equivalence EOR		
			5'b1001:	begin
						out = inputA ^ inputB;
						cFlag = out[31];
						zFlag = out == 32'b0;
						nFlag = out[31];
						vFlag = 0;
						end
			// 1010 CMP SUB - Compare SUB
			5'b1010:	begin
						out = inputA - inputB;
						cFlag = out[31];
						zFlag = out == 32'b0;
						nFlag = out[31];
						vFlag = (inputA[31] & !inputB[31] & !out[31]) | 
							(!inputA[31] & inputB[31] & out[31]);
						end
			// 1011 CMN ADD- Compare Negated ADD
			5'b1011:	begin
						{cFlag,out} = inputA + inputB;
						zFlag = out == 32'b0;
						nFlag = out[31];
						vFlag = (!inputA[31] & !inputB[31] & out[31]) | 
							(inputA[31] & inputB[31] & !out[31]);
						end		
			// 1100 ORR - Logic OR	
			5'b1100:	begin
						out = (inputA | inputB);
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			// 1101 MOV- Move
			5'b1101:	begin
						out = inputB;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			// 1110 BIC-Bit Clear	
			5'b1110: 	begin
						out = inputA & ~inputB;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			// 1111 MVN - Move not
			5'b1111:	begin
						out = ~inputB;
						if (S) begin
							cFlag = out[31];
							zFlag = out == 32'b0;
							nFlag = out[31];
							vFlag = 0;
						end
						end
			
			default:	begin
						out = 0;
						cFlag = 0;
						zFlag = 0;
						nFlag = 0;
						vFlag = 0;
						end
		endcase
		
    end

endmodule

/*El Shifter/Sign Extender realizará las operaciones necesarias para generar el segundo operando
fuente de las instrucciones “data processing” y load/store requeridas para el proyecto. Tendrá
como entradas un número de 32 bits y otro de 12 bits y producirá el operando correspondiente.
El número de 32 bits es normalmente el contenido del registro Rm de la instrucción. El número
de 12 bits corresponderá a la codificación especificada por los bits I11-I0 de una instrucción “data
processing” o load/store. */

module Shifter (input [31:0] A, input [11:0] B, input [2:0] shift, output reg [31:0] out, output reg carry);

	integer i = 0;

	always @(A, B, shift) begin
		// Data processing immediate
		if(shift == 3'b001) begin
			out = { 24'b0 , B[7:0]};
			for(i = 0; i < B[11:8] * 2; i++) 
			begin
				carry = out[0];
				out = out >> 1;
				out[31] = carry;
			end
			// $display("data processing inmmediate %d", out);
		end

		// Data processing immediate shift 4 cases
		if(shift == 3'b000) begin
			if(B[6:5] == 2'b00)
				begin
					{carry,out} = A << B[11:7];
				end
			if(B[6:5] == 2'b01)
				begin
					carry = A[0];
					out = A >> B[11:7];
				end
			if(B[6:5] == 2'b10) 
				begin
					carry = A[31];
					out = A >> B[11:7];
					for(i = 0; i < B[11:7]; i++) 
					begin
						out[31 - i] = carry;
					end
				end
			if(B[6:5] == 2'b11)
				begin
					out = A;
					for(i = 0; i < B[11:7]; i++) 
					begin
						carry = out[0];
						out = out >> 1;
						out[31] = carry;
					end
				end
			
		end

		// Load/Store immediate offset
		if(shift == 3'b010) begin
			out = B;
		end
		
		// Load/Store register offset
		if(shift == 3'b011) begin
			out = A;
		end
	end
endmodule
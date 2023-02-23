`include "ALU&Shifter-SignExtender.v"
module Shiftertb;
    
	reg [31:0] Rm_input;
	reg [11:0] shifter_input;
	reg [2:0] type_input;

	wire [31:0] shifter_output;
	wire shifter_carry_output;

	reg [32:0] mode;

	Shifter shifter(Rm_input, shifter_input, type_input, shifter_output, shifter_carry_output);
	
	initial begin

		#100;
		
		$display("  Mode  Rm Input			             Shift Input			     Output");
		Rm_input = 32'b11101011000000000000000000000111;

		
		type_input = 3'b000;
		$display("  Data Processing");

		shifter_input = 12'b001110000111;				// LSL
		mode = "LSL";
		#100;	
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001110100111;				// LSR
		mode = "LSR";
		#100;	
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001111000111;				// ASR
		mode = "ASR";
		#100;	
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		shifter_input = 12'b001111100111;				// ROR
		mode = "ROR";
		#100;	
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);


		// Data Processing immediate
		type_input = 3'b001;
		shifter_input = 12'b001110000111;
		mode = "IMM";
		#100; 
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		
		$display("  Load/Store");

		// Immediate Offset
		type_input = 3'b010;
		shifter_input = 12'b010111010101;
		mode = "IMM";
		#100; 
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);

		// register Offset
		type_input = 3'b011;
		shifter_input = 12'b010111000101;
		mode = "REG";
		#100; 
		$display("%s   %b %b 			     %b", mode, Rm_input, shifter_input, shifter_output);
		
		
			end
 
endmodule
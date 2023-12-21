/*
ALU MODULE for calculations
*/
/* verilator lint_off MODDUP */
module alu (
	input wire [3:0] sel,
	input wire [15:0] a,
	input wire [15:0] b,
	output reg [15:0] y
);
	
	always @(*) begin
		case(sel)
			0 :			y = 16'h0000;	// no operation result is 0
			1 : 		y = ~a;			// complement of operand a
			2 :			y = a << 1;		// shift a left
			3 :			y = a >> 1;		// shift a right
			4 :			y = a + 1;		// increment operand A
			
			5 :			y = a & b;		// bitwise and connection
			6 :			y = a | b;		// bitwise OR connection
			7 :			y = a ^ b;		// bitwise XOR connection
			
			8 : 		y = a + b;		// add the two operands
			9 :			y = a - b;		// subtract the two operands
			10 :		y = a * b;		// multiply the two operands
			11 :		y = a / b;		// divide the two operands
			default :	y = 16'h0000;
		endcase
	end
endmodule
/* verilator lint_on MODDUP */

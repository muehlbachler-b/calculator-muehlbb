// Copyright 2023 Benedikt Muehlbachler JKU
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// 		http://www.apache.org/licenses/LICENSE−2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License
// 
// ################################################################
// Module alu.v
// - Arithmetic Logic Unit for 16 bit-data
// - Performs Logic Operations like Complement,OR,...
// - Performs Arithmetic Operations like ADD,SUBTRACT,...
// ################################################################

/* verilator lint_off MODDUP */
module alu (
	input wire [3:0] sel,
	input wire [15:0] a,
	input wire [15:0] b,
	output reg [15:0] y,
	output reg [2:0] status
);
	
	always @(*) begin
		case(sel)
			0 :			y = 16'h0000;		// no operation result is 0
			1 : 		y = ~a;				// complement of operand a
			2 :			y = a << 1;
			3 :			y = a >> 1;			// shift a right
			4 :			y = a + 1;			// increment operand A
			5 : 		y = a - 1;			// decrement operand A
			
			6 :			y = a & b;			// bitwise and connection
			7 :			y = a | b;			// bitwise OR connection
			8 :			y = a ^ b;			// bitwise XOR connection
		
			9 : 		y = a + b;			// add the two operands
			10 :		y = a - b;			// subtract the two operands
			11 :		y = a * b;			// multiply the two operands
			default :	y = 16'h0000;
		endcase
		
		/* verilator lint_off UNSIGNED */
		if(sel>=0 && sel <=11) begin
			status[0] = 1'b0;
		end else begin
			status[0] = 1'b1;
		end
		/* verilator lint_on UNSIGNED */
		
		if(y==16'h0000) begin
			status[1] = 1'b1; 	//set zero-flag
		end else begin
			status[1] = 1'b0;
		end
		status[2] = y[15]; 		//set sign flag
		
	end
endmodule
/* verilator lint_on MODDUP */

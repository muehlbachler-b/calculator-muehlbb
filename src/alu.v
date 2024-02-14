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
	output reg [4:0] status
);
	
	always @(*) begin
		case(sel)
			0 :	begin
					y = 16'h0000; // no operation result is 0
					status[4:3] = 2'b00; //no CF and OF
					end
			1 : begin
					y = ~a;	// complement of operand a
					status[4:3] = 2'b00; //no CF and OF
					end
			2 :	begin
					y = a << 1;	// shift a left
					status[3] = a[15]; //CF possible
					status[4] = 1'b0; //no OF
					end
			3 :	begin
					y = a >> 1;	// shift a right
					status[3] = a[0];
					status[4] = 1'b0;
					end
			4 : begin
					y = {a[14:0], a[15]}; // rotate a left
					status[4:3] = 2'b00;
					end
			5 : begin
					y = {a[0], a[15:1]}; // rotate a right
					status[4:3] = 2'b00;
					end
			6 :	begin
					y = a + 1; // increment operand A
					status[3] = a[15]&~y[15];
					status[4] = ~a[15]&y[15];
					end
			7 : begin
					y = a - 1; // decrement operand A
					status[3] = ~a[0]&y[15];
					status[4] = a[15]&~y[15];
					end
			8 :	begin
					y = a & b;	// bitwise and connection
					status[4:3] = 2'b00;
					end
			9 :	begin
					y = a | b;	// bitwise OR connection
					status[4:3] = 2'b00;
					end
			10 : begin
					y = a ^ b; // bitwise XOR connection
					status[4:3] = 2'b00;
					end
			11 : begin
					y = a + b;	// add the two operands
					status[3] = a>16'hffff-b;
					status[4] = a[15]&b[15]&~y[15] | ~a[15]&~b[15]&y[15];
					end
			12 : begin
					y = a - b;	// subtract the two operands
					status[3] = a<b;
					status[4] = a[15]&~b[15]&~y[15] | ~a[15]&b[15]&y[15];
					end
			default : begin
					y = 16'h0000;
					status[4:3] = 2'b00;
					end
		endcase
		
		/* verilator lint_off UNSIGNED */
		if(sel>=0 && sel <=12) begin
			status[0] = 1'b0; //no wrong operation selected
		end else begin
			status[0] = 1'b1; //wrong operation selected
		end
		/* verilator lint_on UNSIGNED */
		
		if(y==16'h0000) begin
			status[1] = 1'b1; //set zero-flag if result=0
		end else begin
			status[1] = 1'b0; //no zero-flag if result!=0
		end
		status[2] = y[15]; //set sign flag (=bit15 of result)
		
	end
endmodule
/* verilator lint_on MODDUP */

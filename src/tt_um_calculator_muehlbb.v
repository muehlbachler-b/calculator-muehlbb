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
// Module tt_um_calculator_muehlbb.v
// - Performs 16-bit arithmetic and logic operations on data
// - Use module alu.v (16-bit arithmetic logic unit)
// ################################################################

`default_nettype none
`ifndef __CALCULATOR__
`define __CALCULATOR__

`include "alu.v"

module tt_um_calculator_muehlbb (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
	// Inputs
	wire rst = ~rst_n; // reset
	wire [3:0] alu_sel = ui_in[3:0]; // alu operation selection
	/* verilator lint_off UNUSEDSIGNAL */
	wire [3:0] dummy1 = ui_in[7:4];
	wire dummy2 = ena;
	/* verilator lint_on UNUSEDSIGNAL */

	// Outputs
	reg [4:0] status_out; // status register for output
	assign uo_out[4:0] = status_out;
	
	reg [2:0] counter; // counter register
	assign uo_out[7:5] = counter;
	
	// IOs
	wire [7:0] data_in = uio_in; // input-port for operand a and b of calculation
	reg [7:0] data_out; // data-output-register (for the result of operation)
	assign uio_out = data_out;
	reg [7:0] inout_en; //IO-Port Enable Register (0x00 for input, 0xff for output)
	assign uio_oe = inout_en;

	// Create registers for data
	reg [3:0] sel_reg; // alu sel register for ALU
	reg [15:0] data_a; // operand a register for calculation
	reg [15:0] data_b; // operand b register for calculation
	wire [15:0] y; // y output result of operation
	wire [4:0] status_wire; // status output of ALU
	
	alu alu_1(sel_reg, data_a, data_b, y, status_wire); //16-bit alu for operations

    always @(posedge clk) begin
        /* verilator lint_off CASEINCOMPLETE */  
       	case(counter)
       		3'b001 : data_a[7:0] <= data_in; //save in low-byte of A
    		3'b010 : data_a[15:8] <= data_in; //save in high-byte of A
    		3'b011 : data_b[7:0] <= data_in; //save in low-byte of B
    		3'b100 : begin
    					data_b[15:8] <= data_in; //save in high-byte of B
    					sel_reg <= alu_sel; // select ALU operation
    					end
    		3'b101 : begin
    					data_out <= y[7:0]; //write low-byte of result on IO-Port
    					status_out <= status_wire; //write status-reg on output
    					end
    		3'b110 : data_out <= y[15:8]; //write high-byte of result on IO-Port
    	endcase
    	/* verilator lint_on CASEINCOMPLETE */
    end
    
    always @(negedge clk) begin
    	if (rst || counter == 3'b110) begin
    		// if reset or counter finished --> start from new
    		counter <= 3'b000; // counter=0
    		inout_en <= 8'h00; // set IO-Port as IN (to save a nd b in registers)
    	end	else
    		counter <= counter + 1;
    		
    	if (counter == 3'b100)
    		inout_en <= 8'hff; // set IO-Port as OUT (for result output)
   	end
endmodule

`endif
`default_nettype wire

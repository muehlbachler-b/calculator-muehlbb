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
// - Uses module alu.v
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
	wire rst = ~rst_n;				 // reset
	wire [3:0] alu_sel = ui_in[3:0]; // alu operation selection
	/* verilator lint_off UNUSEDSIGNAL */
	wire [3:0] dummy1 = ui_in[7:4];
	wire dummy2 = ena;
	/* verilator lint_on UNUSEDSIGNAL */

	// Outputs sdfds
	//sta
	reg [2:0] counter;
	assign uo_out[5:3] = counter;
	assign uo_out[7:6] = 2'b00;
	
	// IOs
	/* verilator lint_off UNUSEDSIGNAL */
	wire [7:0] data_in = uio_in;
	/* verilator lint_on UNUSEDSIGNAL */
	reg [7:0] data_out;
	assign uio_out = data_out;
	reg [7:0] inout_en; //enables IO-Port for input or output
	assign uio_oe = inout_en;

	// create registers for data
	reg [15:0] data_a;
	reg [15:0] data_b;
	wire [15:0] y;

	// Create Alu-Model
	alu alu_1(alu_sel, data_a, data_b, y, uo_out[2:0]);

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (rst) begin
            counter <= 3'b000;
            inout_en <= 8'h00;
            data_a <= 16'h0011;
            data_b <= 16'h0011;
        end else begin
            counter <= counter + 1;
        end
        
        /* verilator lint_off CASEINCOMPLETE */  
       	case(counter)
       		3'b000 : data_a[7:0] <= uio_in;
    		3'b001 : data_a[15:8] <= uio_in;
    		3'b010 : data_b[7:0] <= uio_in;
    		3'b011 : data_b[15:8] <= uio_in;
    		3'b100 : data_out <= y[7:0];
    		3'b101 : data_out <= y[15:8];
    	endcase
    	/* verilator lint_on CASEINCOMPLETE */
    end

endmodule

`endif
`default_nettype wire

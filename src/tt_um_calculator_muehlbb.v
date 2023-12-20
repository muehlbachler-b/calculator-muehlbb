/*
	Calculator that performs 16-bit arithmetic and logic operations on data.
*/

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
	reg [3:0] status;
	assign uo_out[3:0] = status;
	reg [2:0] counter;
	assign uo_out[6:4] = counter;
	assign uo_out[7] = 1'b0;
	
	// IOs
	/* verilator lint_off UNUSEDSIGNAL */
	wire [7:0] data_in = uio_in;
	/* verilator lint_on UNUSEDSIGNAL */
	wire [7:0] y_out;
	assign uio_out = y_out;
	reg [7:0] inout_en; //enables IO-Port for input or output
	assign uio_oe = inout_en;

	// create registers for data
	reg [7:0] data_a;
	reg [7:0] data_b;

	// Create Alu-Model
	alu alu_1(alu_sel, data_a, data_b, y_out);

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (rst) begin
            status <= 4'h0;
            counter <= 3'b000;
            inout_en <= 8'h00;
            data_a <= 8'h11;
            data_b <= 8'h11;
        end else
            counter <= counter + 1;
    end

endmodule

`endif
`default_nettype wire

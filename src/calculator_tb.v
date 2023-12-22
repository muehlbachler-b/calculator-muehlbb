/*
	Simple testbench for the calculator
*/

`timescale 1ns/1ns
`include "tt_um_calculator_muehlbb.v"

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module calculator_tb;
    // wire up the inputs and outputs
    reg  clk = 1'b0;
    reg  rst_n = 1'b0;
    reg  ena;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in = 8'h3C;

	

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_calculator_muehlbb tt_um_calculator_muehlbb (
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );
        
   	// Generate clock
   	/* verilator lint_off STMTDLY */
   	always #5 clk = ~clk;
   	/* verilator lint_on STMTDLY */ 

    initial begin
        $dumpfile ("calc_tb.vcd");
        $dumpvars;
         /* verilator lint_off STMTDLY */
         #50 rst_n = 1'b1;
         ui_in[3:0] <= 11;
         #80 ui_in[3:0] <= 5;
         #80 ui_in[3:0] <= 3;
         #200 $finish;
         /* verilator lint_on STMTDLY */
    end
endmodule

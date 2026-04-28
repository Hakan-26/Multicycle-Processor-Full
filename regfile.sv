/*
	Hakan Töre 2210357024
	ELE432 Preliminary Work 2 : PRE2_Single-Cycle_RISC-V_Processor
	riscv_single_cycle.sv
*/

module regfile (
	input  logic        clk,
   input  logic        WE3,
   input  logic [19:15]  A1,
   input  logic [24:20]  A2,
   input  logic [11:7]  A3,
   input  logic [31:0] WD3,
   output logic [31:0] RD1,
   output logic [31:0] RD2
);

	logic [31:0] rf [31:0];

    // Synchronous Write
    always_ff @(posedge clk) begin
        if (WE3 && (A3 != 5'b00000)) begin // RISC-V require Register 0 to be hardwired to zero
            rf[A3] <= WD3;
        end
    end

    // Asynchronous Read
    assign RD1 = (A1 != 5'b00000) ? rf[A1] : 32'b0;
    assign RD2 = (A2 != 5'b00000) ? rf[A2] : 32'b0;

endmodule
/*
	Hakan Töre 2210357024
	ELE432 Preliminary Work 2 : PRE2_Single-Cycle_RISC-V_Processor
	riscv_single_cycle.sv
*/

module alu (
	input  logic [31:0] SrcA,
   input  logic [31:0] SrcB,
   input  logic [2:0]  ALUControl,
   output logic [31:0] ALUResult,
   output logic        Zero
);

	logic [31:0] muxB;
   logic [31:0] sum;
   logic        v; //internal overflow

    
	// If ALUControl[0] = 1 : invert SrcB.
   assign muxB = ALUControl[0] ? ~SrcB : SrcB;


	// SrcA + SrcB or SrcA + ~SrcB + 1 
   assign sum = SrcA + muxB + ALUControl[0];

   // Overflow
   assign v = ~(ALUControl[0] ^ SrcA[31] ^ SrcB[31]) & (SrcA[31] ^ sum[31]) & (~ALUControl[1]);
    
   // Result Mux
	always_comb begin
		case (ALUControl)

			3'b000: ALUResult = sum;         				// ADD
         3'b001: ALUResult = sum;         				// SUB   
         3'b010: ALUResult = SrcA & SrcB; 				// AND
         3'b011: ALUResult = SrcA | SrcB; 				// OR
			3'b100: ALUResult = SrcA ^ SrcB; 				// XOR 
         3'b101: ALUResult = {31'b0, (sum[31] ^ v)};  // SLT
            
         default: ALUResult = 32'bx;	// unknown
			
		endcase
   end

   // Zero Flag
	assign Zero = (ALUResult == 32'b0);

endmodule
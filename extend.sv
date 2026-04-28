/*
	Hakan Töre 2210357024
	ELE432 Preliminary Work 2 : PRE2_Single-Cycle_RISC-V_Processor
	riscv_single_cycle.sv
*/
 
module extend (
    input  logic [31:7] Instr,
    input  logic [ 1:0] ImmSrc,
    output logic [31:0] ImmExt
);
 
  // Immediate Extension Multiplexer Encoding
  always_comb begin
    case (ImmSrc)
      2'b00:   ImmExt = {{20{Instr[31]}}, Instr[31:20]};  // I-type
      2'b01:   ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};  // S-type
      2'b10:   ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};  // B-type
      2'b11:   ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};  // J-type
      default: ImmExt = 32'bx;
    endcase
  end
 
endmodule
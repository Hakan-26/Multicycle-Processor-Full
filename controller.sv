/*
	Hakan Töre 2210357024
	ELE432 Homework 2 : HW2_Multi-Cycle_RISC-V_Processor
	controller.sv
*/
module controller(
	input logic 		 clk,
	input logic 		 reset,
	input logic  [6:0] op,
	input logic  [2:0] funct3,
	input logic 		 funct7b5,
	input logic 		 zero,
	output logic [1:0] immsrc,
	output logic [1:0] alusrca, alusrcb,
	output logic [1:0] resultsrc,
	output logic 		 adrsrc,
	output logic [2:0] alucontrol,
	output logic 		 irwrite, pcwrite,
	output logic 		 regwrite, memwrite
);

	logic [1:0] aluop;
	logic       branch;
	logic       pcupdate;
	
	assign pcwrite = pcupdate | (branch & zero); 
	
	instrdec id (
		.op(op),
		.ImmSrc(immsrc)
	);
	
	aludec ad (
		.opb5(op[5]),      
		.funct3(funct3),
		.funct7b5(funct7b5),
		.ALUOp(aluop),
		.ALUControl(alucontrol)
	);
	
	mainfsm fsm (
		.clk(clk),
		.reset(reset),
		.op(op),
		.Branch(branch),
		.PCUpdate(pcupdate),
		.RegWrite(regwrite),
		.MemWrite(memwrite),
		.IRWrite(irwrite),
		.ResultSrc(resultsrc),
		.ALUSrcA(alusrca),
		.ALUSrcB(alusrcb),
		.AdrSrc(adrsrc),
		.ALUOp(aluop)
	);

endmodule
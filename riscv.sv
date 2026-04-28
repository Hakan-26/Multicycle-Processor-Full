/*
	Hakan Töre 2210357024
	ELE432 Prework 3
	riscv.sv
*/

module riscv (
    input  logic        clk, reset,
    input  logic [31:0] ReadData,
    output logic        MemWrite,
    output logic [31:0] Adr, WriteData
);

    // Interconnect signals between controller and datapath
    logic [6:0] op;
    logic [2:0] funct3;
    logic       funct7b5;
    logic       Zero;
    logic [1:0] ImmSrc;
    logic [1:0] ALUSrcA, ALUSrcB;
    logic [1:0] ResultSrc;
    logic       AdrSrc;
    logic [2:0] ALUControl;
    logic       IRWrite, PCWrite, RegWrite;

    controller c (
        .clk(clk),
        .reset(reset),
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .zero(Zero),
        .immsrc(ImmSrc),
        .alusrca(ALUSrcA),
        .alusrcb(ALUSrcB),
        .resultsrc(ResultSrc),
        .adrsrc(AdrSrc),
        .alucontrol(ALUControl),
        .irwrite(IRWrite),
        .pcwrite(PCWrite),
        .regwrite(RegWrite),
        .memwrite(MemWrite)
    );

    datapath dp (
        .clk(clk),
        .reset(reset),
        .ReadData(ReadData),
        .ImmSrc(ImmSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .AdrSrc(AdrSrc),
        .ALUControl(ALUControl),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .Zero(Zero),
        .op(op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Adr(Adr),
        .WriteData(WriteData)
    );

endmodule

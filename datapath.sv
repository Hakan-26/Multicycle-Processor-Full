/*
	Hakan Töre 2210357024
	ELE432 Prework 3
	datapath.sv
*/
module datapath (
    input  logic        clk, reset,
    input  logic [31:0] ReadData,
    input  logic [1:0]  ImmSrc,
    input  logic [1:0]  ALUSrcA, ALUSrcB,
    input  logic [1:0]  ResultSrc,
    input  logic        AdrSrc,
    input  logic [2:0]  ALUControl,
    input  logic        IRWrite, PCWrite, RegWrite,
    output logic        Zero,
    output logic [6:0]  op,
    output logic [2:0]  funct3,
    output logic        funct7b5,
    output logic [31:0] Adr,
    output logic [31:0] WriteData
);

    logic [31:0] PC, PCNext, OldPC;
    logic [31:0] Instr, Data;
    logic [31:0] RD1, RD2, A;
    logic [31:0] SrcA, SrcB;
    logic [31:0] ImmExt;
    logic [31:0] ALUResult, ALUOut;
    logic [31:0] Result;

    assign op       = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7b5 = Instr[30];

    // Sequential Logic (Registers/Flops)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            PC        <= 32'b0;
            OldPC     <= 32'b0;
            Instr     <= 32'b0;
            Data      <= 32'b0;
            A         <= 32'b0;
            WriteData <= 32'b0;
            ALUOut    <= 32'b0;
        end else begin
            // Enabled registers
            if (PCWrite) PC    <= PCNext;  
            if (IRWrite) OldPC <= PC;       
            if (IRWrite) Instr <= ReadData; 

            // Always active registers
            Data      <= ReadData; 
            A         <= RD1;      
            WriteData <= RD2;      
            ALUOut    <= ALUResult;
        end
    end

    // Combinational Logic (Multiplexers) 
    
    // Adr Mux
    assign Adr = AdrSrc ? Result : PC;

    // SrcA Mux 
    always_comb begin
        case (ALUSrcA)
            2'b00: SrcA = PC;
            2'b01: SrcA = OldPC;
            2'b10: SrcA = A;
            default: SrcA = 32'bx;
        endcase
    end

    // SrcB Mux 
    always_comb begin
        case (ALUSrcB)
            2'b00: SrcB = WriteData;
            2'b01: SrcB = ImmExt;
            2'b10: SrcB = 32'd4;
            default: SrcB = 32'bx;
        endcase
    end

    // Result Mux 
    always_comb begin
        case (ResultSrc)
            2'b00: Result = ALUOut;
            2'b01: Result = Data;
            2'b10: Result = ALUResult;
            default: Result = 32'bx;
        endcase
    end

    // PCNext wiring
    assign PCNext = Result;
	 
    
    // Register File 
    regfile rf (
        .clk(clk),
        .WE3(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Sign Extension 
    extend ext (
        .Instr(Instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // ALU 
    alu alu_inst (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

endmodule

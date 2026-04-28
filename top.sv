/*
	Hakan Töre 2210357024
	ELE432 Prework 3
	top.sv
*/

module top (
    input  logic        clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic        MemWrite
);

    logic [31:0] ReadData;

    // RISC-V processor (controller + datapath)
    riscv rv (
        .clk(clk),
        .reset(reset),
        .ReadData(ReadData),
        .MemWrite(MemWrite),
        .Adr(DataAdr),       
        .WriteData(WriteData)
    );

    // Unified Instruction/Data Memory 
    mem memory (
        .clk(clk),
        .we(MemWrite),
        .a(DataAdr),
        .wd(WriteData),
        .rd(ReadData)
    );

endmodule

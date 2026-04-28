/*
	Hakan Töre 2210357024
	ELE432 Prework 3
	mem.sv
*/

module mem (
    input  logic        clk,
    input  logic        we,
    input  logic [31:0] a,
    input  logic [31:0] wd,
    output logic [31:0] rd
);

    logic [31:0] RAM[127:0];

    initial begin
        $readmemh("riscvtest.txt", RAM);
    end

    assign rd = RAM[a[31:2]]; 	// word aligned

    always_ff @(posedge clk) begin
        if (we) RAM[a[31:2]] <= wd;
    end

endmodule
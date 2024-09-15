`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module alu(alu_if.alu aif);
    always_comb begin : OUT_LOGIC
        casez (aif.aluop)
            ALU_SLL:    aif.ALUout = aif.A << aif.B;
            ALU_SRL:    aif.ALUout = aif.A >> aif.B;
            ALU_SRA:    aif.ALUout = aif.A >>> aif.B;
            ALU_ADD:    aif.ALUout = aif.A + aif.B;
            ALU_SUB:    aif.ALUout = aif.A - aif.B;
            ALU_AND:    aif.ALUout = aif.A & aif.B;
            ALU_OR:     aif.ALUout = aif.A | aif.B;
            ALU_XOR:    aif.ALUout = (aif.A ^ aif.B);
            ALU_SLT:    aif.ALUout = (aif.A < aif.B)? 1 : 0;
            ALU_SLTU:   aif.ALUout = (unsigned'(aif.A) < unsigned'(aif.B))? 1 : 0;
            default:    aif.ALUout = 0;
        endcase
    end

    always_comb begin : OVERFLOW_LOGIC
        aif.overflow = 0;
        if (aif.aluop == ALU_ADD) begin
            aif.overflow = (aif.A[31] & aif.B[31] & ~aif.ALUout[31]) |
                        (~aif.A[31] & ~aif.B[31] & aif.ALUout[31]);
        end
        else if (aif.aluop == ALU_SUB) begin
            aif.overflow = (aif.A[31] & ~aif.B[31] & ~aif.ALUout[31]) |
                        (~aif.A[31] & aif.B[31] & aif.ALUout[31]);
        end
    end
    
    assign aif.zero = (aif.ALUout == 0);
    assign aif.negative = (aif.ALUout[31]);

endmodule
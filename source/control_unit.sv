`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module control_unit (control_unit_if.control_unit cuif);
    
    always_comb begin 
        // default values
        cuif.ALUSrc = 0;
        cuif.MemtoReg = 0;
        cuif.RegWrite = 0;
        cuif.MemWrite = 0;
        cuif.MemRead = 0;
        cuif.PCSrc = 0;
        cuif.Jump = 0;
        cuif.halt = 0;
        cuif.aluop = ALU_ADD;

        casez (cuif.opcode)
            RTYPE: begin
                cuif.RegWrite = 1;
                casez (cuif.funct3)
                    SLL:      cuif.aluop = ALU_SLL;
                    SRL_SRA:  cuif.aluop = (cuif.funct7==SRA)? ALU_SRA : ALU_SRL;
                    ADD_SUB:  cuif.aluop = (cuif.funct7==ADD)? ALU_ADD : ALU_SUB;
                    AND:      cuif.aluop = ALU_AND;
                    OR:       cuif.aluop = ALU_OR;
                    XOR:      cuif.aluop = ALU_XOR;
                    SLT:      cuif.aluop = ALU_SLT; 
                    SLTU:     cuif.aluop = ALU_SLTU;
                endcase
            end
            ITYPE: begin
                cuif.ALUSrc = 1;
                cuif.RegWrite = 1;
                casez (cuif.funct3)
                    ADDI:       cuif.aluop = ALU_ADD;
                    XORI:       cuif.aluop = ALU_XOR;
                    ORI:        cuif.aluop = ALU_OR;
                    ANDI:       cuif.aluop = ALU_AND;
                    SLLI:       cuif.aluop = ALU_SLL;
                    SRLI_SRAI:  cuif.aluop = (cuif.funct7==SRA)? ALU_SRA : ALU_SRL;
                    SLTI:       cuif.aluop = ALU_SLT;
                    SLTIU:      cuif.aluop = ALU_SLTU;
                endcase
            end
            ITYPE_LW: begin
                cuif.ALUSrc = 1;
                cuif.MemtoReg = 1;
                cuif.RegWrite = 1;
                cuif.MemRead = 1;
            end
            JALR, 
            JAL: begin
                cuif.RegWrite = 1;
                cuif.PCSrc = 1;
                cuif.Jump = 1;
            end
            STYPE: begin
                cuif.ALUSrc = 1;
                cuif.MemWrite = 1;
            end
            BTYPE: begin
                cuif.PCSrc = 1;
                casez (cuif.funct3)
                    BEQ: begin
                        cuif.aluop = ALU_SUB;
                        cuif.PCSrc = cuif.alu_zero;
                    end
                    BNE: begin
                        cuif.aluop = ALU_SUB;
                        cuif.PCSrc = ~cuif.alu_zero;
                    end
                    BLT: begin
                        cuif.aluop = ALU_SLT;
                        cuif.PCSrc = ~cuif.alu_zero;
                    end
                    BGE: begin
                        cuif.aluop = ALU_SLT;
                        cuif.PCSrc = cuif.alu_zero;
                    end
                    BLTU: begin
                        cuif.aluop = ALU_SLTU;
                        cuif.PCSrc = ~cuif.alu_zero;
                    end
                    BGEU: begin
                        cuif.aluop = ALU_SLTU;
                        cuif.PCSrc = cuif.alu_zero;
                    end
                endcase
            end
            LUI: begin
                cuif.RegWrite = 1;
            end
            AUIPC: begin
                cuif.RegWrite = 1;
            end
            HALT: cuif.halt = 1;
        endcase
    end
endmodule
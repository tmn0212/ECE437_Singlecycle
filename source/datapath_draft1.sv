/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // interfaces
  register_file_if rfif ();
  alu_if aif ();

  // pc init
  parameter PC_INIT = 0;

  // For decoding instruction
  opcode_t opcode;
  r_t r_i; // r-type
  i_t i_i; // i-type
  s_t s_i; // s-type
  b_t b_i; // b-type
  u_t u_i; // u-type
  word_t signext_imm12;
  word_t b_imm;

  word_t PC, next_PC; // Program Counter
  
  // Next Logic
  logic next_dmemWEN, next_dmemREN;
  word_t next_dmemaddr, next_dmemstore;
  
  // Assignments
  assign opcode = opcode_t'(dpif.imemload[6:0]); // Decode instr for opcode
  assign r_i = dpif.imemload;
  assign i_i = dpif.imemload;
  assign s_i = dpif.imemload;
  assign b_i = dpif.imemload;
  assign u_i = dpif.imemload;
  assign signext_imm12 = {{20{i_i.imm[11]}}, i_i.imm};
  assign dpif.imemaddr = PC; // Assign instruction address = PC

  register_file RF (CLK, nRST, rfif);

  alu A1 (aif);

  always_ff @ (posedge CLK, negedge nRST) begin 
    if (!nRST) begin
      PC <= PC_INIT;
      dpif.dmemWEN <= 0;
      dpif.dmemREN <= 0;
      dpif.dmemstore <= 0;
    end
    else begin 
      PC <= next_PC;
      dpif.dmemWEN <= next_dmemWEN;
      dpif.dmemREN <= next_dmemREN;
      dpif.dmemstore <= next_dmemstore;
    end
  end

  always_comb begin : ALUOP_COMB
  // Default values
    // Register File
    rfif.rsel1 = '0;
    rfif.rsel2 = '0;
    rfif.wsel = '0;
    rfif.wdat = '0;
    rfif.WEN = 0;

    // ALU
    aif.A = rfif.rdat1;
    aif.B = '0;
    aif.aluop = ALU_ADD;

    // datapath
    dpif.imemREN = 1;
    dpif.dmemaddr = '0;
    dpif.halt = 0;

    // Next Logic
    next_PC = PC;
    next_dmemWEN = dpif.dmemWEN;
    next_dmemREN = dpif.dmemREN;
    next_dmemstore = dpif.dmemstore;
    b_imm = '0;
  
  // When Instruction Ready, Execute:
    if (dpif.ihit) begin
      next_PC = PC + 4; // Increment PC for next instruction

      casez (opcode)
        RTYPE: begin
          rfif.rsel1 = r_i.rs1;
          rfif.rsel2 = r_i.rs2;
          aif.B = rfif.rdat2;       // ALUSrc = 0;
          
          casez (r_i.funct3)        // ALUop
            SLL:      aif.aluop = ALU_SLL;
            SRL_SRA:  aif.aluop = (funct7_srla_r_t'(r_i.funct7)==SRA)? ALU_SRA : ALU_SRL;
            ADD_SUB:  aif.aluop = (r_i.funct7==ADD)? ALU_ADD : ALU_SUB;
            AND:      aif.aluop = ALU_AND;
            OR:       aif.aluop = ALU_OR;
            XOR:      aif.aluop = ALU_XOR;
            SLT:      aif.aluop = ALU_SLT; 
            SLTU:     aif.aluop = ALU_SLTU;
          endcase

          rfif.wsel = r_i.rd;
          rfif.wdat = aif.ALUout;   // MemtoReg = 0;
          rfif.WEN = 1;             // RegWrite = 1;
        end
      
        ITYPE: begin
          rfif.rsel1 = i_i.rs1;
          aif.B = signext_imm12;    // ALUSrc = 1
          
          casez (i_i.funct3)
            ADDI:       aif.aluop = ALU_ADD;
            XORI:       aif.aluop = ALU_XOR;
            ORI:        aif.aluop = ALU_OR;
            ANDI:       aif.aluop = ALU_AND;
            SLLI:       aif.aluop = ALU_SLL;
            SRLI_SRAI:  begin
                          aif.aluop = (funct7_srla_r_t'(r_i.funct7)==SRA)? ALU_SRA : ALU_SRL;
                          aif.B = {{27{1'b0}}, i_i.imm[4:0]};
                        end
            SLTI:       aif.aluop = ALU_SLT;
            SLTIU:      aif.aluop = ALU_SLTU;
          endcase

          rfif.wsel = i_i.rd;
          rfif.wdat = aif.ALUout;   // MemtoReg = 0
          rfif.WEN = 1;             // RegWrite = 1
        end

        ITYPE_LW: begin
          next_PC = PC;
          rfif.rsel1 = i_i.rs1;
          aif.B = signext_imm12;    // ALUSrc = 1
          aif.aluop = ALU_ADD;      // ALUop
          dpif.dmemaddr = aif.ALUout;
          next_dmemREN = 1;
        end

        JALR: begin
          rfif.wsel = i_i.rd;
          rfif.wdat = PC + 4;
          rfif.rsel1 = i_i.rs1;
          rfif.WEN = 1;
          next_PC = rfif.rdat1 + signext_imm12;
        end

        STYPE: begin
          next_PC = PC;
          rfif.rsel1 = s_i.rs1;
          rfif.rsel2 = s_i.rs2;
          next_dmemstore = rfif.rdat2;
          aif.B = {{20{s_i.imm2[6]}}, s_i.imm2, s_i.imm1};
          aif.aluop = ALU_ADD;
          // Check if address is divisible by 4
          if (aif.ALUout % 4 == 0) begin
            dpif.dmemaddr = aif.ALUout;
            next_dmemWEN = 1;
          end
          else begin
            next_PC = PC + 4;
          end
        end

        BTYPE: begin
          rfif.rsel1 = b_i.rs1;
          rfif.rsel2 = b_i.rs2;
          aif.B = rfif.rdat2;
          b_imm = {{19{b_i.imm2[6]}}, b_i.imm2[6], b_i.imm1[0], b_i.imm2[5:0], b_i.imm1[4:1], 1'b0};
          casez (b_i.funct3)
            BEQ: begin
              aif.aluop = ALU_SUB;
              if (aif.zero) next_PC = PC + b_imm;
            end
            BNE: begin
              aif.aluop = ALU_SUB;
              if (!aif.zero) next_PC = PC + b_imm;
            end
            BLT: begin
              aif.aluop = ALU_SLT;
              if (aif.ALUout==1) next_PC = PC + b_imm;
            end
            BGE: begin
              aif.aluop = ALU_SLT;
              if (aif.ALUout!=1) next_PC = PC + b_imm;
            end
            BLTU: begin
              aif.aluop = ALU_SLTU;
              if (aif.ALUout==1) next_PC = PC + b_imm;
            end
            BGEU: begin
              aif.aluop = ALU_SLTU;
              if (aif.ALUout!=1) next_PC = PC + b_imm;
            end
          endcase
        end

        JAL: begin
          rfif.wsel = u_i.rd;
          rfif.wdat = PC + 4;
          rfif.WEN = 1;
          next_PC = PC + {{11{u_i.imm[19]}}, u_i.imm[19], u_i.imm[7:0], u_i.imm[8], u_i.imm[18:9], 1'b0};
        end

        LUI: begin
          next_PC = PC + 4;
          rfif.wsel = u_i.rd;
          rfif.wdat = {u_i.imm, 12'b0};
          rfif.WEN = 1;
        end

        AUIPC: begin
          next_PC = PC + 4;
          rfif.wsel = u_i.rd;
          rfif.wdat = PC + {u_i.imm, 12'b0};
          rfif.WEN = 1;
        end

        HALT: begin
          dpif.halt = 1;
        end


      endcase

    end

    else if (dpif.dhit) begin
      next_PC = PC + 4;   // Increment PC for LW/SW
      casez (opcode)  
        ITYPE_LW: begin
          next_dmemREN = 0;
          rfif.wsel = i_i.rd;
          rfif.wdat = dpif.dmemload;
          rfif.WEN = 1;
        end
        STYPE: begin
          next_dmemWEN = 0;
          rfif.WEN = 0;
        end
      endcase
    end
  end

endmodule

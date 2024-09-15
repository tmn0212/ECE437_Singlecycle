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
`include "control_unit_if.vh"
`include "request_block_if.vh"

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
  control_unit_if cuif ();
  request_block_if rbif ();

  // pc init
  parameter PC_INIT = 0;

  // Variables
  opcode_t opcode;
  r_t r_i; // r-type
  i_t i_i; // i-type
  s_t s_i; // s-type
  u_t u_i; // u-type
  word_t gen_imm;
  word_t PC, next_PC; // Program Counter

// Sub-modules inst.
  register_file RF (CLK, nRST, rfif);
  alu A1 (aif);
  control_unit CU (cuif);
  request_block RB (CLK, nRST, rbif);

// Assignments
  // Other
  assign r_i = dpif.imemload;
  assign i_i = dpif.imemload;
  assign s_i = dpif.imemload;
  assign u_i = dpif.imemload;
  assign opcode = r_i.opcode; // Decode instr for opcode

  // Register File assigns
  assign rfif.rsel1 = r_i.rs1;
  assign rfif.rsel2 = r_i.rs2;
  assign rfif.wsel = r_i.rd;
  assign rfif.WEN = (dpif.ihit | dpif.dhit)? cuif.RegWrite : 0;

  // ALU assigns
  assign aif.A = rfif.rdat1;
  assign aif.B = (!cuif.ALUSrc)? rfif.rdat2 : gen_imm;
  assign aif.aluop = cuif.aluop;

  // Control Unit assigns
  assign cuif.opcode = opcode;
  assign cuif.funct7 = r_i.funct7;
  assign cuif.funct3 = r_i.funct3;
  assign cuif.alu_zero = aif.zero;
  
  // Request Block assigns
  assign rbif.dhit = dpif.dhit;
  assign rbif.ihit = dpif.ihit;
  assign rbif.MemWrite = cuif.MemWrite;
  assign rbif.MemRead = cuif.MemRead;
  assign rbif.halt = cuif.halt;

  // Datapath assigns
  // assign dpif.halt = cuif.halt;
  assign dpif.dmemWEN = rbif.dmemWEN;
  assign dpif.dmemREN = rbif.dmemREN;
  assign dpif.imemREN = rbif.imemREN;
  assign dpif.imemaddr = PC; // Assign instruction address = PC
  assign dpif.dmemstore = (aif.ALUout % 4 == 0)? rfif.rdat2 : 0;
  assign dpif.dmemaddr = aif.ALUout;

// PC Register
  always_ff @ (posedge CLK, negedge nRST) begin 
    if (!nRST) begin
      PC <= PC_INIT;
      dpif.halt <= 0;
    end
    else if (dpif.ihit && !dpif.halt) begin
      if (!cuif.PCSrc) PC <= PC + 4;
      else PC <= next_PC;      
    end

    if (cuif.halt && !dpif.halt) dpif.halt <= 1;
  end

// Halt Register
  // always_ff @(negedge nRST, posedge cuif.halt) begin
  //   if (!nRST) dpif.halt <= 0;
  //   else if (cuif.halt) dpif.halt <= 1;
  // end

// Immediate Generator
  always_comb begin : IMM_GEN
    gen_imm = '0;
    casez (opcode)
      ITYPE:    gen_imm = (cuif.funct3!=SRLI_SRAI)? {{20{i_i.imm[11]}}, i_i.imm} : {{27{1'b0}}, i_i.imm[4:0]}; 
      ITYPE_LW, 
      JALR:     gen_imm = {{20{i_i.imm[11]}}, i_i.imm};
      STYPE:    gen_imm = {{20{s_i.imm2[6]}}, s_i.imm2, s_i.imm1};
      BTYPE:    gen_imm = {{19{s_i.imm2[6]}}, s_i.imm2[6], s_i.imm1[0], s_i.imm2[5:0], s_i.imm1[4:1], 1'b0};
      JAL:      gen_imm = {{11{u_i.imm[19]}}, u_i.imm[19], u_i.imm[7:0], u_i.imm[8], u_i.imm[18:9], 1'b0};
      LUI, 
      AUIPC:    gen_imm = {u_i.imm, 12'b0};
    endcase
  end

// Datapath Comb
  always_comb begin : DP_COMB
  // Default values
    next_PC = '0;
    rfif.wdat = aif.ALUout;
  
  // RF wdat
    if (cuif.MemtoReg) rfif.wdat = dpif.dmemload;
    else if (cuif.Jump) rfif.wdat = PC + 4;
    else if (opcode == LUI) rfif.wdat = gen_imm;
    else if (opcode == AUIPC) rfif.wdat = PC + gen_imm;
    
  // next_PC
    casez (opcode)
      JALR:   next_PC = rfif.rdat1 + gen_imm;
      BTYPE:  next_PC = PC + gen_imm;
      JAL:    next_PC = PC + gen_imm;
    endcase
  end

endmodule

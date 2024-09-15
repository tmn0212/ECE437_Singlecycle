/*
  Control Unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  opcode_t opcode;
  logic [6:0] funct7;
  logic [2:0] funct3;
  logic alu_zero;
  logic ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead;
  logic PCSrc, Jump, halt;
  aluop_t aluop;


  modport control_unit (
    input opcode, funct7, funct3, alu_zero,
    output ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead,
    output PCSrc, Jump, aluop, halt
  );
  
  modport control_unit_tb ( 
    input ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead,
    input PCSrc, Jump, aluop, halt,
    output opcode, funct7, funct3, alu_zero
  );

endinterface
`endif // CONTROL_UNIT_IF_VH


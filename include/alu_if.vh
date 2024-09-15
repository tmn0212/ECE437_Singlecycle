/*
  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;
  
  logic signed [31:0] A, B;
  aluop_t aluop;
  logic signed [31:0] ALUout;
  logic negative, overflow, zero;

  // register file ports
  modport alu (
    input   A, B, aluop,
    output  ALUout, negative, overflow, zero
  );
  // register file tb
  modport alu_tb (
    input   ALUout, negative, overflow, zero,
    output  A, B, aluop
  );
endinterface

`endif //ALU_IF_VH

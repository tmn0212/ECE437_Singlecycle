/*
  Request Block interface
*/
`ifndef REQUEST_BLOCK_IF_VH
`define REQUEST_BLOCK_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_block_if;
  // import types
  import cpu_types_pkg::*;

  logic dhit, ihit, MemWrite, MemRead, halt;
  logic dmemWEN, dmemREN, imemREN;

  modport request_block (
    input dhit, ihit, MemWrite, MemRead, halt,
    output dmemWEN, dmemREN, imemREN
  );
  
  modport request_block_tb (
    input dmemWEN, dmemREN, imemREN,
    output dhit, ihit, MemWrite, MemRead, halt
  );
endinterface
`endif // REQUEST_BLOCK_IF_VH


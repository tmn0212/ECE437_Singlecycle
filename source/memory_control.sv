/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

// type import
import cpu_types_pkg::*;

module memory_control (input logic CLK, nRST, cache_control_if.cc ccif);
  
  // number of cpus for cc
  parameter CPUS = 1;

  always_comb begin
    // Default values
    ccif.ramaddr = ccif.iaddr;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;
    ccif.iwait = 1;
    ccif.dwait = 1;
    ccif.iload = '0;
    ccif.dload = '0;
    ccif.ramstore = '0;

    // Prioritize D-request
    if (ccif.dWEN) begin
      ccif.ramaddr = ccif.daddr;
      ccif.ramWEN = 1;
      ccif.iload = '0;
      ccif.ramstore = ccif.dstore;
      if (ccif.ramstate==ACCESS) begin
        ccif.dwait = 0;
      end
    end
    else if (ccif.dREN) begin
      ccif.ramaddr = ccif.daddr;
      ccif.ramREN = 1;
      if (ccif.ramstate==ACCESS) begin
        ccif.dwait = 0;
        ccif.dload = ccif.ramload;
      end
    end
    // I-request next
    else if (ccif.iREN) begin
      ccif.ramREN = 1;
      if (ccif.ramstate==ACCESS) begin
        ccif.iwait = 0;
        ccif.iload = ccif.ramload;
      end
    end
  end
endmodule

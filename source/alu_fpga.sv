/*
  alu fpga wrapper
*/

// interface
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module alu_fpga (
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [3:0] LEDG,
  output logic [2:0] LEDR,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4
);

  // interface
  alu_if aif();
  // rf
  alu ALU(aif);

  logic [6:0] out_array [4:0];
  assign aif.aluop = aluop_t'(KEY[3:0]);
  assign LEDG[3:0] = KEY[3:0];
  assign aif.A = {15'b0, SW[16:0]};
  assign LEDR[2:0] = {aif.negative, aif.overflow, aif.zero};
  assign HEX0 = out_array[0];
  assign HEX1 = out_array[1];
  assign HEX2 = out_array[2];
  assign HEX3 = out_array[3];
  assign HEX4 = out_array[4];

  always_ff @ (posedge SW[17]) begin : REGISTER_B
    aif.B <= {15'b0, SW[16:0]};
  end
  
  always_comb begin
    int i;
    i = 0;
    unique casez (aif.ALUout[3:0])
        4'h0: out_array[i] = 7'b1000000;
        4'h1: out_array[i] = 7'b1111001;
        4'h2: out_array[i] = 7'b0100100;
        4'h3: out_array[i] = 7'b0110000;
        4'h4: out_array[i] = 7'b0011001;
        4'h5: out_array[i] = 7'b0010010;
        4'h6: out_array[i] = 7'b0000010;
        4'h7: out_array[i] = 7'b1111000;
        4'h8: out_array[i] = 7'b0000000;
        4'h9: out_array[i] = 7'b0010000;
        4'ha: out_array[i] = 7'b0001000;
        4'hb: out_array[i] = 7'b0000011;
        4'hc: out_array[i] = 7'b0100111;
        4'hd: out_array[i] = 7'b0100001;
        4'he: out_array[i] = 7'b0000110;
        4'hf: out_array[i] = 7'b0001110;
    endcase
    i = 1;
    unique casez (aif.ALUout[7:4])
        4'h0: out_array[i] = 7'b1000000;
        4'h1: out_array[i] = 7'b1111001;
        4'h2: out_array[i] = 7'b0100100;
        4'h3: out_array[i] = 7'b0110000;
        4'h4: out_array[i] = 7'b0011001;
        4'h5: out_array[i] = 7'b0010010;
        4'h6: out_array[i] = 7'b0000010;
        4'h7: out_array[i] = 7'b1111000;
        4'h8: out_array[i] = 7'b0000000;
        4'h9: out_array[i] = 7'b0010000;
        4'ha: out_array[i] = 7'b0001000;
        4'hb: out_array[i] = 7'b0000011;
        4'hc: out_array[i] = 7'b0100111;
        4'hd: out_array[i] = 7'b0100001;
        4'he: out_array[i] = 7'b0000110;
        4'hf: out_array[i] = 7'b0001110;
    endcase

    i = 2;
    unique casez (aif.ALUout[11:8])
        4'h0: out_array[i] = 7'b1000000;
        4'h1: out_array[i] = 7'b1111001;
        4'h2: out_array[i] = 7'b0100100;
        4'h3: out_array[i] = 7'b0110000;
        4'h4: out_array[i] = 7'b0011001;
        4'h5: out_array[i] = 7'b0010010;
        4'h6: out_array[i] = 7'b0000010;
        4'h7: out_array[i] = 7'b1111000;
        4'h8: out_array[i] = 7'b0000000;
        4'h9: out_array[i] = 7'b0010000;
        4'ha: out_array[i] = 7'b0001000;
        4'hb: out_array[i] = 7'b0000011;
        4'hc: out_array[i] = 7'b0100111;
        4'hd: out_array[i] = 7'b0100001;
        4'he: out_array[i] = 7'b0000110;
        4'hf: out_array[i] = 7'b0001110;
    endcase

    i = 3;
    unique casez (aif.ALUout[15:12])
        4'h0: out_array[i] = 7'b1000000;
        4'h1: out_array[i] = 7'b1111001;
        4'h2: out_array[i] = 7'b0100100;
        4'h3: out_array[i] = 7'b0110000;
        4'h4: out_array[i] = 7'b0011001;
        4'h5: out_array[i] = 7'b0010010;
        4'h6: out_array[i] = 7'b0000010;
        4'h7: out_array[i] = 7'b1111000;
        4'h8: out_array[i] = 7'b0000000;
        4'h9: out_array[i] = 7'b0010000;
        4'ha: out_array[i] = 7'b0001000;
        4'hb: out_array[i] = 7'b0000011;
        4'hc: out_array[i] = 7'b0100111;
        4'hd: out_array[i] = 7'b0100001;
        4'he: out_array[i] = 7'b0000110;
        4'hf: out_array[i] = 7'b0001110;
    endcase

    i = 4;
    unique casez (aif.ALUout[19:16])
        4'h0: out_array[i] = 7'b1000000;
        4'h1: out_array[i] = 7'b1111001;
        4'h2: out_array[i] = 7'b0100100;
        4'h3: out_array[i] = 7'b0110000;
        4'h4: out_array[i] = 7'b0011001;
        4'h5: out_array[i] = 7'b0010010;
        4'h6: out_array[i] = 7'b0000010;
        4'h7: out_array[i] = 7'b1111000;
        4'h8: out_array[i] = 7'b0000000;
        4'h9: out_array[i] = 7'b0010000;
        4'ha: out_array[i] = 7'b0001000;
        4'hb: out_array[i] = 7'b0000011;
        4'hc: out_array[i] = 7'b0100111;
        4'hd: out_array[i] = 7'b0100001;
        4'he: out_array[i] = 7'b0000110;
        4'hf: out_array[i] = 7'b0001110;
    endcase
  end

endmodule
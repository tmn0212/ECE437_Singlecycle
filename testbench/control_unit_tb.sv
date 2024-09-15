/*
   Control Unit test bench
*/

// mapped needs this
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  // interface
  control_unit_if cuif ();
  // test program
  test PROG ();
  // DUT
  control_unit CU (cuif);
  
endmodule

program test;

  // Test Variables
  string tb_test_case;
  int tb_test_case_num;
  logic tb_check, tb_error;
  
  int n_type = 0;

  logic tb_expected_ALUSrc, tb_expected_MemtoReg, tb_expected_RegWrite;
  logic tb_expected_MemWrite, tb_expected_MemRead, tb_expected_PCSrc;
  logic tb_expected_Jump, tb_expected_halt;
  aluop_t tb_expected_aluop;

  opcode_t tb_array_opcode [0:9] = {
    RTYPE,
    ITYPE,
    ITYPE_LW,
    JALR,
    STYPE,
    BTYPE,
    JAL,
    LUI,
    AUIPC,
    HALT
  };

  logic [2:0] tb_array_funct3_r [0:9] = {
    SLL,
    SRL_SRA,
    SRL_SRA,
    ADD_SUB,
    ADD_SUB,
    AND,
    OR,
    XOR,
    SLT,
    SLTU
  };

  aluop_t tb_array_aluop_r [0:9] = {
    ALU_SLL,
    ALU_SRL,
    ALU_SRA,
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
    ALU_SLT,
    ALU_SLTU
  };

  logic [2:0] tb_array_funct3_i [0:8] = {
    ADDI,
    XORI,
    ORI,
    ANDI,
    SLLI,
    SRLI_SRAI,
    SRLI_SRAI,
    SLTI,
    SLTIU
  };

  aluop_t tb_array_aluop_i [0:8] = {
    ALU_ADD,
    ALU_XOR,
    ALU_OR,
    ALU_AND,
    ALU_SLL,
    ALU_SRL,
    ALU_SRA,
    ALU_SLT,
    ALU_SLTU
  };

  logic [2:0] tb_array_funct3_b [0:5] = {
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU
  };

  aluop_t tb_array_aluop_b [0:5] = {
    ALU_SUB,
    ALU_SUB,
    ALU_SLT,
    ALU_SLT,
    ALU_SLTU,
    ALU_SLTU
  };

  task reset_dut;
    begin
      cuif.opcode = RTYPE;
      cuif.funct7 = '0;
      cuif.funct3 = '0;
      cuif.alu_zero = 0;
      #(0.5);
    end
  endtask

  task reset_expected;
    begin
        tb_expected_ALUSrc = 0;
        tb_expected_MemtoReg = 0;
        tb_expected_RegWrite = 0;
        tb_expected_MemWrite = 0;
        tb_expected_MemRead = 0;
        tb_expected_PCSrc = 0;
        tb_expected_Jump = 0; 
        tb_expected_halt = 0;
        tb_expected_aluop = ALU_ADD;
    end
  endtask

  task check_outputs;
    begin
      #(1);
      tb_check = 1;
      tb_error = 0;
      $display("Test %00d: %s @%00g", tb_test_case_num, tb_test_case, $time);
      if (cuif.ALUSrc != tb_expected_ALUSrc) begin
        tb_error = 1;
        $display("  Fail: incorrect ALUSrc");
      end
      else 
        $display("  Success: correct ALUSrc");

      if (cuif.MemtoReg != tb_expected_MemtoReg) begin
        tb_error = 1;
        $display("  Fail: incorrect MemtoReg");
      end
      else
        $display("  Success: correct MemtoReg");

      if (cuif.RegWrite != tb_expected_RegWrite) begin
        tb_error = 1;
        $display("  Fail: incorrect RegWrite");
      end
      else
        $display("  Success: correct RegWrite");

      if (cuif.MemWrite != tb_expected_MemWrite) begin
        tb_error = 1;
        $display("  Fail: incorrect MemWrite");
      end
      else
        $display("  Success: correct MemWrite");

      if (cuif.MemRead != tb_expected_MemRead) begin
        tb_error = 1;
        $display("  Fail: incorrect MemRead");
      end
      else
        $display("  Success: correct MemRead");

      if (cuif.PCSrc != tb_expected_PCSrc) begin
        tb_error = 1;
        $display("  Fail: incorrect PCSrc");
      end
      else
        $display("  Success: correct PCSrc");
      
      if (cuif.Jump != tb_expected_Jump) begin
        tb_error = 1;
        $display("  Fail: incorrect Jump");
      end
      else
        $display("  Success: correct Jump");

      if (cuif.aluop != tb_expected_aluop) begin
        tb_error = 1;
        $display("  Fail: incorrect aluop");
      end
      else
        $display("  Success: correct aluop");

      if (cuif.halt != tb_expected_halt) begin
        tb_error = 1;
        $display("  Fail: incorrect halt");
      end
      else
        $display("  Success: correct halt");

      #(1);
      tb_check = 0;
      tb_error = 0;
    end
  endtask

  

  initial begin

//*****************************************************************************
// Initialization
//*****************************************************************************
    tb_test_case = "Init";
    tb_test_case_num = -1;
    tb_check = 0;
    tb_error = 0;
    reset_expected();
    
    #(1); // wait some time before testing

//*****************************************************************************
// Test case 1: RTYPE
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "RTYPE";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_RegWrite = 1;
    for (int i = 0; i < $size(tb_array_funct3_r); i+=1) begin
        cuif.funct3 = tb_array_funct3_r[i];
        casez (i)
            1: cuif.funct7 = SRL;
            2: cuif.funct7 = SRA;
            3: cuif.funct7 = ADD;
            4: cuif.funct7 = SUB;
        endcase
        tb_expected_aluop = tb_array_aluop_r[i];

        check_outputs();    
        #(1);
    end
    
    #(1);

//*****************************************************************************
// Test case 2: ITYPE
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "ITYPE";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_RegWrite = 1;
    tb_expected_ALUSrc = 1;
    for (int i = 0; i < $size(tb_array_funct3_i); i+=1) begin
        cuif.funct3 = tb_array_funct3_i[i];
        casez (i)
            5: cuif.funct7 = SRL;
            6: cuif.funct7 = SRA;
        endcase
        tb_expected_aluop = tb_array_aluop_i[i];

        check_outputs();    
        #(1);
    end
    
    #(1);

//*****************************************************************************
// Test case 3: ITYPE_LW
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "ITYPE_LW";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_RegWrite = 1;
    tb_expected_ALUSrc = 1;
    tb_expected_MemtoReg = 1;
    tb_expected_MemRead = 1;
    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 4: JALR
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "JALR";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_Jump = 1;
    tb_expected_RegWrite = 1;
    tb_expected_PCSrc = 1;
    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 5: STYPE
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "STYPE";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_ALUSrc = 1;
    tb_expected_MemWrite = 1;
    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 6: BTYPE
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "BTYPE";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    

    for (int i = 0; i < $size(tb_array_funct3_b); i+=1) begin
        // Not Taken
        casez (tb_array_funct3_b[i])
            BNE, BLT, BLTU: cuif.alu_zero = 1;
            BEQ, BGE, BGEU: cuif.alu_zero = 0;
        endcase
        cuif.funct3 = tb_array_funct3_b[i];
        tb_expected_PCSrc = 0;
        tb_expected_aluop = tb_array_aluop_b[i];
        check_outputs();    
        #(1);

        // Taken
        cuif.alu_zero = ~cuif.alu_zero;
        cuif.funct3 = tb_array_funct3_b[i];
        tb_expected_PCSrc = 1;
        tb_expected_aluop = tb_array_aluop_b[i];
        check_outputs();    
        #(1);
    end
    
    #(1);

//*****************************************************************************
// Test case 7: JAL
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "JAL";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_Jump = 1;
    tb_expected_RegWrite = 1;
    tb_expected_PCSrc = 1;
    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 8: LUI
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "LUI";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_RegWrite = 1;
    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 9: AUIPC
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "AUIPC";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_RegWrite = 1;    
    check_outputs();
    
    #(1);

//*****************************************************************************
// Test case 10: HALT
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "HALT";
    reset_expected();
    reset_dut();
    
    cuif.opcode = tb_array_opcode[n_type++];
    tb_expected_halt = 1;
    
    check_outputs();
    
    #(1);

  end
endprogram
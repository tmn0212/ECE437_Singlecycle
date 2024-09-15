/*
  ALU test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  // interface
  alu_if aif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  alu DUT(aif);
`else
  alu DUT(
    .\aif.A (aif.A),
    .\aif.B (aif.B),
    .\aif.aluop (aif.aluop),
    .\aif.ALUout (aif.ALUout),
    .\aif.negative (aif.negative),
    .\aif.overflow (aif.overflow),
    .\aif.zero (aif.zero)
  );
`endif
endmodule

program test;

  // Test Variables
  string tb_test_case;
  int tb_test_case_num;
  logic signed [31:0] tb_expected_ALUout;
  logic tb_expected_negative, tb_expected_overflow, tb_expected_zero;
  logic tb_check, tb_error;
  
  logic signed [31:0] tb_array_A [19:0] = {
    32'h861C3B45,  // 2248733429
    32'h872C7E1D,  // 2268711357
    32'h15D9D23D,  // 366245437
    32'hDD57A810,  // 3713924464
    32'h6418C839,  // 1679844409
    32'hA9777CFF,  // 2843132559
    32'h83F090BB,  // 2213622667
    32'hF54D9C35,  // 4115781909
    32'hC0D01558,  // 3233766056
    32'hFB675F5C,  // 4217597708
    32'h36E99657,  // 920646647
    32'h0A603A14,  // 173909636
    32'h24834063,  // 612171427
    32'hEFCD3C1D,  // 4022111949
    32'hB66D8B36,  // 3061423830
    32'h4BCA28F7,  // 1271468839
    32'hE97BE676,  // 3920024230
    32'h3F2D23C4,  // 1059426372
    32'h5C8FA36E,  // 1554038750
    32'hE9794293   // 3917162851
  };

  logic signed [31:0] tb_array_B [19:0] = {
    32'hA94F395C,  // 2839571900
    32'h78DC18D8,  // 2026255976 (overflow with 32'h872C7E1D)
    32'h3C772716,  // 1014532054
    32'h22924C02,  // 581042930 (overflow with 32'hDD57A810)
    32'h46822883,  // 1183703875
    32'h569C1F04,  // 1451834740 (overflow with 32'hA9777CFF)
    32'h67342C07,  // 1729973191
    32'h0AA17F13,  // 179185475 (overflow with 32'hF54D9C35)
    32'h3078B57F,  // 812932159
    32'h049B78DF,  // 77369631 (overflow with 32'hFB675F5C)
    32'hC1A52A29,  // 3248459241
    32'hF5B0F22F,  // 4121057743 (overflow with 32'h0A603A14)
    32'h59311C29,  // 1495983337
    32'h10403172,  // 272855394 (overflow with 32'hEFCD3C1D)
    32'h145B4E3B,  // 341074379
    32'hB409AEEE,  // 3023498478 (overflow with 32'h4BCA28F7)
    32'h2775C133,  // 661667187
    32'hC0B3D545,  // 3235540949 (overflow with 32'h3F2D23C4)
    32'h0B129B77,  // 185709495
    32'h167B8D0D   // 377804493 (overflow with 32'hE9794293)
  };

  logic signed [31:0] tb_array_C [19:0] = { 
        7, 18, 5, 24, 31, 14, 23, 10, 2, 19, 
        27, 4, 11, 20, 8, 15, 3, 30, 12, 25 
  };

  task reset_dut;
    begin
      aif.A = '0;
      aif.B = '0;
      aif.aluop = ALU_SLL;
      #(0.5);
    end
  endtask

  task calc_overflow();
    begin
      if (aif.aluop == ALU_ADD) begin
            tb_expected_overflow = (~aif.A[31] & ~aif.B[31] & aif.ALUout[31]) |  
                              (aif.A[31] & aif.B[31] & ~aif.ALUout[31]);   
      end 
      else if (aif.aluop == ALU_SUB) begin
            tb_expected_overflow = (aif.A[31] & ~aif.B[31] & ~aif.ALUout[31]) |  
                              (~aif.A[31] & aif.B[31] & aif.ALUout[31]);
      end  
    end
  endtask

  task check_outputs;
    begin
      #(1);
      tb_check = 1;
      tb_error = 0;
      $display("Test %00d: %s @%00g", tb_test_case_num, tb_test_case, $time);
      if (aif.ALUout != tb_expected_ALUout) begin
        tb_error = 1;
        $display("  Fail: incorrect ALUout");
      end
      else 
        $display("  Success: correct ALUout");

      if (aif.negative != tb_expected_negative) begin
        tb_error = 1;
        $display("  Fail: incorrect Negative");
      end
      else
        $display("  Success: correct Negative");

      if (aif.overflow != tb_expected_overflow) begin
        tb_error = 1;
        $display("  Fail: incorrect overflow");
      end
      else
        $display("  Success: correct overflow");

      if (aif.zero != tb_expected_zero) begin
        tb_error = 1;
        $display("  Fail: incorrect zero");
      end
      else
        $display("  Success: correct zero");
      #(1);
      tb_check = 0;
      tb_error = 0;
    end
  endtask

  task test_multiple_inputs(
    input logic signed [31:0] tb_A [19:0], 
    input logic signed [31:0] tb_B [19:0]
  );
    begin
      for (int i = 0; i < $size(tb_A); i+=1) begin
        aif.A = tb_A[i];
        aif.B = tb_B[i];
        
        casez (aif.aluop) 
          ALU_SLL:    tb_expected_ALUout = aif.A << aif.B;
          ALU_SRL:    tb_expected_ALUout = aif.A >> aif.B;
          ALU_SRA:    tb_expected_ALUout = aif.A >>> aif.B;
          ALU_ADD:    tb_expected_ALUout = aif.A + aif.B;
          ALU_SUB:    tb_expected_ALUout = aif.A - aif.B;
          ALU_AND:    tb_expected_ALUout = aif.A & aif.B;
          ALU_OR:     tb_expected_ALUout = aif.A | aif.B;
          ALU_XOR:    tb_expected_ALUout = ~(aif.A | aif.B);
          ALU_SLT:    tb_expected_ALUout = (aif.A < aif.B)? 1 : 0;
          ALU_SLTU:   tb_expected_ALUout = (unsigned'(aif.A) < unsigned'(aif.B))? 1 : 0;
          default:    tb_expected_ALUout = 0;
        endcase

        tb_expected_negative = (tb_expected_ALUout < 0);
        tb_expected_zero = (tb_expected_ALUout == 0);

        #(0.1);
        calc_overflow();
        check_outputs();
        #(1);
      end
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
    tb_expected_ALUout = '0;
    tb_expected_negative = 0;
    tb_expected_overflow = 0;
    tb_expected_zero = 0;
    
    #(1); // wait some time before testing

//*****************************************************************************
// Test case 1: Add
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Add";

    reset_dut();
    
    aif.aluop = ALU_ADD;

    test_multiple_inputs(tb_array_A, tb_array_B);
    
    #(1);
    

//*****************************************************************************
// Test case 2: Subtract
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Subtract";

    reset_dut();
    
    aif.aluop = ALU_SUB;
    
    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);

//*****************************************************************************
// Test case 3: Test Overflow Cornercase
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Overflow Cornercase";

    reset_dut();

    aif.aluop = ALU_ADD;
    aif.A = 32'h7fffffff;
    aif.B = 32'd1;

    #(1);

    tb_expected_ALUout = aif.A + aif.B;
    tb_expected_negative = 1;
    tb_expected_overflow = 1;
    tb_expected_zero = 0;
    check_outputs();

    #(1);

    aif.aluop = ALU_SUB;
    aif.A = 32'h80000000;
    aif.B = 32'd1;

    #(1);

    tb_expected_ALUout = aif.A - aif.B;
    tb_expected_negative = 0;
    tb_expected_overflow = 1;
    tb_expected_zero = 0;
    check_outputs();

    #(1);
    

//*****************************************************************************
// Test case 4: Test Zero Output
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Zero Output";

    reset_dut();

    aif.aluop = ALU_SUB;
    
    test_multiple_inputs(tb_array_A, tb_array_A);

    #(1);


//*****************************************************************************
// Test case 5: Shift Left Logical
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Shift Left Logical";

    reset_dut();

    aif.aluop = ALU_SLL;

    test_multiple_inputs(tb_array_A, tb_array_C);

    #(1);
    

//*****************************************************************************
// Test case 6: Shift Right Logical
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Shift Right Logical";

    reset_dut();

    aif.aluop = ALU_SRL;

    test_multiple_inputs(tb_array_A, tb_array_C);

    #(1);

//*****************************************************************************
// Test case 7: Shift Right Arith.
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Shift Right Arith.";

    reset_dut();

    aif.aluop = ALU_SRA;

    test_multiple_inputs(tb_array_A, tb_array_C);

    #(1);

//*****************************************************************************
// Test case 8: AND
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "AND";

    reset_dut();

    aif.aluop = ALU_AND;

    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);

//*****************************************************************************
// Test case 9: OR
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "OR";

    reset_dut();

    aif.aluop = ALU_OR;

    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);

//*****************************************************************************
// Test case 10: XOR
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "XOR";

    reset_dut();

    aif.aluop = ALU_XOR;

    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);

//*****************************************************************************
// Test case 11: Set Less Than
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Set Less Than";

    reset_dut();

    aif.aluop = ALU_SLT;

    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);

//*****************************************************************************
// Test case 12: Set Less Than Unsigned
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Set Less Than Unsigned";

    reset_dut();

    aif.aluop = ALU_SLTU;

    test_multiple_inputs(tb_array_A, tb_array_B);

    #(1);


  end
endprogram

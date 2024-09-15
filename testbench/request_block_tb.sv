/*
  reqeuest_block test bench
*/

// mapped needs this
`include "request_block_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_block_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  request_block_if rbif ();
  // test program
  test PROG (CLK, nRST);
  // DUT
  request_block RB (CLK, nRST, rbif);

endmodule

program test (
  input logic CLK,
  output logic nRST
);

  // Test Variables
  string tb_test_case;
  int tb_test_case_num;
  logic tb_check;
  logic tb_error;
  logic tb_expected_dmemWEN, tb_expected_dmemREN, tb_expected_imemREN;


  task reset_dut;
    begin
      // Activate the reset
      nRST = 1'b0;

      // Maintain the reset for more than one cycle
      @(posedge CLK);
      @(posedge CLK);

      // Wait until safely away from rising edge of the clock before releasing
      @(negedge CLK);
      nRST = 1'b1;

      // Leave out of reset for a couple cycles before allowing other stimulus
      // Wait for negative clock edges, 
      // since inputs to DUT should normally be applied away from rising clock edges
      @(negedge CLK);
      @(negedge CLK);
    end
  endtask


  task check_outputs;
    begin
      tb_check = 1'b1;
      tb_error = 1'b0;

      $display("Test %00d: %s @%00g", tb_test_case_num, tb_test_case, $time);
      if (rbif.dmemWEN != tb_expected_dmemWEN) begin
        tb_error = 1;
        $display("  Fail: incorrect dmemWEN");
      end
      else 
        $display("  Success: correct dmemWEN");

      if (rbif.dmemREN != tb_expected_dmemREN) begin
        tb_error = 1;
        $display("  Fail: incorrect dmemREN");
      end
      else
        $display("  Success: correct dmemREN");

      if (rbif.imemREN != tb_expected_imemREN) begin
        tb_error = 1;
        $display("  Fail: incorrect imemREN");
      end
      else
        $display("  Success: correct imemREN");

      #(1);
      tb_check = 0;
      tb_error = 0;
      
    end
  endtask

  task reset_tb;
    begin
      tb_expected_dmemWEN = 0;
      tb_expected_dmemREN = 0;
      tb_expected_imemREN = 0;
    end
  endtask

  task reset_inputs;
    begin
        rbif.ihit = 0;
        rbif.dhit = 0;
        rbif.MemWrite = 0;
        rbif.MemRead = 0;
        rbif.halt = 0;
    end
  endtask

  task wait_clk;
    begin
      @(negedge CLK);
    end
  endtask

  initial begin

//*****************************************************************************
// Initialization
//*****************************************************************************
    tb_test_case = "Init";
    tb_test_case_num = -1;
    tb_check = 1'b0;
    tb_error = 1'b0;
    reset_tb();
    reset_inputs();
    #(1); // wait some time before testing

//*****************************************************************************
// Test case 1: Power-on Reset
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Power-on Reset";
    reset_tb();
    reset_inputs();
    reset_dut();
    tb_expected_imemREN = 1;
    check_outputs();
    #(0.5);
    reset_tb();

//*****************************************************************************
// Test case 2: Instruction Read
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Instruction Read";
    reset_tb();
    reset_inputs();
    reset_dut();

    @(negedge CLK);
    rbif.ihit = 1;
    @(posedge CLK);
    
    tb_expected_imemREN = 1;
    check_outputs();
    #(0.5);
    reset_tb();

//*****************************************************************************
// Test case 3: Mem Read
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Mem Read";
    reset_tb();
    reset_inputs();
    reset_dut();

    @(negedge CLK);
    rbif.ihit = 1;
    @(posedge CLK);
    
    tb_expected_imemREN = 1;
    @(negedge CLK);
    rbif.ihit = 1;
    rbif.halt = 0;
    rbif.MemRead = 1;
    @(posedge CLK);
    tb_expected_dmemREN = 1;
    rbif.ihit = 0;
    check_outputs();

    @(posedge CLK);
    @(posedge CLK); 
    @(negedge CLK);
    rbif.dhit = 1;
    @(posedge CLK);
    tb_expected_dmemREN = 0;
    rbif.dhit = 0;
    check_outputs();

    #(0.5);
    reset_tb();

//*****************************************************************************
// Test case 4: Mem Write
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Mem Write";
    reset_tb();
    reset_inputs();
    reset_dut();

    @(negedge CLK);
    rbif.ihit = 1;
    @(posedge CLK);
    
    tb_expected_imemREN = 1;
    @(negedge CLK);
    rbif.ihit = 1;
    rbif.halt = 0;
    rbif.MemWrite = 1;
    @(posedge CLK);
    tb_expected_dmemWEN = 1;
    rbif.ihit = 0;
    check_outputs();

    @(posedge CLK);
    @(posedge CLK); 
    @(negedge CLK);
    rbif.dhit = 1;
    @(posedge CLK);
    tb_expected_dmemWEN = 0;
    rbif.dhit = 0;
    check_outputs();

    #(0.5);
    reset_tb();

//*****************************************************************************
// Test case 5: Halt
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Halt";
    reset_tb();
    reset_inputs();
    reset_dut();

    @(negedge CLK);
    rbif.halt = 1;
    @(posedge CLK);
    check_outputs();

    #(0.5);
    reset_tb();


  end
endprogram
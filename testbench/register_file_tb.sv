/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

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
  word_t tb_expected_rdat1;
  word_t tb_expected_rdat2;
  word_t tb_array_reg_value [31:0];
  word_t tb_array_reg_addr [31:0];


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

      if (tb_expected_rdat1 == rfif.rdat1 && tb_expected_rdat2 == rfif.rdat2) begin
        $display("Pass Test %00d: Correct rdat1,rdat2 @%00g", tb_test_case_num, $time);
      end
      else begin
        $write("Fail Test %00d: Incorrect", tb_test_case_num);
        if (tb_expected_rdat1 != rfif.rdat1) begin
          tb_error = 1'b1;
          $write(" rdat1");
        end
        $write(",");
        if (tb_expected_rdat1 != rfif.rdat1) begin
          tb_error = 1'b1;
          $write("rdat2");
        end
        $display(" @%00g", $time);
      end
    end
  endtask

  task reset_tb;
    begin
      tb_check = 1'b0;
      tb_error = 1'b0;
      tb_expected_rdat1 = '0;
      tb_expected_rdat2 = '0;
    end
  endtask

  task wait_clk;
    begin
      @(negedge CLK);
    end
  endtask

  task reset_outputs;
    begin
      rfif.wdat = '0;
      rfif.wsel = '0;
      rfif.WEN = 0;
      rfif.rsel1 = '0;
      rfif.rsel2 = '0;
    end
  endtask

  task write_check_multiple_regs;
    begin
      @(negedge CLK);
      rfif.WEN = 1; // Set sel outputs
      for (int i = 0; i < $size(tb_array_reg_value); i+=1) begin
        rfif.wsel = tb_array_reg_addr[i];
        rfif.wdat = tb_array_reg_value[i];
        
        @(negedge CLK);
        
        rfif.rsel1 = tb_array_reg_addr[i];
        if (i != 0)
          rfif.rsel2 = tb_array_reg_addr[i-1];
        
        #(0.5);
        
        if (rfif.rsel1 == 0) begin
          tb_expected_rdat1 = 0;
          tb_expected_rdat2 = tb_array_reg_value[i-1];
          check_outputs();
        end
        else if (rfif.rsel2 == 0) begin
          tb_expected_rdat1 = tb_array_reg_value[i];
          tb_expected_rdat2 = 0;
          check_outputs();
        end
        else begin
          tb_expected_rdat1 = tb_array_reg_value[i];
          tb_expected_rdat2 = tb_array_reg_value[i-1];
          check_outputs();
        end

        #(0.5);
        reset_tb();
      end
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
    tb_expected_rdat1 = '0;
    tb_expected_rdat2 = '0;

    rfif.wdat = '0;
    rfif.wsel = '0;
    rfif.WEN = 0;
    rfif.rsel1 = '0;
    rfif.rsel2 = '0;
    #(1); // wait some time before testing

//*****************************************************************************
// Test case 1: Power-on Reset
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Power-on Reset";

    reset_dut();
    tb_expected_rdat1 = '0;
    tb_expected_rdat2 = '0;
    check_outputs();
    #(0.5);
    reset_tb();

//*****************************************************************************
// Test case 2: Test write to register 0
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Write Reg 0";

    reset_dut();
    #(0.1); // Wait after reset dut
    // Set outputs
    rfif.wdat = 32'h01234567;
    rfif.WEN = 1;
    rfif.wsel = 0;
    rfif.rsel1 = 0;
    rfif.rsel2 = 0;
    wait_clk(); // Wait next clock
    // Check
    tb_expected_rdat1 = '0;
    tb_expected_rdat2 = '0;
    check_outputs();
    #(0.5);
    reset_tb();
    reset_outputs();

//*****************************************************************************
// Test case 3: Test write read
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Test write read";

    reset_dut();
    #(0.1); // Wait after reset dut
    // Set outputs
    rfif.wdat = 32'h98765432;
    rfif.WEN = 1;
    rfif.wsel = 32'd27;
    rfif.rsel1 = rfif.wsel;
    rfif.rsel2 = rfif.wsel;
    wait_clk(); // wait next clock
    // Check
    tb_expected_rdat1 = rfif.wdat;
    tb_expected_rdat2 = rfif.wdat;
    check_outputs();
    #(0.5);
    reset_tb();
    reset_outputs();

//*****************************************************************************
// Test case 4: Test write with WEN disables
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Test write with WEN=0";

    reset_dut();
    #(0.1); // Wait after reset dut
    // Set outputs
    rfif.wdat = 32'h15161718;
    rfif.WEN = 0;
    rfif.wsel = 32'd11;
    rfif.rsel1 = rfif.wsel;
    rfif.rsel2 = rfif.wsel;
    wait_clk(); // wait next clock
    // Check
    tb_expected_rdat1 = '0;
    tb_expected_rdat2 = '0;
    check_outputs();
    #(0.5);
    reset_tb();
    reset_outputs();

//*****************************************************************************
// Test case 5: Test write read multiple
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Write Read Multiple";

    reset_dut();
    #(0.1); // Wait after reset dut
    // Set test variables
    for (int i = 0; i < $size(tb_array_reg_value); i+=1) begin
      if(i == 0) 
        tb_array_reg_value[i] = 32'h00001111;
      else
        tb_array_reg_value[i] = tb_array_reg_value[i-1] + 7;
    end

    tb_array_reg_addr = {29, 13, 4, 12, 24, 22, 30, 0, 8, 10, 14, 6, 11, 17, 5, 21, 27, 7, 20, 1, 16, 28, 15, 25, 18, 23, 3, 19, 9, 2, 26, 31};

    write_check_multiple_regs();
    reset_tb();
    reset_outputs();

//*****************************************************************************
// Test case 6: ?????
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "???????";

    reset_dut();
    #(0.1); // Wait after reset dut

  end
endprogram

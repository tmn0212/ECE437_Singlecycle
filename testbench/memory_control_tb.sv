/*
  Minh Nguyen

  memory control test bench
*/

// mapped needs this
`include "caches_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;
  logic RAMCLK = 0;
  logic [1:0] count = '0;

  // clock
  always #(PERIOD/4) begin
    count++;
    RAMCLK++;
    if (count%2 > 0) CLK++;
  end

  // interface
  caches_if cif0 ();
  caches_if cif1 ();
  cache_control_if ccif (cif0, cif1);
  cpu_ram_if ramif ();

  // test program
  test PROG (CLK, RAMCLK, nRST);

  // DUT
  memory_control DUT (CLK, nRST, ccif);

  // Memory   
  ram MEM(RAMCLK, nRST, ramif);

endmodule

program test (
    input logic CLK,
    input logic RAMCLK,
    output logic nRST
);

    // Test Variables
    string tb_test_case;
    int tb_test_case_num;
    logic tb_check;
    logic tb_error;
    word_t tb_expected_iload, tb_expected_dload, tb_expected_ramstore, tb_expected_ramaddr;
    logic tb_expected_iwait, tb_expected_dwait, tb_expected_ramREN, tb_expected_ramWEN;
    string tb_request;
    word_t unknown_val = '0;

    // RAM Variables
    // funct7_r_t tb_funct7;
    // funct3_r_t tb_funct3;
    // opcode_t tb_opcode;
    // logic []
    i_t tb_instr;

    word_t tb_array_A [19:0] = {
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

    word_t tb_array_B [19:0] = {
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

    word_t tb_array_C [0:7] = {
        32'h00001261,
        32'h00000009,
        32'h00010A5A,
        32'h00000740,
        32'hFFFFDA70,
        32'h000037F8,
        32'h0000D156,
        32'h000D2690
    };

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
            #(0.1);
            tb_check = 1;
            tb_error = 0;
            $display("Test %00d: %s @%00g", tb_test_case_num, tb_test_case, $time);
            if (cif0.iload != tb_expected_iload) begin
                tb_error = 1;
                $display("  Fail: incorrect iload");
            end
            else $display("  Success: correct iload");

            if (cif0.iwait != tb_expected_iwait) begin
                tb_error = 1;
                $display("  Fail: incorrect iwait");
            end
            else $display("  Success: correct iwait");

            if (cif0.dload != tb_expected_dload) begin
                tb_error = 1;
                $display("  Fail: incorrect dload");
            end
            else $display("  Success: correct dload");

            if (cif0.dwait != tb_expected_dwait) begin
                tb_error = 1;
                $display("  Fail: incorrect dwait");
            end
            else $display("  Success: correct dwait");

            if (ccif.ramREN != tb_expected_ramREN) begin
                tb_error = 1;
                $display("  Fail: incorrect ramREN");
            end
            else $display("  Success: correct ramREN");

            if (ccif.ramWEN != tb_expected_ramWEN) begin
                tb_error = 1;
                $display("  Fail: incorrect ramWEN");
            end
            else $display("  Success: correct ramWEN");

            if (ccif.ramstore != tb_expected_ramstore) begin
                tb_error = 1;
                $display("  Fail: incorrect ramstore");
            end
            else $display("  Success: correct ramstore");

            if (ccif.ramaddr != tb_expected_ramaddr) begin
                tb_error = 1;
                $display("  Fail: incorrect ramaddr");
            end
            else $display("  Success: correct ramaddr");

            #(0.5);
            tb_check = 0;
            tb_error = 0;
        end
    endtask

    task reset_tb_expected;
        begin
            tb_expected_iload = 0;
            tb_expected_dload = 0;
            tb_expected_ramstore = 0;
            tb_expected_ramaddr = 0;
            tb_expected_iwait = 0;
            tb_expected_dwait = 1;
            tb_expected_ramREN = 0;
            tb_expected_ramWEN = 0;
            tb_request = "N/A";
        end
    endtask

    task reset_dut_inputs;
        begin
            cif0.iREN = 0;
            cif0.iaddr = '0;
            cif0.dREN = 0;
            cif0.dWEN = 0;
            cif0.dstore = '0;
            cif0.daddr = '0;
            ccif.ramstate = FREE;
            ccif.ramload = '0;
        end
    endtask

    task I_request(input word_t iaddr, iload);
        begin
            tb_request = "I";
            @(posedge CLK);
            cif0.dREN = 0;
            cif0.iREN = 1;
            cif0.dWEN = 0;
            cif0.dstore = '0;
            cif0.iaddr = iaddr;
            ccif.ramstate = BUSY;
            ccif.ramload = unknown_val;
            cif0.daddr = '0;
            tb_expected_ramaddr = iaddr;
            tb_expected_iload = '0;
            tb_expected_iwait = 1;
            tb_expected_ramREN = 1;
            check_outputs();

            @(posedge RAMCLK);
            ccif.ramstate = ACCESS;
            ccif.ramload = iload;
            tb_expected_iload = iload;
            tb_expected_iwait = 0;
            check_outputs();
            reset_tb_expected();
        end
    endtask

    task D_read_request(
        input word_t daddr, dload,
        input logic last_check
    );
        begin
            tb_request = "DR";
            @(posedge CLK);
            cif0.iREN = 1;
            cif0.dREN = 1;
            cif0.dWEN = 0;
            ccif.ramstate = BUSY;
            ccif.ramload = unknown_val;
            cif0.daddr = daddr;
            tb_expected_ramaddr = daddr;
            tb_expected_dload = '0;
            tb_expected_iwait = 1;
            tb_expected_dwait = 1;
            tb_expected_ramREN = 1;
            check_outputs();

            @(posedge RAMCLK);
            ccif.ramstate = ACCESS;
            ccif.ramload = dload;
            tb_expected_dload = dload;
            tb_expected_dwait = 0;
            tb_expected_ramREN = 1;
            check_outputs();
            
            if (last_check) begin
                @(posedge RAMCLK);
                cif0.dREN = 0;
                ccif.ramstate = BUSY;
                ccif.ramload = unknown_val;
                cif0.daddr = '0;
                tb_expected_ramaddr = cif0.iaddr;
                tb_expected_dload = '0;
                tb_expected_dwait = 1;
                tb_expected_ramREN = 1;
                check_outputs();
            end
            reset_tb_expected();
        end
    endtask

    task D_write_request(
        input word_t daddr, dstore,
        input logic last_check
    );
        begin
            tb_request = "DW";
            @(posedge CLK);
            cif0.iREN = 1;
            cif0.dREN = 0;
            cif0.dWEN = 1;
            ccif.ramstate = BUSY;
            ccif.ramload = unknown_val;
            cif0.daddr = daddr;
            tb_expected_ramaddr = daddr;
            cif0.dstore = dstore;
            tb_expected_ramstore = dstore;
            tb_expected_dload = '0;
            tb_expected_iwait = 1;
            tb_expected_dwait = 1;
            tb_expected_ramREN = 0;
            tb_expected_ramWEN = 1;
            check_outputs();

            @(posedge RAMCLK);
            ccif.ramstate = ACCESS;
            tb_expected_dwait = 0;
            tb_expected_ramREN = 0;
            tb_expected_ramWEN = 1;
            check_outputs();
            
            if (last_check) begin
                @(posedge RAMCLK);
                cif0.dWEN = 0;
                ccif.ramstate = BUSY;
                cif0.dstore = '0;
                cif0.daddr = '0;
                tb_expected_ramaddr = cif0.iaddr;
                tb_expected_ramstore = '0;
                tb_expected_dload = '0;
                tb_expected_dwait = 1;
                tb_expected_ramREN = 1;
                tb_expected_ramWEN = 0;
                check_outputs();
            end
            reset_tb_expected();            
        end
    endtask

    task automatic dump_memory();
        string filename = "memcpu.hex";
        int memfd;

        // syif.tbCTRL = 1;
        cif0.iaddr = 0;
        cif0.dREN = 0;
        cif0.dWEN = 0;
        cif0.iREN = 0;

        memfd = $fopen(filename,"w");
        if (memfd)
        $display("Starting memory dump.");
        else
        begin $display("Failed to open %s.",filename); $finish; end

        for (int unsigned i = 0; memfd && i < 16384; i++)
        begin
        int chksum = 0;
        bit [7:0][7:0] values;
        string ihex;

        cif0.iaddr = i << 2;
        cif0.iREN = 1;
        repeat (4) @(posedge RAMCLK);
        if (cif0.iload === 0)
            continue;
        values = {8'h04,16'(i),8'h00,cif0.iload};
        foreach (values[j])
            chksum += values[j];
        chksum = 16'h100 - chksum;
        ihex = $sformatf(":04%h00%h%h",16'(i),cif0.iload,8'(chksum));
        $fdisplay(memfd,"%s",ihex.toupper());
        end //for
        if (memfd) begin
            // syif.tbCTRL = 0;
            cif0.iREN = 0;
            $fdisplay(memfd,":00000001FF");
            $fclose(memfd);
            $display("Finished memory dump.");
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
    reset_tb_expected();

    nRST = 0;
    reset_dut_inputs();
    #(1); // wait some time before testing


//*****************************************************************************
// Test case 1: Power-on Reset
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Power-on Reset";
    ccif.ramload = '1;
    
    reset_dut();
    reset_tb_expected();
    tb_expected_iwait = 1;
    check_outputs();    
    #(0.5);


//*****************************************************************************
// Test case 2: Power-on Reset
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "I-Request";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    for (int i = 0; i < $size(tb_array_A); i+=1) begin
        I_request(tb_array_B[i], tb_array_A[i]);
    end   

    #(0.5);


//*****************************************************************************
// Test case 3: D-request Read
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "D-request Read";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    for (int i = 0; i < $size(tb_array_A); i+=1) begin
        D_read_request(tb_array_B[i], tb_array_A[i], 1);
    end   

    #(0.5);

//*****************************************************************************
// Test case 3: D-request Write
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "D-request Write";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    for (int i = 0; i < $size(tb_array_A); i+=1) begin
        D_write_request(tb_array_B[i], tb_array_A[i], 1);
        @(posedge CLK);
    end   

    #(0.5);


//*****************************************************************************
// Test case 4: D-request combined (Read-Write loop)
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "D-request Read-Write";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    for (int i = 0; i < $size(tb_array_A); i+=1) begin
        D_read_request(tb_array_B[i], tb_array_A[i], 1);
        D_write_request(tb_array_B[i], tb_array_A[i], 1);
    end   

    #(0.5);

//*****************************************************************************
// Test case 5: D-request & I-request combined 
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "I & D Combined";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    for (int i = 0; i < $size(tb_array_A); i+=1) begin
        I_request(tb_array_B[i], tb_array_A[i]);
        D_read_request(tb_array_B[i], tb_array_A[i], 1);
        I_request(tb_array_B[i], tb_array_A[i]);
        D_write_request(tb_array_B[i], tb_array_A[i], 1);
    end   

    #(0.5);


//*****************************************************************************
// Test case 6: Lab Manual Replica
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Lab Manual Replica";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    I_request(tb_array_B[0], tb_array_A[0]);
    I_request(tb_array_B[1], tb_array_A[1]);
    D_read_request(tb_array_B[2], tb_array_A[2], 0);
    I_request(tb_array_B[3], tb_array_A[3]);
    I_request(tb_array_B[4], tb_array_A[4]);
    @(posedge CLK);
    I_request(tb_array_B[5], tb_array_A[5]);
    I_request(tb_array_B[6], tb_array_A[6]);
    D_write_request(tb_array_B[7], tb_array_A[7], 0);
    I_request(tb_array_B[8], tb_array_A[8]);
    I_request(tb_array_B[9], tb_array_A[9]);

    #(5);


//*****************************************************************************
// Test case 7: Test with RAM
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Manual Test with RAM";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    // RAM output
    assign ccif.ramstate = ramif.ramstate;
    assign ccif.ramload = ramif.ramload;
    // input to RAM (assign ramif)
    assign ramif.ramREN = ccif.ramREN;
    assign ramif.ramWEN = ccif.ramWEN;
    assign ramif.ramstore = ccif.ramstore;
    assign ramif.ramaddr = ccif.ramaddr;
    assign tb_instr = cif0.iload;

    #(1);
    @(negedge CLK);
    cif0.iREN = 1;
    cif0.iaddr = 0;

    @(posedge CLK);
    cif0.iREN = 1;
    cif0.iaddr = 4;

    @(posedge CLK);
    cif0.iREN = 1;
    cif0.iaddr = 8;

    @(posedge CLK);
    cif0.iREN = 1;
    cif0.iaddr = 12;

    @(posedge CLK);
    cif0.iREN = 1;
    cif0.iaddr = 16;

    // Manual Write to Memory to simulate memsim.hex
    for (int i = 0; i < 8; i++) begin
        @(posedge CLK);
        cif0.iREN = 1;
        cif0.dWEN = 1;
        cif0.daddr = 32'h704 + (i<<2);
        cif0.dstore = tb_array_C[i];

        // @(posedge CLK);
        // @(posedge CLK);
        // @(posedge CLK);
        // @(posedge CLK);
    end

    // @(posedge CLK);
    // cif0.iREN = 1;
    // cif0.dWEN = 1;
    // cif0.daddr = 32'h704;
    // cif0.dstore = 32'h00001261;

    @(posedge CLK);
    

    #(5);


//*****************************************************************************
// Test case 8: Dump Mem
//*****************************************************************************
    tb_test_case_num = tb_test_case_num + 1;
    tb_test_case = "Dump Mem";

    reset_dut_inputs();
    reset_dut();
    reset_tb_expected();

    dump_memory();

end

endprogram
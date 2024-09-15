`include "request_block_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module request_block (input logic CLK, nRST, request_block_if.request_block rbif);
    // assign rbif.imemREN = 1; // Always assert imemREN
    always_ff @ (posedge CLK, negedge nRST) begin
        if (!nRST) begin // nRST Default Values
            rbif.dmemWEN <= 0;
            rbif.dmemREN <= 0;
            rbif.imemREN <= 0;
        end
        else begin
            if (!rbif.halt) rbif.imemREN <= 1;
            else rbif.imemREN <= 0;

            if (rbif.ihit && !rbif.halt) begin // Assert when MemRead and MemWrite assert
                if (rbif.MemRead) rbif.dmemREN <= 1;
                else if (rbif.MemWrite) rbif.dmemWEN <= 1;
            end
            else if (rbif.dhit) begin // Deassert when D-access done
                if (rbif.MemRead) rbif.dmemREN <= 0; 
                else if (rbif.MemWrite) rbif.dmemWEN <= 0; 
            end
        end
    end
endmodule
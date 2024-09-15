`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file(input logic CLK, nRST, register_file_if.register_file rfif);
    word_t Reg [31:0];
    
    always_ff @ (posedge CLK, negedge nRST) begin : NEXT_REG
        if(!nRST) begin
            for (int i = 0; i < $size(Reg); i += 1) begin
                Reg[i] <= '0;
            end
        end
        else begin
            if (rfif.WEN && rfif.wsel != 0)
                Reg[rfif.wsel] <= rfif.wdat;
        end
    end

    always_comb begin : READ_LOGIC
        rfif.rdat1 = Reg[rfif.rsel1];
        rfif.rdat2 = Reg[rfif.rsel2];
    end
endmodule 
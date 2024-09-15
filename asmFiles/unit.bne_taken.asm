#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 3: BNE taken
#--------------------------------------
    org 0x0000
    ori $12, $0, -1000    # 1st number to compare
    ori $13, $0, 1294   # 2nd number to compare
    ori $10, $0, 0xFFFF # store result with defined value
    ori $21, $0, 0x44  # Address to store

    bne $12, $13, taken

not_taken:
    ori $10, $0, 0
    sw $10, 0($21)
    halt

taken:
    ori $10, $0, 1
    sw $10, 0($21)
    halt

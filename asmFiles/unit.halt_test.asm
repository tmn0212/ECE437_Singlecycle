#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 3: HALT Test
#--------------------------------------
    org 0x0000
    ori $12, $0, 2   # 1st number to compare
    ori $13, $0, 3   # 2nd number to compare
    ori $10, $0, 0xFFFF   # store result with defined value
    ori $21, $0, 0x177  # Address to store

    ori $14, $0, 4

    sw $12, 0($21)
    sw $13, 4($21)
    sw $14, 8($21)

    add $12, $0, $0   
    add $13, $0, $0
    add $14, $0, $0

    halt

    sw $0, 0($21) # if not execute halt correctly, all the mem vals turn to 0
    sw $0, 4($21)
    sw $0, 8($21)

    halt

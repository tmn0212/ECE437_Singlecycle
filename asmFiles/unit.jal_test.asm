#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 3: JAL test
#--------------------------------------
    org 0x0000
    ori $12, $0, 0xFFFF   # 1st number to compare
    ori $13, $0, 0xFFFF   # 2nd number to compare
    ori $10, $0, 0xFFFF   # store result with defined value
    ori $21, $0, 0x888  # Address to store

    jal $12, jump1
    sw $12, 0($21)      # if sw stores 0xFFFF, it's wrong
    sw $13, 4($21)
    halt

jump1:
    jal $13, jump2
    sw $12, 0($21)
    sw $13, 4($21)
    halt

jump2: 
    jal $14, jump3
    sw $12, 0($21)
    sw $13, 4($21)
    halt

jump3:
    ori $12, $0, 1  # if sw stores 1, it's right
    ori $13, $0, 1 
    sw $12, 0($21)
    sw $13, 4($21)
    halt

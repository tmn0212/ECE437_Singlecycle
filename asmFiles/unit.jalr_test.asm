#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 3: JALR test
#--------------------------------------
    org 0x0000
    ori $12, $0, 0xFFFF   # 1st number to compare
    ori $13, $0, 0xFFFF   # 2nd number to compare
    ori $10, $0, 0xFFFF   # store result with defined value
    ori $21, $0, 0x80  # Address to store

    jal $12, jump1
    ori $10, $0, 1      # if jalr corrects, $10 = 1
    sw $10, 0($21)
    halt

jump1:
    jalr $13, 0($12)

    halt

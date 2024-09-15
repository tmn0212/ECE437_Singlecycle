#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 2: Program 1: Multiply Algorithm
#--------------------------------------
    org 0x0000

    # initialize all inputs to function
    ori $2, $0, 0xFFFC          # set stack pointer to 0xFFFC
    ori $12, $0, 61             # load in 1st operand = 10
    ori $13, $0, 5              # load in 2nd operand = 3
    ori $10, $0, 0              # $10 = return values of the multiply

    # main function
main:
    push $12                    # push 1st operand to stack
    push $13                    # push 2nd operand to stack
    push $0                     # push return val to stack
    jal $1, multiply            # ret val = multiply();
    addi $2, $2, 12             # clear stack
    halt                        # end main

multiply:                       # func w/ 1 output = return val / mult. result
    lw $28, 8($2)               # load temp1 = 1st operand
    lw $29, 4($2)               # load temp2 = 2nd operand
    lw $30, 0($2)               # load temp3 = return val / mult result
    beqz $29, multiply_done     # if (2nd operand == 0) branch : cont.
    add $30, $30, $28           # mult. result + 1st operand
    addi $29, $29, -1           # decrement 2nd operand
    sw $30, 0($2)               # store return val to stack
    sw $29, 4($2)               # store 2nd operand val to stack
    j multiply                  # jump to multiply without storing ret addr

multiply_done:
    lw $10, 0($2)               # return(mult. result);
    ret                         # return back to main




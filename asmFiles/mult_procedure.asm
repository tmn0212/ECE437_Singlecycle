#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 2: Program 2: Multiple Procedure
#--------------------------------------
    org 0x0000

    # initialize all inputs to function
    ori $2, $0, 0xFFFC          # set stack pointer to 0xFFFC
    ori $12, $0, 60             # load in 1st operand = 10
    ori $13, $0, 3              # load in 2nd operand = 3
    ori $14, $0, 9              # load in 3rd operand = 9
    ori $15, $0, 22             # load in 4th operand = 11
    ori $10, $0, 0              # $10 = return values of the multiply

    # main function
main:
    push $15
    push $14
    push $13
    push $12
    addi $16, $0, 3             # counter to keep track operands (4-1) in stack
    jal $1, multiply_procedure
    pop $10                     # store ret val and clear stack
    halt

multiply_procedure:
    beqz $16, procedure_done    # if there's no operands in stack, done
    pop $12                     # init operand 1 for multiply
    pop $13                     # init operand 2 for multiply
    add $10, $0, $0             # init output
    addi $16, $16, -1

multiply:
    beqz $13, multiply_done     # if (2nd operand == 0) branch : cont.
    add $10, $10, $12           # mult. result + 1st operand
    addi $13, $13, -1           # decrement 2nd operand
    j multiply                  # jump to multiply without storing ret addr

multiply_done:
    push $10                    # push mult result to stack
    j multiply_procedure        # back to the next operand

procedure_done:
    ret

    

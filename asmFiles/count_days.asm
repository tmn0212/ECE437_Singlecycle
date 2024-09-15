#----------------------------------------------------------
# RISC-V Assembly
#----------------------------------------------------------
#--------------------------------------
# Lab 2: Program 3: Calculate Days
#--------------------------------------
    org 0x0000

    # initialize all inputs to function
    ori $2, $0, 0xFFFC          # set stack pointer to 0xFFFC
    ori $12, $0, 25             # load current day = 25
    ori $13, $0, 8              # load current month = 8
    ori $14, $0, 2024           # load current year = 2024

    # main function
main:
    addi $11, $12, 0 # store result days
    
    # calculate 30 * (CurrentMonth - 1)
    addi $13, $13, -1
    addi $28, $0, 30
    push $13
    push $28
    addi $16, $0, 1 # counter to keep track operands (2-1) in stack
    jal $1, multiply_procedure
    pop $10                     # store ret val and clear stack
    add $11, $11, $10

    # calculate 365 * (CurrentYear - 2000)
    addi $14, $14, -2000
    addi $28, $0, 365
    push $14
    push $28
    addi $16, $0, 1 # set all multiply has only 2 operands
    jal $1, multiply_procedure
    lw $28, 0($2)
    pop $10                     # store ret val and clear stack
    add $11, $11, $10           # RESULT stores at $11

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

    

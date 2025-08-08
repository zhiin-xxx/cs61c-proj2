.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0,x0,1
    blt a1,t0,fault
    addi t0,x0,0
loop_start:
    slli t1,t0,2
    bge t0,a1,loop_end
    add t1,a0,t1
    lw t2,0(t1)  # Load the current element
    bge t2, x0, loop_continue  # If t2 >= 0, skip negation
    sw x0,0(t1)
    j loop_start
loop_continue:
    addi t0,t0,1
    j loop_start
fault:
    li a0,36
    j exit
loop_end:


    # Epilogue


    jr ra

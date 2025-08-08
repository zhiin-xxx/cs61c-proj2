.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================

argmax:
    # Prologue
    addi sp,sp,-8
    sw s0,0(sp)
    sw s1,4(sp)
    # s0=a0[0]
    lw s0,0(a0)  
    addi s1,x0,0
     #检查
    addi t0,x0,1
    blt a1,t0,fault
    #从1开始
    addi t0,x0,1
loop_start:
    slli t1,t0,2
    bge t0,a1,loop_end #结束循环
    add t1,a0,t1
    lw t2,0(t1)  # a0[t0]
    bge s0,t2,loop_continue
    #更新
    addi s0,t2,0
    addi s1,t0,0  # s1=t0
loop_continue:
    addi t0,t0,1
    j loop_start
fault:
    li a0,36
    j exit
loop_end:
    addi a0,s1,0
    # Epilogue
    addi sp,sp,+8
    lw s0,0(sp)
    lw s1,4(sp)
    jr ra
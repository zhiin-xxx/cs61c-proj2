.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi sp,sp,-20
    sw s0,0(sp)  # Save s0
    sw s1,4(sp)  # Save s1
    sw s3,8(sp)  # Save s2
    sw s4,12(sp)  # Save s2
    sw s2,16(sp)  # Save s2

    # Prologue
    addi s2,x0,1
    blt a2,s2,fault1
    blt a3,s2,fault2
    blt a4,s2,fault2

    addi t0,x0,0 #i
    addi t1,x0,0 #j
    addi t2,x0,0 #sum
    addi t5,x0,1
loop_start:
    bgt t5,a2,loop_end
    slli t3,t0,2
    slli t4,t1,2
    add s0,t3,a0
    add s1,t4,a1

    lw s3,0(s0) #arr0[i]
    lw s4,0(s1) #arr1[j]
    mul s3,s3,s4 #arr0[i] * arr1[j]
    add t2,t2,s3 #sum += arr0[i] * arr1[j]
    #ebreak
    add t0,t0,a3
    add t1,t1,a4
    addi t5,t5,1
    j loop_start
fault1:
    li a0,36
    j exit
fault2:
    li a0,37
    j exit
loop_end:
    addi a0,t2,0  # Return the sum in a0
    # Epilogue
    lw s0,0(sp)  # Save s0
    lw s1,4(sp)  # Save s1
    lw s3,8(sp)  # Save s2
    lw s4,12(sp)  # Save s2
    lw s2,16(sp)  # Save s2
    addi sp,sp,+20
    jr ra

.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Prologue
    addi sp,sp,-16
    sw s0,0(sp)  
    sw s1,4(sp)  
    sw s2,8(sp)  
    sw ra,12(sp)  

# Error checks
    addi s0,x0,1
    blt a1,s0, fault # m0_height < 1
    blt a2,s0, fault # m0_width < 1
    blt a4,s0, fault # m1_height < 1
    blt a5,s0, fault # m1_width < 1
    beq a2,a4,Start 
    j fault
Start:
    #for(int i = 0; i < m0_height; i++) {
    addi s0,x0,0 #i
outer_loop_start:
    addi s1,x0,0 #j
    #for(int j = 0; j < m1_width; j++) {
inner_loop_start:
    # Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
    mul t0,s0,a2 # t0 = i * m0_width
    slli t0,t0,2
    add t1,a0,t0 # t1 = m0 + i * m0_width * 4
    slli t2,s1,2
    add t3,a3,t2 # t3 = m1 + j
   
    addi sp,sp,-28
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw a5,20(sp)
    sw a6,24(sp)
    addi a0,t1,0
    addi a1,t3,0
    addi a2,a2,0
    addi a3,x0,1
    addi a4,a5,0
    #ebreak
    call dot 
    addi s2,a0,0 #s2
    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    lw a4,16(sp)
    lw a5,20(sp)
    lw a6,24(sp)
    addi sp,sp,28

    #d[i][j]
    slli t0,s0,2 # t0 = i * 4 
    mul t0,t0,a5 # t0 = i * m1_width * 4
    add t0,a6,t0 # t0 = d + i * 4
    slli t1,s1,2 # t1 = j * 4
    add t0,t0,t1 # t0 = d + i * 4 + j * 4
    sw s2,0(t0) # d[i][j]

    addi s1,s1,1 # j++
    blt s1,a5,inner_loop_start
inner_loop_end:
    # }
    addi s0,s0,1 #i++
    blt s0,a1,outer_loop_start
    j end
outer_loop_end:
    #}
fault:
    li a0,38
    j exit
end:
    # Epilogue
    lw s0,0(sp)  
    lw s1,4(sp)  
    lw s2,8(sp)  
    lw ra,12(sp)  
    addi sp,sp,16

    jr ra

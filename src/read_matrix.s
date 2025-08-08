.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp,sp,-24
    sw ra,8(sp)
    sw s0,4(sp)
    sw s1,0(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)

    addi sp,sp,-8
    sw a1,0(sp)
    sw a2,4(sp)

    li a1,0
    call fopen
    #ebreak
    li t0, -1
    beq a0,t0, error_fopen

    lw a1,0(sp)
    lw a2,4(sp)
    addi sp,sp,8

    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    li a2,4         
    call fread
    #ebreak
    li t0, 4
    bne a0,t0, error_read

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12

    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    addi a1,a2,0    
    li a2,4         
    call fread
    #ebreak
    li t0, 4
    bne a0,t0, error_read

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    lw s2, 0(a1)
    lw s3, 0(a2)
    mul s0,s3,s2  
    addi s4,s0,0
    slli s0,s0,2  

    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    addi a0,s0,0
    call malloc
    #ebreak
    li t0, 0
    beq a0,t0, error_malloc
    addi s1,a0,0

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    addi a1,s1,0
    addi a2,s0,0         
    call fread
    #ebreak
    bne a0,s0, error_read

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    call fclose
    li t0, 0
    bne a0,t0, error_fclose
    j my_exit

error_fopen:
    li a0,27
    j exit
error_read:
    li a0,29
    j exit
error_malloc:
    li a0,26
    j exit
error_fclose:
    li a0,28
    j exit
my_exit:
    addi a0,s1,0 

    lw ra,8(sp)
    lw s0,4(sp)
    lw s1,0(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    addi sp,sp,24
    #ebreak
    jr ra

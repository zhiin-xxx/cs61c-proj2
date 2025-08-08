.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp,sp,-24
    sw ra,8(sp)
    sw s0,4(sp)
    sw s1,0(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
#
    addi sp,sp,-12
    sw a1,0(sp)
    sw a2,4(sp)
    sw a3,8(sp)

    li a1,1
    call fopen
    #ebreak
    li t0, -1
    beq a0,t0, error_fopen

    lw a1,0(sp)
    lw a2,4(sp)
    lw a3,8(sp)
    addi sp,sp,12
#
    addi sp,sp,-8
    sw a2,0(sp)
    sw a3,4(sp)
    addi s0,sp,0
    addi s1,sp,4
    mul s2,a2,a3
#
    addi sp,sp,-16
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)

    addi a1,s0,0
    li a2,1
    li a3,4
    #ebreak
    call fwrite
    #ebreak
    li t0, 1
    bne a0,t0, error_fwrite

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    addi sp,sp,16
#
    addi sp,sp,-16
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)

    addi a1,s1,0
    li a2,1
    li a3,4
    #ebreak
    call fwrite
    #ebreak
    li t0, 1
    bne a0,t0, error_fwrite

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    addi sp,sp,16
#
    addi sp,sp,-16
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)

    addi a2,s2,0
    li a3,4
    #ebreak
    call fwrite
    #ebreak
    bne a0,s2, error_fwrite

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    addi sp,sp,16
#
    addi sp,sp,8
#
    #ebreak
    call fclose
    li t0, 0
    bne a0,t0, error_fclose
    j my_exit

error_fopen:
    li a0,27
    j exit
error_fwrite:
    li a0,30
    j exit
error_fclose:
    li a0,28
    j exit
my_exit:
    # Epilogue
    lw ra,8(sp)
    lw s0,4(sp)
    lw s1,0(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    addi sp,sp,24
    #ebreak
    jr ra

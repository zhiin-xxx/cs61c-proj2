.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # Read pretrained m0
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
    
    addi sp,sp,-52
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw s0,12(sp)
    sw s1,16(sp)
    sw s2,20(sp)
    sw s3,24(sp)
    sw s4,28(sp)
    sw s5,32(sp)
    sw s6,36(sp)
    sw s7,40(sp)
    sw s8,44(sp)
    sw ra,48(sp)

    li t0,5
    bne a0,t0,error_argc

    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    lw t0,4(a1)  
    addi a0,t0,0
    addi sp,sp,-8
    addi a1,sp,0
    addi a2,sp,4
    #ebreak

    call read_matrix
    #ebreak
    #指向矩阵的指针
    addi s6,a0,0 #存放矩阵的位置
    lw s0,0(sp)  #矩阵m0的行列
    lw s1,4(sp)
    addi sp,sp,8
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    # Read pretrained m1
    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    lw t0,8(a1)  
    addi a0,t0,0
    addi sp,sp,-8
    addi a1,sp,0
    addi a2,sp,4
    #ebreak

    call read_matrix
    #ebreak
    #指向矩阵的指针
    addi s7,a0,0 #存放矩阵的位置
    lw s2,0(sp)  
    lw s3,4(sp)
    addi sp,sp,8
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    # Read input matrix
    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    lw t0,12(a1)  
    addi a0,t0,0
    addi sp,sp,-8
    addi a1,sp,0
    addi a2,sp,4
    #ebreak

    call read_matrix
    #ebreak
    #指向矩阵的指针
    addi s8,a0,0 #存放矩阵的位置
    lw s4,0(sp)  
    lw s5,4(sp)
    addi sp,sp,8

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    # Compute h = matmul(m0, input)
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
    addi sp,sp,-12
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)

    #
    addi sp,sp,-24
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw a5,20(sp)
        mul t0,s0,s5
        slli a0,t0,2
        #ebreak

        call malloc
        #ebreak
        li t0, 0
        beq a0,t0, error_malloc
        addi a6,a0,0
    addi a0,s6,0
    lw a1,4(sp)
    lw a2,8(sp)
    addi a3,s8,0
    lw a4,16(sp)
    lw a5,20(sp)
    addi sp,sp,24
      #
    addi a0,s6,0
    addi a3,s8,0
    addi a1,s0,0
    addi a2,s1,0
    addi a4,s4,0
    addi a5,s5,0
    #ebreak

    call matmul
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    addi sp,sp,12
    # Compute h = relu(h)
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
    addi sp,sp,-16
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a6,12(sp)

    addi a0,a6,0
    mul t0,s0,s5
    addi a1,t0,0
    #ebreak

    call relu
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a6,12(sp)
    addi sp,sp,16
    # Compute o = matmul(m1, h)
    addi sp,sp,-16
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a6,12(sp)
    #
    addi sp,sp,-28
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw a5,20(sp)
    sw a6,24(sp)

        mul t0,s2,s5
        slli a0,t0,2
        #ebreak

        call malloc
        #ebreak
        li t0, 0
        beq a0,t0, error_malloc
        addi a7,a0,0
    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    lw a4,16(sp)
    lw a5,20(sp)
    lw a6,24(sp)
    addi sp,sp,28
      #
    lw t0,8(a1)
    addi a0,s7,0
    addi a3,a6,0
    addi a1,s2,0
    addi a2,s3,0
    addi a4,s0,0
    addi a5,s5,0
    addi a6,a7,0
    #ebreak

    call matmul
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a6,12(sp)
    addi sp,sp,16

    # Write output matrix o
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
    addi sp,sp,-32
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw a5,20(sp)
    sw a6,24(sp)
    sw a7,28(sp)

    lw t0,16(a1)
    addi a0,t0,0
    addi a1,a7,0
    addi a2,s2,0
    addi a3,s5,0
    #ebreak

    call write_matrix
    #ebreak

    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    lw a4,16(sp)
    lw a5,20(sp)
    lw a6,24(sp)
    lw a7,28(sp)
    addi sp,sp,32
    # Compute and return argmax(o)
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
    addi sp,sp,-32
    sw a1,4(sp)
    sw a2,8(sp)
    sw a3,12(sp)
    sw a4,16(sp)
    sw a5,20(sp)
    sw a6,24(sp)
    sw a7,28(sp)

    addi a0,a7,0
    mul t0,s2,s5
    addi a1,t0,0
    #ebreak
    call argmax
    #ebreak
    addi t0,a0,0

    lw a1,4(sp)
    lw a2,8(sp)
    lw a3,12(sp)
    lw a4,16(sp)
    lw a5,20(sp)
    lw a6,24(sp)
    lw a7,28(sp)
    addi sp,sp,32
    # If enabled, print argmax(o) and newline
    ebreak
    li t1,1
    beq a2,t1,my_end
print:
# void print_int(int a0)
# Prints the integer in a0.
# args:
#   a0 = integer to print
# return:
#   void
    addi sp,sp,-8
    sw a0,0(sp)
    sw a1,4(sp)

    
    addi a0,t0,0
    call print_int

    ebreak
    addi sp,sp,-4
    addi a0,sp,0
    li t1,10
    sw t1,0(sp)
    call print_str
    addi sp,sp,4

    lw a0,0(sp)
    lw a1,4(sp)
    addi sp,sp,8
    j my_end
# void print_str(char *a0)
# Prints the null-terminated string at address a0.
# args:
#   a0 = address of the string you want printed.
# return:
#   void
error_malloc:
    li a0,26
    j exit
error_argc:
    li a0,31
    j exit
my_end:
    lw a1,4(sp)
    lw a2,8(sp)
    lw s0,12(sp)
    lw s1,16(sp)
    lw s2,20(sp)
    lw s3,24(sp)
    lw s4,28(sp)
    lw s5,32(sp)
    lw s6,36(sp)
    lw s7,40(sp)
    lw s8,44(sp)
    lw ra,48(sp)
    addi sp,sp,52
    jr ra

    

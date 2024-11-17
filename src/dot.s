.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end # loop index comparison

    # TODO: Add your own implementation
	addi t1, t1, 1 # loop index counting
	# bgt t3, x0, multiply
	mv t4, t1 # loop index for stride multiply
	li t5, 0 # product result
	add t6, a3, x0

stride0_multiply:
	beqz t4, stride0_done
	add t5, t5, t6
	addi t4, t4, -1
	j stride0_multiply

stride0_done:
	slli t5, t5, 2 # product * 4
	add a0, a0, t5

	# initialized for calculating stride1
	li t5, 0
	add t4, t4, t1

stride1_multiply:
	beqz t4, stride1_done
	add t5, t5, t6
	addi t4, t4, -1
	j stride1_multiply

stride1_done:
	slli t5, t5, 2
	add a1, a1, t5

	lw t2, 0(a0) # multiplier
	lw t3, 0(a1) # multiplicand
	beqz 


multiply:
	add t4, t4, t2
	addi t3, t3, -1
	bgt t3, x0, multiply
	add a0, a0, t4

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

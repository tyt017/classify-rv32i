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
stride_count:
	beqz t1, product_start # the first element do not need to count
	
	# counting for arr0
	add t5, x0, a3
	slli t5, t5, 2
	add a0, a0, t5

	#counting for arr1
	add t5, x0, a4
	slli t5, t5, 2
	add a1, a1, t5

# initialize t4 as the result of arr0[i] * arr1[i]
product_start:
	add t4, x0, x0
	lw t2, 0(a0) # multiplicand
	lw t3, 0(a1) # multiplier
	beqz t3, product_done

product_loop:
	add t4, t4, t2
	addi t3, t3, -1
	bnez t3, product_loop

product_done:
	add t0, t0, t4
	addi t1, t1, 1
	j loop_start

multiply:
	add t4, t4, t2
	addi t3, t3, -1
	bgt t3, x0, multiply
	add t0, t0, t4

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

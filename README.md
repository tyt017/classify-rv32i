# Assignment 2: Classify

TODO: Add your own descriptions here.
## Part A:

### Task 1: ReLU
First, check the value is positive or negative. If it is positive, then store the original value. Otherwise, store zero back to the array.

#### modified part:
``` rv32i= 
loop_start:
    ble a1, x0, finish
    lw t2, 0(a0)
    blt t2, x0, less_than_zero
    sw t2, 0(a0)
    addi a1, a1, -1
    addi a0, a0, 4
    bge a1, x0, loop_start

less_than_zero:
    sw x0, 0(a0)
    addi a1, a1, -1
    addi a0, a0, 4
    j loop_start
```

### Task 2: ArgMax
`t3` stores the current max value, and `t1` stores the position of the current max value. When there is a value larger than the current value, it will go to `change_max` tag to change the max value and the position index.

#### modified part:
``` rv32i=
loop_start:
    addi t3, x0, -999
    add t4, x0, x0
find_max:
    ble a1, x0, finish
    lw t0, 0(a0)
    addi t4, t4, 1
    bgt t0, t3, change_max
    addi a1, a1, -1
    addi a0, a0, 4
    bge a1, x0, find_max

change_max: # change the max value and the max position
    add t3, x0, t0
    addi t1, t4, -1
    addi a1, a1, -1
    addi a0, a0, 4
    bge a1, x0, find_max
```

### Task 3: Dot Product
I stucked at this task for a while. I originally used the **accumulated** way to calculate multiplication, but when I tested `test_chain`, it would take too much time to execute. As a result, I change to use the **shift_and_add** way to implement multiplication.
#### modified part:
``` rv32i=
loop_start:
    bge t1, a2, loop_end # loop index comparison

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

product_start:
	add t4, x0, x0
	lw t2, 0(a0) # multiplicand
	lw t3, 0(a1) # multiplier

product_loop:
	beqz t3, product_done
    andi t5, t3, 1
    beq t5, x0, skip_add
    add t4, t4, t2

skip_add:
    slli t2, t2, 1
    srli t3, t3, 1
    j product_loop

product_done:
    add t0, t0, t4
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t0
    jr ra
```

### Task 3-2: Matrix Multiplication
To complete this task, it is important to clearly understand the behavior of inner loop and outer loop.
Everytime when the inner_loop ended, `s0` needed to be added by 1 to calculate the next row. `s3` needed to add the number of the column in Matrix A to find the position of the first element in the next row.
When the outer_loop finishing, we need to recover the registers that temporarily stored in the stack.

#### modified part:
``` rv32i=
inner_loop_end:
    addi s0, s0, 1
    add t0, x0, a2
    slli t0, t0, 2
    add s3, s3, t0

    j outer_loop_start


outer_loop_end:

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    jr ra
```

## Part B:

In this part, we only have to modify the `mul` function in the three tasks.

### Task 1: Read Matrix
``` rv32i=
# mul s1, t1, t2   # s1 is number of elements
# FIXME: Replace 'mul' with your own implementation

# my implementation
    li s1, 0
mul_start:
    addi t2, t2, -1
    add s1, s1, t1
    bnez t2, mul_start
```

### Task 2: Write Matrix
``` rv32i=
# mul s4, s2, s3   # s4 = total elements
# FIXME: Replace 'mul' with your own implementation

# my implementation
    li s4, 0
mul_start:
    addi s3, s3, -1
    add s4, s4, s2
    bnez s3, mul_start
```

### Task 3: Classification
#### First part
``` rv32i=
# mul a0, t0, t1
# FIXME: Replace 'mul' with your own implementation

# my implementation
    li a0, 0
mul_start:
    addi t1, t1, -1
    add a0, a0, t0
    bnez t1, mul_start
```
#### Second part
``` rv32i=
# mul a1, t0, t1 # length of h array and set it as second argument
# FIXME: Replace 'mul' with your own implementation

# my implementation
    li a1, 0
mul_start1:
    addi t1, t1, -1
    add a1, a1, t0
    bnez t1, mul_start1
```
#### Third part
``` rv32i=
# mul a0, t0, t1
# FIXME: Replace 'mul' with your own implementation

# my implementation
    li a0, 0
mul_start2:
    addi t1, t1, -1
    add a0, a0, t0
    bnez t1, mul_start2
```
#### Forth part
``` rv32i=
mul a1, t0, t1 # load length of array into second arg
    # FIXME: Replace 'mul' with your own implementation
    li a1, 0
mul_start3:
    addi t1, t1, -1
    add a1, a1, t0
    bnez t1, mul_start3
```

## The testing result
```
test_abs_minus_one (__main__.TestAbs) ... ok
test_abs_one (__main__.TestAbs) ... ok
test_abs_zero (__main__.TestAbs) ... ok
test_argmax_invalid_n (__main__.TestArgmax) ... ok
test_argmax_length_1 (__main__.TestArgmax) ... ok
test_argmax_standard (__main__.TestArgmax) ... ok
test_chain_1 (__main__.TestChain) ... ok
test_classify_1_silent (__main__.TestClassify) ... ok
test_classify_2_print (__main__.TestClassify) ... ok
test_classify_3_print (__main__.TestClassify) ... ok
test_classify_fail_malloc (__main__.TestClassify) ... ok
test_classify_not_enough_args (__main__.TestClassify) ... ok
test_dot_length_1 (__main__.TestDot) ... ok
test_dot_length_error (__main__.TestDot) ... ok
test_dot_length_error2 (__main__.TestDot) ... ok
test_dot_standard (__main__.TestDot) ... ok
test_dot_stride (__main__.TestDot) ... ok
test_dot_stride_error1 (__main__.TestDot) ... ok
test_dot_stride_error2 (__main__.TestDot) ... ok
test_matmul_incorrect_check (__main__.TestMatmul) ... ok
test_matmul_length_1 (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul) ... ok
test_matmul_square (__main__.TestMatmul) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul) ... ok
test_read_1 (__main__.TestReadMatrix) ... ok
test_read_2 (__main__.TestReadMatrix) ... ok
test_read_3 (__main__.TestReadMatrix) ... ok
test_read_fail_fclose (__main__.TestReadMatrix) ... ok
test_read_fail_fopen (__main__.TestReadMatrix) ... ok
test_read_fail_fread (__main__.TestReadMatrix) ... ok
test_read_fail_malloc (__main__.TestReadMatrix) ... ok
test_relu_invalid_n (__main__.TestRelu) ... ok
test_relu_length_1 (__main__.TestRelu) ... ok
test_relu_standard (__main__.TestRelu) ... ok
test_write_1 (__main__.TestWriteMatrix) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix) ... ok

----------------------------------------------------------------------
Ran 46 tests in 48.305s

OK
```

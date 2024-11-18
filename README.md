# Assignment 2: Classify

TODO: Add your own descriptions here.
## Part A: Mathematical Functions

### Task 1: ReLU
#### Description
Applies ReLU (Rectified Linear Unit) operation in-place: `For each element x in array: x = max(0, x)`
#### Implementation
First, check the value is positive or negative. If it is positive, then store the original value. Otherwise, store zero back to the array.

#### modified part:
``` assembly= 
loop_start:
    ble a1, x0, finish
    lw t2, 0(a0)
    blt t2, x0, less_than_zero
    sw t2, 0(a0) # store the original value into the array
    addi a1, a1, -1
    addi a0, a0, 4 # update the position
    bge a1, x0, loop_start

less_than_zero: # store zero back to the array
    sw x0, 0(a0)
    addi a1, a1, -1
    addi a0, a0, 4
    j loop_start
    
finish:
    jr ra
```

### Task 2: ArgMax
#### Description
Scans an integer array to find its maximum value and returns the position of its first occurrence. In cases where multiple elements share the maximum value, returns the smallest index.
#### Implementation
`t3` stores the current max value, and `t1` stores the position of the current max value. When there is a value larger than the current value, it will go to `change_max` tag to change the max value and the position index. Finally, return the position of the max value.

#### modified part:
``` assembly=
loop_start:
    addi t3, x0, -999 # initialized to store the max value
    add t4, x0, x0 # loop counter
find_max:
    ble a1, x0, finish
    lw t0, 0(a0)
    addi t4, t4, 1
    bgt t0, t3, change_max
    addi a1, a1, -1
    addi a0, a0, 4 # update the position of the array
    bge a1, x0, find_max

change_max: # change the max value and the position
    add t3, x0, t0
    addi t1, t4, -1
    addi a1, a1, -1
    addi a0, a0, 4
    bge a1, x0, find_max
    
finish:
    add a0, x0, t1
    jr ra
```

### Task 3: Dot Product
#### Description
Calculates `sum(arr0[i * stride0] * arr1[i * stride1])` where i ranges from 0 to (element_count - 1)
I stucked at this task for a while. I originally used the **accumulated** way to calculate multiplication, but when I tested `test_chain`, it would take too much time to execute. As a result, I change to use the **shift_and_add** way to implement multiplication.
#### Implementation
1. `stride_count`: Computes the strides length of two arrays.
2. `product_start`: Load the values from two arrays and initialize the result register `t4`.
3. `product_loop`: Check the LSB of the mutiplier. If it is zero, go to `skip_add` and left shift the multiplicand `t2`, right shift the multiplier `t3`. Otherwise, add multiplicand to the result register.
4. `product_done`: the multiplication is completed, and add the result into the dot result register `t0`. Go back to `loop_start` to check if there are some elements not been compute. 

#### modified part:
``` assembly=
loop_start:
    bge t1, a2, loop_end # loop index comparison

stride_count: # compute the stride of two arrays
    beqz t1, product_start # the first element do not need to compute
	
    # computing for arr0
    add t5, x0, a3
    slli t5, t5, 2
    add a0, a0, t5

    #computing for arr1
    add t5, x0, a4
    slli t5, t5, 2
    add a1, a1, t5

product_start:
    add t4, x0, x0 # initialized to store the product
    lw t2, 0(a0) # multiplicand
    lw t3, 0(a1) # multiplier

product_loop:
    beqz t3, product_done
    andi t5, t3, 1 # get the LSB of the multiplier
    beq t5, x0, skip_add
    add t4, t4, t2

skip_add: # the LSB of the multiplier is zero
    slli t2, t2, 1
    srli t3, t3, 1
    j product_loop

product_done:
    add t0, t0, t4 # add the product into the dot result
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t0
    jr ra
```

### Task 3-2: Matrix Multiplication
#### Description
Performs operation: D = Matrix A × Matrix B
Where:
- Matrix A is a (rows0 × cols0) matrix
- Matrix B is a (rows1 × cols1) matrix
- D is a (rows0 × cols1) result matrix

#### Arguments
- First Matrix (A):
    - a0: Memory address of first element
    - a1: Row count
    - a2: Column count
- Second Matrix (B):
    - a3: Memory address of first element
    - a4: Row count
    - a5: Column count
- Output Matrix (D):
    - a6: Memory address for result storage

#### Implementation
To complete this task, it is important to clearly understand the behavior of inner loop and outer loop.
1. Everytime when the `inner_loop` ended, `s0` was added by 1 to go to the next row. `s3` was added by the number of elements in a row of Matrix A to find the position of the first element in the next row.
2. When the `outer_loop` finishing, we need to recover the registers that temporarily stored in the stack.

#### modified part:
``` assembly=
inner_loop_end: # update the pointer of Matrix A to the next row
    addi s0, s0, 1 # update the outer_loop counter
    add t0, x0, a2 # the number of elements in each row
    slli t0, t0, 2 # multiplied by 4
    add s3, s3, t0

    j outer_loop_start


outer_loop_end: # recover the registers and return control to the caller

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

## Part B: File Operations and Main

In this part, we only have to modify the `mul` function in the three tasks.
I use the **accumulate** way to implement the multiplication.

### Task 1: Read Matrix
``` assembly=
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
``` assembly=
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
``` assembly=
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
``` assembly=
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
``` assembly=
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
``` assembly=
mul a1, t0, t1 # load length of array into second arg
    # FIXME: Replace 'mul' with your own implementation
    
# my implementation
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

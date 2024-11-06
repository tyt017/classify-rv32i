.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    blt a1, x0, finish
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

error:
    li a0, 36          
    j exit          

finish:
    jr ra
.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1
loop_start:
    # TODO: Add your own implementation
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

change_max:
    add t3, x0, t0
    addi t1, t4, -1
    addi a1, a1, -1
    addi a0, a0, 4
    bge a1, x0, find_max

handle_error:
    li a0, 36
    j exit

finish:
    add a0, x0, t1
    jr ra
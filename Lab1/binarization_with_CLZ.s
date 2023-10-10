# input the image from "test"
# output the binariztion result to "result"
# "threshold" can be change from 0 to 255
# each value of "test" can be change from 0 to 255
# if the number of "test" being change, 
# the number of "result" and the "s1" parameter in "main" should be change as well

.data
test: .byte 20, 80, 128, 150, 231
result: .byte 0, 0, 0, 0, 0
threshold: .byte 0x80
mask1: .word 0x55555555
mask2: .word 0x33333333
mask4: .word 0x0f0f0f0f
str1: .string " "
str2: .string "\nThe Binarization Result:\n"

.text
main:
    # a1 = address of pixel
    # a2 = address of result
    # a3 = threshold
    la a1, test            # load address of pixel
    la a2, result          # load address of result
    la a3, threshold       # load address of threshold
    lbu a3, 0(a3)          # load value of threshold

BINARIZATION:
    li s1, 5            # count of haven't done pixel
B_LOOP:
    lbu a4, 0(a1)       # load value of pixel
    sub a0, a3, a4      # threshold - pixel
    jal ra, CLZ         # jump to CLZ
    bne a0, x0, FLOOR   # branch to FLOOR if CLZ = 0
CEIL:
    li a4, 255
    j STORE_MOVE        # jump to STORE_MOVE
FLOOR:
    li a4, 0
    
STORE_MOVE:
    sb a4, 0(a2)
    addi s1, s1, -1    # total count -1
    addi a1, a1, 1     # go to next address of pixel
    addi a2, a2, 1     # go to next address of result
    bne s1, x0, B_LOOP
    
    li s1, 5           # make count for RESULT_CHECK
    sub a2, a2, s1     # reset address of result
    
    la a0, str2        # start to print the result
    li a7, 4
    ecall
RESULT_CHECK:
    lbu a0, 0(a2)                # load result to a0
    jal ra, PRINT_INT
    addi s1, s1, -1              # count print result
    addi a2, a2, 1               # move to next address of result
    bne s1, x0, RESULT_CHECK
    j EXIT
    
CLZ:
    # a0: x = the number to be counted leading zero
    # t0: shifted x
    # t1: x shift & mask
    # t2: mask
PAD1:
    srli t0, a0, 1    # t0 = x >> 1
    or a0, a0, t0     # x |= x >> 1
    srli t0, a0, 2    # t0 = x >> 2
    or a0, a0, t0     # x |= x >> 2
    srli t0, a0, 4    # t0 = x >> 4
    or a0, a0, t0     # x |= x >> 4
    srli t0, a0, 8    # t0 = x >> 8
    or a0, a0, t0     # x |= x >> 8
    srli t0, a0, 16   # t0 = x >> 16
    or a0, a0, t0     # x |= x >> 16
    
POPCNT:
    lw t2, mask1      # load mask1 to t2
    srli t0, a0, 1    # t0 = x >> 1
    and t1, t0, t2    # t1 = (x >> 1) & mask1
    sub a0, a0, t1    # x -= ((x >> 1) & mask1)
    lw t2, mask2      # load mask2 to t2
    srli t0, a0, 2    # t0 = x >> 2
    and t1, t0, t2    # (x >> 2) & mask2
    and a0, a0, t2    # x & mask2
    add a0, t1, a0    # ((x >> 2) & mask2) + (x & mask2)
    srli t0, a0, 4    # t0 = x >> 4
    add a0, a0, t0    # x + (x >> 4)
    lw t2, mask4      # load mask4 to t2
    and a0, a0, t2    # ((x >> 4) + x) & mask4
    srli t0, a0, 8    # t0 = x >> 8
    add a0, a0, t0    # x += (x >> 8)
    srli t0, a0, 16   # t0 = x >> 16
    add a0, a0, t0    # x += (x >> 16)
    andi t0, a0, 0x3f # t0 = x & 0x3f
    li a0, 32         # a0 = 64
    sub a0, a0, t0    # 64 - (x & 0x3f)
    
    addi sp, sp, -4   # make space for ra in stack
    sw ra, 0(sp)      # push ra into stack
    jal ra, PRINT_INT
    lw ra, 0(sp)      # pull ra out of stack
    addi sp, sp, 4    # free the space create in stack for ra
    
    ret
PRINT_INT:
    li a7, 1          # print the value of input a0 in int
    ecall
    addi sp, sp, -4
    sw a0, 0(sp)
    la a0, str1
    li a7, 4
    ecall
    lw a0, 0(sp)
    addi sp, sp, 4
    ret
    
EXIT:
    li a7, 10        # Halts the simulator
    ecall
    
nop
nop
# set forecolor: black
ori $t0, $zero, 0xf000      # 3408F000
sll $t0, $t0, 16            # 00084400
ori $t0, $t0, 0x000c        # 3508000C
sw $zero, 0($t0)            # AD000000
# set background color: white
ori $t0, $zero, 0xf000      # 3408F000
sll $t0, $t0, 16            # 00084400
ori $t0, $t0, 0x0010        # 35080010
ori $t1, $zero, 0xfff       # 34090FFF
sw $t1, 0($t0)              # AD090000
# set vga mode: text
ori $t0, $zero, 0xf000      # 3408F000
sll $t0, $t0, 16            # 00084400
ori $t0, $t0, 0x0008        # 35080008
sw $zero, 0($t0)            # AD000000
# clear the screen
ori $t0, $zero, 0x1000      # 34081000
sll $t0, $t0, 16            # 00084400
ori $t1, $zero, 0x1000      # 34091012
sll $t1, $t1, 16            # 00094C00
ori $t1, $t1, 0x2580        # 3529C000
addi $t2, $zero, 0x200
clear:
lw $t3, 0($t2)
addi $t4, $zero, 0xff
and $t5, $t3, $t4
sll $t4, $t4, 8
and $t6, $t3, $t4
srl $t6, $t6, 8
sll $t4, $t4, 8
and $t7, $t3, $t4
srl $t7, $t7, 16
sll $t4, $t4, 8
and $t8, $t3, $t4
srl $t8, $t8, 24
sw $t5, 12($t0)              # AD000000
sw $t6, 8($t0)
sw $t7, 4($t0)
sw $t8, 0($t0)
addi $t2, $t2, 4
addi $t0, $t0, 16           # 21080010
bne $t0, $t1, clear         # 1509FFF9
# keyboard input?
ori $s0, $zero, 0xf000      # 3410F000
sll $s0, $s0, 16            # 00108400
ori $s0, $s0, 0x0004        # 36100004
sw $zero, 0($s0)            # AE000000
add $gp, $zero, $zero       # 0000E020
ori $sp, $zero, 0x1000      # 341D1000
sll $sp, $sp, 16            # 001DEC00
ori $t0, $zero, 0xf000      # 3408F000
sll $t0, $t0, 16            # 00084400
ori $t0, $t0, 0x0018        # 35080018
ori $t1, $zero, 0xf000      # 3409F000
sll $t1, $t1, 16            # 00094C00
ori $t1, $t1, 0x0014        # 35290014
keyboard:
lw $t2, 0($t0)              # 8D0A0000
beq $t2, $zero, keyboard    # 1140FFFC
# push new input into buffer
lw $t2, 0($t1)              # 8D2A0000
sll $gp, $gp, 8             # 001CE200
or $gp, $t2, $gp            # 015CE025
# check E0
ori $t2, $zero, 0xFF        # 340A00FF
sll $t2, $t2, 16            # 000A5400
ori $t3, $zero, 0xE0        # 340B00E0
sll $t3, $t3, 16            # 000B5C00
and $t4, $gp, $t2           # 038A6024
beq $t4, $t3, keyboard      # 118BFFE1
# check E0, E1, F0
srl $t2, $t2, 8             # 000A5202
and $t4, $gp, $t2           # 038A6024
ori $t3, $zero, 0xE000      # 340BE000
beq $t4, $t3, keyboard      # 118BFFD5
ori $t3, $zero, 0xE100      # 340BE100
beq $t4, $t3, keyboard      # 118BFFCF
ori $t3, $zero, 0xF000      # 340BF000
beq $t4, $t3, keyboard      # 118BFFC9
# load ascii
andi $t2, $gp, 0xff         # 338A00FF
sll $t2, $t2, 2             # 000A5080
ori $t3, $zero, 0x2000      # 340B2000
sll $t3, $t3, 16            # 000B5C00
or $t2, $t2, $t3            # 014B5025
lw $t3, 0($t2)              # 8D4B0000
beq $t3, $zero, keyboard    # 1160FFB4
sw $t3, 0($sp)              # AFAB0000
addi $sp, $sp, 4            # 23BD0004
lw $t3, 0($s0)              # 8E0B0000
addi $t3, $t3, 1            # 216B0001
sw $t3, 0($s0)              # AE0B0000
j keyboard                  # 08000068

.data 0x200
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.ascii "This is a test for the lw instruction. Is it working correctly? I don't know.\0\0\0"
.ascii "\0This is a test for the lw instruction. Is it working correctly? I don't know.\0\0"
.ascii "\0\0This is a test for the lw instruction. Is it working correctly? I don't know.\0"
.ascii "\0\0\0This is a test for the lw instruction. Is it working correctly? I don't know."
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101
.word 0x01010101, 0x01010101, 0x01010101, 0x01010101

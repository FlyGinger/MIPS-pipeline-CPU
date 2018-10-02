# set forecolor: black
nop
nop
ori $t0, $zero, 0xf000      # 3408F000
nop
nop
sll $t0, $t0, 16            # 00084400
nop
nop
ori $t0, $t0, 0x000c        # 3508000C
nop
nop
sw $zero, 0($t0)            # AD000000
nop
nop
# set background color: white
ori $t0, $zero, 0xf000      # 3408F000
nop
nop
sll $t0, $t0, 16            # 00084400
nop
nop
ori $t0, $t0, 0x0010        # 35080010
nop
nop
ori $t1, $zero, 0xfff       # 34090FFF
nop
nop
sw $t1, 0($t0)              # AD090000
nop
nop
# set vga mode: text
ori $t0, $zero, 0xf000      # 3408F000
nop
nop
sll $t0, $t0, 16            # 00084400
nop
nop
ori $t0, $t0, 0x0008        # 35080008
nop
nop
sw $zero, 0($t0)            # AD000000
nop
nop
# clear the screen
ori $t0, $zero, 0x1000      # 34081000
nop
nop
sll $t0, $t0, 16            # 00084400
nop
nop
ori $t1, $zero, 0x1012      # 34091012
nop
nop
sll $t1, $t1, 16            # 00094C00
nop
nop
ori $t1, $t1, 0xC000        # 3529C000
nop
nop
clear:
sw $zero, 0($t0)            # AD000000
nop
nop
addi $t0, $t0, 4            # 21080004
nop
nop
bne $t0, $t1, clear         # 1509FFF9
nop
nop
# keyboard input?
ori $s0, $zero, 0xf000      # 3410F000
nop
nop
sll $s0, $s0, 16            # 00108400
nop
nop
ori $s0, $s0, 0x0004        # 36100004
nop
nop
sw $zero, 0($s0)            # AE000000
nop
nop
add $gp, $zero, $zero       # 0000E020
nop
nop
ori $sp, $zero, 0x1000      # 341D1000
nop
nop
sll $sp, $sp, 16            # 001DEC00
nop
nop
ori $t0, $zero, 0xf000      # 3408F000
nop
nop
sll $t0, $t0, 16            # 00084400
nop
nop
ori $t0, $t0, 0x0018        # 35080018
nop
nop
ori $t1, $zero, 0xf000      # 3409F000
nop
nop
sll $t1, $t1, 16            # 00094C00
nop
nop
ori $t1, $t1, 0x0014        # 35290014
nop
nop
keyboard:
lw $t2, 0($t0)              # 8D0A0000
nop
nop
beq $t2, $zero, keyboard    # 1140FFFC
nop
nop
# push new input into buffer
lw $t2, 0($t1)              # 8D2A0000
nop
nop
sll $gp, $gp, 8             # 001CE200
nop
nop
or $gp, $t2, $gp            # 015CE025
nop
nop
# check E0
ori $t2, $zero, 0xFF        # 340A00FF
nop
nop
sll $t2, $t2, 16            # 000A5400
nop
nop
ori $t3, $zero, 0xE0        # 340B00E0
nop
nop
sll $t3, $t3, 16            # 000B5C00
nop
nop
and $t4, $gp, $t2           # 038A6024
nop
nop
beq $t4, $t3, keyboard      # 118BFFE1
nop
nop
# check E0, E1, F0
srl $t2, $t2, 8             # 000A5202
nop
nop
and $t4, $gp, $t2           # 038A6024
nop
nop
ori $t3, $zero, 0xE000      # 340BE000
nop
nop
beq $t4, $t3, keyboard      # 118BFFD5
nop
nop
ori $t3, $zero, 0xE100      # 340BE100
nop
nop
beq $t4, $t3, keyboard      # 118BFFCF
nop
nop
ori $t3, $zero, 0xF000      # 340BF000
nop
nop
beq $t4, $t3, keyboard      # 118BFFC9
nop
nop
# load ascii
andi $t2, $gp, 0xff         # 338A00FF
nop
nop
sll $t2, $t2, 2             # 000A5080
nop
nop
ori $t3, $zero, 0x2000      # 340B2000
nop
nop
sll $t3, $t3, 16            # 000B5C00
nop
nop
or $t2, $t2, $t3            # 014B5025
nop
nop
lw $t3, 0($t2)              # 8D4B0000
nop
nop
beq $t3, $zero, keyboard    # 1160FFB4
nop
nop
sw $t3, 0($sp)              # AFAB0000
nop
nop
addi $sp, $sp, 4            # 23BD0004
nop
nop
lw $t3, 0($s0)              # 8E0B0000
nop
nop
addi $t3, $t3, 1            # 216B0001
nop
nop
sw $t3, 0($s0)              # AE0B0000
nop
nop
j keyboard                  # 08000068
nop
nop

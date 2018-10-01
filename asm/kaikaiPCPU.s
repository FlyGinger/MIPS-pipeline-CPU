# set forecolor: black
nop
nop
ori $t0, $t0, 0xf000
nop
nop
sll $t0, $t0, 16
nop
nop
ori $t0, $t0, 0x000c
nop
nop
sw $zero, 0($t0)
nop
nop
# set background color: white
ori $t0, $t0, 0xf000
nop
nop
sll $t0, $t0, 16
nop
nop
ori $t0, $t0, 0x0010
nop
nop
ori $t1, $zero, 0xFFF
nop
nop
sw $t1, 0($t0)
nop
nop
# set vga mode: text
ori $t0, $t0, 0xf000
nop
nop
sll $t0, $t0, 16
nop
nop
ori $t0, $t0, 0x0008
nop
nop
sw $zero, 0($t0)
nop
nop
# clear the screen
ori $t0, $zero, 0x1000
nop
nop
sll $t0, $t0, 16
nop
nop
ori $t1, $zero, 0x1012
nop
nop
sll $t1, $t1, 16
nop
nop
ori $t1, $t1, 0xC000
nop
nop
clear:
sw $zero, 0($t0)
nop
nop
addi $t0, $t0, 4
nop
nop
bne $t0, $t1, clear
nop
nop
# keyboard input?
ori $s0, $zero, 0xf000
nop
nop
sll $s0, $s0, 16
nop
nop
ori $s0, $s0, 0x0004
nop
nop
sw $zero, 0($s0)
nop
nop
add $gp, $zero, $zero
nop
nop
ori $sp, $zero, 0x1000
nop
nop
sll $sp, $sp, 16
nop
nop
ori $t0, $zero, 0xf000
nop
nop
sll $t0, $t0, 16
nop
nop
ori $t0, $t0, 0x0018
nop
nop
ori $t1, $zero, 0xf000
nop
nop
sll $t1, $t1, 16
nop
nop
ori $t1, $t1, 0x0014
nop
nop
keyboard:
lw $t2, 0($t0)
nop
nop
beq $t2, $zero, keyboard
nop
nop
# push new input into buffer
lw $t2, 0($t1)
nop
nop
sll $gp, $gp, 8
nop
nop
or $gp, $t2, $gp
nop
nop
# check E0
ori $t2, $zero, 0xFF
nop
nop
sll $t2, $t2, 16
nop
nop
ori $t3, $zero, 0xE0
nop
nop
sll $t3, $t3, 16
nop
nop
and $t4, $gp, $t2
nop
nop
beq $t4, $t3, keyboard
nop
nop
# check E0, E1, F0
srl $t2, $t2, 8
nop
nop
and $t4, $gp, $t2
nop
nop
ori $t3, $zero, 0xE000
nop
nop
beq $t4, $t3, keyboard
nop
nop
ori $t3, $zero, 0xE100
nop
nop
beq $t4, $t3, keyboard
nop
nop
ori $t3, $zero, 0xF000
nop
nop
beq $t4, $t3, keyboard
nop
nop
# load ascii
andi $t2, $gp, 0xff
nop
nop
sll $t2, $t2, 2
nop
nop
ori $t3, $zero, 0x2000
nop
nop
sll $t3, $t3, 16
nop
nop
or $t2, $t2, $t3
nop
nop
lw $t3, 0($t2)
nop
nop
beq $t3, $zero, keyboard
nop
nop
sw $t3, 0($sp)
nop
nop
addi $sp, $sp, 4
nop
nop
lw $t3, 0($s0)
nop
nop
addi $t3, $t3, 1
nop
nop
sw $t3, 0($s0)
nop
nop
j keyboard
nop
nop

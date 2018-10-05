    nop
    nop

    # set forecolor: black
    li $t0, 0xf000000c
    sw $zero, 0($t0)

    # set background color: white
    li $t0, 0xf0000010
    ori $t1, $zero, 0xfff
    sw $t1, 0($t0)

    # set vga mode: text
    li $t0, 0xf0000008
    sw $zero, 0($t0)

    # load data from cache
    add $t0, $zero, $zero
    addi $t1, $zero, 0x5a0
    lui $sp, 0x1000
load:
    lw $t2, 0($t0)
    # the fourth letter
    andi $t3, $t2, 0xff
    sw $t3, 12($sp)
    # the third letter
    srl $t2, $t2, 8
    andi $t3, $t2, 0xff
    sw $t3, 8($sp)
    # the second letter
    srl $t2, $t2, 8
    andi $t3, $t2, 0xff
    sw $t3, 4($sp)
    # the first letter
    srl $t2, $t2, 8
    sw $t2, 0($sp)
    # next
    addi $sp, $sp, 16
    addi $t0, $t0, 4
    bne $t0, $t1, load

    # store
    li $t1, 0x4E6F7720
    sw $t1, 0($t0)
    li $t1, 0x796F7520
    sw $t1, 4($t0)
    li $t1, 0x63616E20
    sw $t1, 8($t0)
    li $t1, 0x696E7075
    sw $t1, 12($t0)
    li $t1, 0x7420736F
    sw $t1, 16($t0)
    li $t1, 0x6D657468
    sw $t1, 20($t0)
    li $t1, 0x696E6720
    sw $t1, 24($t0)
    li $t1, 0x66726F6D
    sw $t1, 28($t0)
    li $t1, 0x206B6579
    sw $t1, 32($t0)
    li $t1, 0x626F6172
    sw $t1, 36($t0)
    li $t1, 0x643A2020
    sw $t1, 40($t0)

    # re-load
    addi $t1, $zero, 0x5f0
reload:
    lw $t2, 0($t0)
    # the fourth letter
    andi $t3, $t2, 0xff
    sw $t3, 12($sp)
    # the third letter
    srl $t2, $t2, 8
    andi $t3, $t2, 0xff
    sw $t3, 8($sp)
    # the second letter
    srl $t2, $t2, 8
    andi $t3, $t2, 0xff
    sw $t3, 4($sp)
    # the first letter
    srl $t2, $t2, 8
    sw $t2, 0($sp)
    # next
    addi $sp, $sp, 16
    addi $t0, $t0, 4
    bne $t0, $t1, reload

    # keyboard input?
    li $sp, 0x100017c0
    li $s0, 0xf0000004
    sw $zero, 0($s0)            # AE000000
    add $gp, $zero, $zero       # 0000E020
    li $t0, 0xf0000018
    li $t1, 0xf0000014
    li $s1, 0x10002580
keyboard:
    slt $s2, $sp, $s1
    bne $s2, $zero, continue
    li $sp, 0x100017c0
continue:
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

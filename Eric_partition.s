########################
#      partition       #
########################
partition:
  # a0: base address
  # a1: left  = first index to be partitioned
  # a2: right = last index to be partitioned
  # a3: pivot value
  # Return:
  # v0: The final index for the pivot element
  # Separate the list into two sections based on the pivot value

addi $sp, $sp, -40
sw $ra, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $s3, 20($sp)
sw $fp, 24($sp)
addi $fp, $fp, -40


partitionRecursionExitCase:
  beq $a1, $a2, partitionEnd #checks if $a1 == $a2
  slt $t0, $a2, $a1		# checks if $a1 > $a2
  beq $t0, $zero, partitionBody	# jump to next if statement

partitionEnd:
  add $v0, $zero, $a1 #return left
  lw $ra, 4($sp)
  lw $s0, 8($sp)
  lw $s1, 12($sp)
  lw $s2, 16($sp)
  lw $s3, 20($sp)
  lw $fp, 24($sp)
  addi $sp, $sp, 40
  jr $ra
partitionBody:
  sll $t0, $a1, 2 #multiplication to load value at x[left]
  add $t0, $t0, $a0
  lw $s0, 0 ($t0) #loading value at [xleft]
  slt $t1, $a3, $s0 #check to see if pivot value is less than xleft
  beq $t1, $zero partitionCase1
  j partitionCase2

  partitionCase1:
  sw $a0, 28($sp)
  sw $a1, 32($sp)
  sw $a2, 36($sp)
  sw $a3, 40($sp)
  addi $a2, $a2, -1
  jal partition
  j partitionEnd

  partitionCase2:
  sw $a0, 28($sp)
  sw $a1, 32($sp)
  sw $a2, 36($sp)
  sw $a3, 40($sp)
  addi $a1, $a1, 1
  jal partition
  j partitionEnd

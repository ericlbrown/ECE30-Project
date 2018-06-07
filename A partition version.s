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

  addi $sp, $sp, -40	 #preserve $ra so we can return to caller
  sw $ra, 4($sp)
  sw $s0, 8($sp)
  sw $s1, 12($sp)
  sw $s2, 16($sp)
  sw $s3, 20($sp)
  sw $fp, 24($sp)
  addi $fp, $fp, -40


  # if $a1 >= $a2 , return $a1 (list w/ < 2 elements dont need to be partitoned)
partitionRecursionExitCase:
  beq $a1, $a2, partitionReturn #checks if $a1 == $a2
  slt $t0, $a2, $a1		# checks if $a1 > $a2
  beq $t0, $zero, partitionCase1	# jump to next if statement

partitionReturn:
  move $v0, $a1 			# return left
  jr $ra				# return to caller

  # if both left and right elements are less than the pivot, return right

partitionCase1:
  slt $t0, $a1, $a3		# $t0 = 1 if left < pivot
  slt $t1, $a2, $a3		# $t1 = 1 if right < pivot
  beq $t0, $zero, partitionCase2 	# left > pivot so exit Case1
  beq $t1, $zero, partitionCase2   # if $t1 == 0, exit Case1
  move $v0, $a2			#return right
  jr $ra				#return to caller


  #if x[left] > pivot, swap(x, left, right - 1), return partition(x, left, right-1, pivot)

partitionCase2:
  sll $t0, $a1, 2		# multiply first index by 4 to determine offset to access x[left]
  add $t0, $t0, $a0	# $t0 points to x[left]
  lw  $s0, 0($t0)		# $s0 contains the value of x[left]
  slt $t1, $a3, $s0	# check if x[left] > pivot
  beq $t1, $zero, partitionCase3	# if x[left] < pivot, jump to else statement

  addi $a2, $a2, -1 	# decrement right index before calling swap

  #organizational tasks before calling swap
  addi $sp, $sp, -8
  sw $a1, 4($sp)
  sw $a2, 8($sp)

  jal swap		# since x[left] > pivot, move x[left] to the right of the pivot

  lw $a1, 4($sp)	#restore $a1 and $a2 from stack
  lw $a2, 8($sp)
  addi $sp, $sp, 8 #restore the $sp

  jal partition	#recursion
  j partitionEnd #end

# else return partition(x, left + 1, right, pivot)

partitionCase3:
  addi $a1, $a1, 1	# increment left index
  jal partition		# recursively call partition

partitionEnd:		# returns to this instruction when recursion ends
  lw $ra, 4($sp)	#ensures return to caller (quickSort function)
  lw $s0, 8($sp)
  lw $s1, 12($sp)
  lw $s2, 16($sp)
  lw $s3, 20($sp)
  lw $fp, 24($sp)
  addi $sp, $sp, 40
  addi $fp, $fp, 40
  jr $ra

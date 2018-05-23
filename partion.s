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



	# organizational tasks

	# if $a1 >= $a2 , return $a1 (list w/ < 2 elements dont need to be partitoned)

	slt $t0, $a2, $a1		# checks if $a1 >= $a2
	bne $t0, $zero, pivotCheck	# jump to next if statement
	move $v0, $a1 			# return left
	jr $ra				# return to caller

	# if both left and right elements are less than the pivot, return right

	pivotCheck:
	slt $t0, $a1, $a3	# $t0 = 1 if left < pivot
	slt $t1, $a2, $a3	# $t1 = 1 if right < pivot
	bne $t0, $zero, pivotCheck 	# if $t0 == 0, end if statement

	#left < pivot so jump to next ‘if’ statement in partitionBody

	j partitionBody

	beq $t1, $zero, partitionBody # if $t1 == 0, end if statement
	move $v0, $a2		#return right
	jr $ra			#return to caller


	#if x[left] > pivot, swap(x, left, right - 1), return partition(x, left, right-1, pivot)

	partitionBody:
	sll $t0, $a1, 2		# multiply index by 4 to determine offset
	add $t0, $t0, $a0	# $t0 points to x[left]
	lw $s0, 0($t0)		# $s0 contains the value of x[left]
	slt $t1, $a3, $s0	# check if x[left] > pivot
	beq $t1, $zero, partitionReturn	# if x[left] < pivot, jump to else statement

	# (do we need to save the values of $a1 and $a2 before calling swap? I think or nah)
	# lw $a1, ($sp)
	# lw $a2, ($sp)
	addi $a2, $a2, -1 	#right - 1 because indexing starts at zero???
		jal swap
		addi $a2, $a2, -1
	jal partition
	jr $ra



	# else return partition(x, left + 1, right, pivot)

	partitionReturn:
		addi $a1, $a1, 1	# left + 1
	jal partition			# return to caller
	jr $ra

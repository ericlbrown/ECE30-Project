########################
#        swap          #
########################
swap:
	# a0: base address
	# a1: index 1
	# a2: index 2
	# Swap the elements at the given indices in the list

	### INSERT YOUR CODE HERE

#save t0 and t1 before call

#don't worry about return address
	addi $sp, $sp, -20 #make space on stack
	sw $s0, 20($sp) #storing values/organization
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $fp, 4($sp)
	addi $fp, $fp, -20

#body of swap function

#loading value from x[lo]
	sll $a1, $a1, 2 #multiply index by offset constant 4
	add $t0, $a1, $a0 #address of x[lo] is now stored in t0 : x[lo] = *x[0]+offset
	lw $s1, 0($t0) #our actual value from x[lo] is now stored in s1

#repeating above for x[hi]

	sll $a2, $a2, 2
	add $t1, $a2, $a0 #store the address of x[hi0] at t1 temporarily
	lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]


	addi $s0, $s2, 0 #temp variable for hi value
	addi $s2, $s1, 0  #storing low value in high value register
	addi $s1, $s0, 0  #storing hi value into low register
	sw $s1, 0($t0) #saving hi value into low address
	sw $s2, 0($t1) #saving low value into high address

#more organization
	lw $s0, 20($sp) #storing values/organization
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $fp, 4($sp)
	addi $sp, $sp, 20
# return to caller
	jr $ra

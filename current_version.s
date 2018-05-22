Test cases to consider:
The list only has 0 or 1 length
Duplicate numbers in the list
Negative numbers in the list
Order of the stack

######################
#                    #
# Project Submission #
#                    #
######################

# Partner1: (Eric Brown), (A13764939)
# Partner2: (Lawrence Singian), (A13225295)



.data
array:	.word 5, 8, 1, 9, 3, 4, 2, 6

init:	.asciiz "The initial array is: "
final:	.asciiz "The sorted array is: "
comma:	.asciiz ", "
newline:.asciiz "\n"

.text
.globl main

########################
#        main          #
########################

main:
	# Print the array
	la $a0,array
	la $a1,init
	li $a2,8
	jal printList

	# Quicksort
	la $a0,array
	li $a1,0
	li $a2,7
	jal quickSort

	# Print the sorted array
	la $a0,array
	la $a1,final
	li $a2,8
	jal printList


exit:	li $v0,10
	syscall


########################
#        swap          #
########################
swap:
	# a0: base address
	# a1: index 1
	# a2: index 2
	# Swap the elements at the given indices in the list

	#don't worry about return address
addi $sp, $sp, -12 #make space on stack
sw $s0, 12($sp) #storing values/organization
sw $s1, 8($sp)
sw $fp, 4($sp)

#body of swap function

#loading value from x[lo]
li $s1, 4 #used to multiply by index value for number of bits offset from array start
mult $a1, $s1 #multiply index by offset constant
mflo $t0 #result stored in t0
add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
lw $s2, 0($t1) #our actual value from x[lo] is

#repeating above for x[hi]

sll
add $t1, $t0, $a0
lw $s3, 0($t1) #load to s3 the value stored in memory x[hi]





addi $t0, $s1, 0	 #store value of $a2 to temp register $t0
addi $s1, $s0, 0	 #store value of $a1 to $s1
addi $s0, $t0, 0 	 #store value of $a2 to $s0

sw $s0, 0($a1)
sw $s1, 0($a2)

#more organization
lw $s0, 12($sp)		#
lw $s1, 8($sp)
lw $fp, 4($sp)
	# return to caller
	jr $ra






########################
#   medianOfThree      #
########################
medianOfThree:
	# a0: base address
	# a1: left index value
	# a2: right index value (note NOT the value stored in the rightmost index)
	# Find the median of the first, last and the middle values of the given list
	# Make this the first element of the list by swapping

	### INSERT YOUR CODE HERE

	#organizational tasks


	#body of median function
	lw $s0, 0($a0)		#store value of first array element x[lo] to $s0
	sll $t1, $a2, 2		#multiply last index value by 4 to determine offset needed to                       access last array element
	add $t1, $t1, $a0	# $t1 points to the address of the last array element
lw $s1, 0($t1)		#store the value of the last array element x[hi] to $s1

add $t0, $a1, $a2	#add the first and last array index and store in $t0
sra $t0, $t0, 1		#divide $t0 by 2 in order to find the middle index.
sll $t0, $t0, 2		#multiply middle index by 4 to determine offset to access middle array element
add $t0, $t0, $a0	# $t0 points to the address of the middle array element
lw $s2, 0($t0)		# store the value of the middle array element x[mid] to $s2

#if x[lo] > x[hi], swap
slt $t2, $s1, $s0
bne $t2, $zero, swaplohi #REMEMBER TO STORE THE SWAPPED VALUES TO THE CORRECT $s
#if x[mid] > x[hi], swap
slt $s
#if x[lo] > x[mid], swap
#swap x[lo] and x[mid]




#REMEMBER THE STACK
#make sure to save the values in $s in the stack to prevent loss

	# return to caller
	jr $ra


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
mov $v0, $a1 			# return left
jr $ra				# return to caller

# if both left and right elements are less than the pivot, return right

pivotCheck:
slt $t0, $a1, $a3	# $t0 = 1 if left < pivot
slt $t1, $a2, $a3	# $t1 = 1 if right < pivot
bne $t0, $zero, pivotCheck 	# if $t0 == 0, end if statement

#left < pivot so jump to next ‘if’ statement in partitionBody

j partitionBody

beq $t1, $zero, partitionBody # if $t1 == 0, end if statement
mov $v0, $a2		#return right
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


########################
#      quickSort       #
########################
quickSort:
	# a0: base address
	# a1: left  = first index to be sorted
	# a2: right = last index to be sorted
	# Sort the list using recursive quick sort using the above functions

	### INSERT YOUR CODE HERE

	#organizational tasks
	#median of three pivot
	jal medianOfThree
	mov $a3, $v0		# save the pivot from medianOfThree to $a3

#partition
	jal partition



	mov $a2, $v0

	#recursion conditions until finished

#left partition

	jal quickSort
	jr $ra

	#right partition
	jal quickSort
	jr $ra

	# return to caller
	jr $ra


########################
#      printList       #
########################
printList:
	# a0: base address
	# a1: message to be printed
	# a2: length of the array
	add $t0,$a0,$0
	add $t1,$a2,$0

	li $v0,4
	add $a0,$a1,$0
	syscall			#Print message


next:
	lw $a0,0($t0)
	li $v0,1
	syscall			#Print int

	addi $t1,$t1,-1
	bgt $t1,$0,pnext
	li $v0,4		# if end of list
	la $a0,newline		# Print newline
	syscall
	jr $ra
pnext:	addi $t0,$t0,4
	li $v0,4
	la $a0,comma
	syscall			# Print comma
	j next

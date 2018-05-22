########################
#   medianOfThree      #
########################
medianOfThree:
	# a0: base address
	# a1: left
	# a2: right
	# Find the median of the first, last and the middle values of the given list
	# Make this the first element of the list by swapping

	### INSERT YOUR CODE HERE

	#orgaizational calle business

addi $sp , $sp, num #tbd how far to increment the stack pointer
sw $ra, num($sp)
#sw $s0 - $s_whatever #tbd how many we need to store
sw $fp
addi $fp, $fp, num


#calculating midpoint value

addi $s0, $a1, $a2 #s0 = lo+hi
srl $s0, $s0, 2 #(lo+hi)/2

#now we will worry about getting values from our indexed addresses
#at least for the first conditional

#loading value from x[lo]

sll $a1, $a1, 2
add $t1, $a1, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
lw $s2, 0($t1) #our actual value from x[lo] is now stored in s2

#repeating above for x[hi]

sll $a2, $a2, 2 #this time we use the index for x[high]/ ie the right value
add $t1, $t0, $a0
lw $s3, 0($t1) #load to s3 the value stored in memory x[hi]


#repeat for x[mid]

mult $s0, $s1 #this time we use the index for x[mid] that we stored in $s0
mflo $t0
add $t1, $t0, $a0
lw $s4, 0($t1) #load to s4 the value stored in memory x[mid]

# so now we have :
#val x[lo] stored in s2
#val x[hi] stored in s3
#val x[mid] stored in s4

###############################################################################
# if(x[lo]>x[hi]) swap(x,lo,hi)
slt $t2, $s2, $s3 #evaluate x[lo] <x[hi]
addi $t2, $t2, -1 #so if x[lo]<x[hi] t2 = 0 else t2 = -1

#the reason I did this was because we have a pseduo instruction that will evaluate
#then jump and link to our swap function so it saves time for us

#orgaizational for caller before call

#TODO : FIGURE OUT STACK POINTER SIZE
sw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
sw $t1 offset($sp)
sw $t2 offset($sp)

sw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
sw $a1 , offset($sp)
sw $a2 , offset($sp)

sw $v0 , offset($sp) #do we even have any return from a higher nested instruction?

#inputs to the swap function are already set because they are the same as for
#Median of Three

#jump to swap(x,lo,hi)
bgezal $t2 swap #branch on greater than or equal to zero and link

#return from calle orgaizational; mostly useless but will we get docked without it

lw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
lw $t1 offset($sp)
lw $t2 offset($sp)

lw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
lw $a1 , offset($sp)
lw $a2 , offset($sp)


################################################################################
# if(x[mid]>x[hi]) swap(x,mid,hi)

#need to reload the value at x[hi] since things have now been swapped

mult $a2, $s1 #this time we use the index for x[high]/ ie the right value
mflo $t0
add $t1, $t0, $a0
lw $s3, 0($t1) #load to s3 the value stored in memory x[hi]

#mid is still the same value as before

slt $t2, $s4, $s3 #compare x[mid]<x[hi]
addi $t2, $t2, -1 #same trick as before

#caller responsibilities
sw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
sw $t1 offset($sp)
sw $t2 offset($sp)

sw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
sw $a1 , offset($sp)
sw $a2 , offset($sp)

sw $v0 , offset($sp) #do we even have any return from a higher nested instruction?

#this time we do need to change some things around when passing to swap
#$a0 is still the first address of the array
addi $a1 $s4 0 #passing midpoint index to a1
#a2 is still holding our hi index values

bgezal $t2, swap #same jump trick as previously described

#return from calle orgaizational; mostly useless but will we get docked without it

lw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
lw $t1 offset($sp)
lw $t2 offset($sp)

lw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
lw $a1 , offset($sp)
lw $a2 , offset($sp)
###############################################################################
#if(x[lo]>x[mid]) swap(x,lo,mid)

#reloading values from x[lo] and x[mid] into s2 and s4 respectively
li $s1, 4 #used to multiply by index value for number of bits offset from array start
mult $a1, $s1 #multiply index by offset constant
mflo $t0 #result stored in t0
add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
lw $s2, 0($t1) #our actual value from x[lo] is now stored in s2

mult $s0, $s1 #this time we use the index for x[mid] that we stored in $s0
mflo $t0
add $t1, $t0, $a0
lw $s4, 0($t1) #load to s4 the value stored in memory x[mid]


slt $t2, $s2, $s4 #comparing x[lo]<x[mid]
addi $t2, $t2, -1

#caller responsibilities
sw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
sw $t1 offset($sp)
sw $t2 offset($sp)

sw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
sw $a1 , offset($sp)
sw $a2 , offset($sp)

sw $v0 , offset($sp) #do we even have any return from a higher nested instruction?

#updating parameters passed to swap
addi $a2 $s4 0 #passing midpoint index to a2
#a1 should still be the index of x[lo]

bgezal $t2, swap #same jump trick as previously described

#caller return responsibilities
lw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
lw $t1 offset($sp)
lw $t2 offset($sp)

lw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
lw $a1 , offset($sp)
lw $a2 , offset($sp)

###############################################################################
#swap(x,lo,mid).

#caller responsibilities
sw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
sw $t1 offset($sp)
sw $t2 offset($sp)

sw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
sw $a1 , offset($sp)
sw $a2 , offset($sp)

sw $v0 , offset($sp) #do we even have any return from a higher nested instruction?

#updating parameters passed to swap
addi $a2 $s4 0 #passing midpoint index to a2
#a1 should still be the index of x[lo]

jal		swap				# jump to swap and save position to $ra


#caller return responsibilities
lw $t0 offset($sp) #not sure that we actually care about the t vals; just following convention
lw $t1 offset($sp)
lw $t2 offset($sp)

lw $a0 , offset($sp) #a0 doesn't really change, so do we need this?
lw $a1 , offset($sp)
lw $a2 , offset($sp)

#calle return responsibilities
lw $s0-sWhatever offset($sp)
lw $ra offset($sp)
lw $fp offset($sp)
addi $sp, $sp, offset #move the stacker pointer to pop it off

	# return to caller
	jr $ra

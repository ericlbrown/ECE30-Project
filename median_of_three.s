########################
#   medianOfThree      #
########################
medianOfThree:

	### INSERT YOUR CODE HERE

	#orgaizational calle business

addi $sp , $sp, -60 #tbd how far to increment the stack pointer
sw $ra, 24($sp)
sw $s0, 20($sp)
sw $s1, 16($sp)
sw $s2, 12($sp)
sw $s3, 8($sp)
sw $fp, 4($sp)
addi $fp, $fp, -60


#calculating midpoint value

add $s0, $a1, $a2 #s0 = lo+hi
li $t0, 2
div $s0, $t0 #(lo+hi)/2
mflo $s0 #loads value into register srl didn't seem to work


#now we will worry about getting values from our indexed addresses
#at least for the first conditional

#loading value from x[lo]

sll $t0, $a1, 2
add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
lw $s1, 0($t1) #our actual value from x[lo] is now stored in s1

#repeating above for x[hi]

sll $t0, $a2, 2 #this time we use the index for x[high]/ ie the right value
add $t1, $t0, $a0
lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]


#repeat for x[mid]

sll $t0, $s0, 2
add $t1, $t0, $a0
lw $s3, 0($t1) #load to s3 the value stored in memory x[mid]

# so now we have :
#val x[lo] stored in s1
#val x[hi] stored in s2
#val x[mid] stored in s3

###############################################################################
# if(x[lo]>x[hi]) swap(x,lo,hi)
slt $t2, $s2, $s1 #evaluate x[hi] <x[lo]
addi $t2, $t2, -1 #so if x[hi]<x[lo] t2 = 0 else t2 = -1

#the reason I did this was because we have a pseduo instruction that will evaluate
#then jump and link to our swap function so it saves time for us

#orgaizational for caller before call

sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
sw $t1, 32($sp)
sw $t2, 36($sp)

sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
sw $a1 , 44($sp)
sw $a2 , 48($sp)

sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

#inputs to the swap function are already set because they are the same as for
#Median of Three

#jump to swap(x,lo,hi)
bgezal $t2 swap #branch on greater than or equal to zero and link

#return from calle orgaizational; mostly useless but will we get docked without it

lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
lw $t1, 32($sp)
lw $t2, 36($sp)
lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
lw $a1 , 44($sp)
lw $a2 , 48($sp)


################################################################################
# if(x[mid]>x[hi]) swap(x,mid,hi)

#need to reload the value at x[hi] since things have now been swapped

sll $t0, $a2, 2 #this time we use the index for x[high]/ ie the right value
add $t1, $t0, $a0
lw $s2, 0($t1) #load to s2 the value stored in memory x[hi]

#mid is still the same value as before

slt $t2, $s2, $s3 #compare x[hi]<x[mid]
addi $t2, $t2, -1 #same trick as before

#caller responsibilities
sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
sw $t1, 32($sp)
sw $t2, 36($sp)

sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
sw $a1 , 44($sp)
sw $a2 , 48($sp)

sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

#this time we do need to change some things around when passing to swap
#$a0 is still the first address of the array
addi $a1, $s0, 0 #passing midpoint index to a1
#a2 is still holding our hi index values

bgezal $t2, swap #same jump trick as previously described

#return from calle orgaizational; mostly useless but will we get docked without it

lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
lw $t1, 32($sp)
lw $t2, 36($sp)

lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
lw $a1 , 44($sp)
lw $a2 , 48($sp)
###############################################################################
#if(x[lo]>x[mid]) swap(x,lo,mid)

#reloading values from x[lo] and x[mid] into s1 and s3 respectively
sll $t0, $a1, 2 #multiply index by 4
add $t1, $t0, $a0 #address of x[lo] is now stored in t1 : x[lo] = *x[0]+offset
lw $s1, 0($t1) #our actual value from x[lo] is now stored in s1

sll $t0 $s0, 2 #this time we use the index for x[mid] that we stored in $s0
add $t1, $t0, $a0
lw $s3, 0($t1) #load to s3 the value stored in memory x[mid]


slt $t2, $s3, $s1 #comparing x[mid]<x[lo]
addi $t2, $t2, -1

#caller responsibilities
sw $t0 ,28($sp) #not sure that we actually care about the t vals; just following convention
sw $t1 ,32($sp)
sw $t2 ,36($sp)

sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
sw $a1 , 44($sp)
sw $a2 , 48($sp)

sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

#updating parameters passed to swap
addi $a2, $s0, 0 #passing midpoint index to a2
#a1 should still be the index of x[lo]

bgezal $t2, swap #same jump trick as previously described

#caller return responsibilities
lw $t0 ,28($sp) #not sure that we actually care about the t vals; just following convention
lw $t1 ,32($sp)
lw $t2 ,36($sp)

lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
lw $a1 , 44($sp)
lw $a2 , 48($sp)
###############################################################################
#swap(x,lo,mid).

#caller responsibilities
sw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
sw $t1, 32($sp)
sw $t2, 36($sp)

sw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
sw $a1 , 44($sp)
sw $a2 , 48($sp)

sw $v0 , 52($sp) #do we even have any return from a higher nested instruction?

#updating parameters passed to swap
addi $a2, $s0, 0 #passing midpoint index to a2
#a1 should still be the index of x[lo]

jal		swap				# jump to swap and save position to $ra


#caller return responsibilities
lw $t0, 28($sp) #not sure that we actually care about the t vals; just following convention
lw $t1, 32($sp)
lw $t2, 36($sp)

lw $a0 , 40($sp) #a0 doesn't really change, so do we need this?
lw $a1 , 44($sp)
lw $a2 , 48($sp)

#calle return responsibilities
lw $s0, 20($sp)
lw $s1, 16($sp)
lw $s2, 12($sp)
lw $s3, 8($sp)
lw $ra, 24($sp)
lw $fp, 4($sp)
addi $sp, $sp, 24 #move the stacker pointer to pop it off
	# return to caller
	jr $ra

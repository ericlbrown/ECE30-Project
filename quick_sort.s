quickSort:
	# a0: base address
	# a1: left  = first index to be sorted
	# a2: right = last index to be sorted
	# Sort the list using recursive quick sort using the above functions

	#organizational tasks
  addi $sp, $sp, -40
  sw $ra, 0($sp)
  sw $fp, 4($sp)
  addi $fp, $fp, -40

	#median of three pivot; first set of inputs should already be set and
  #have been passed to quicksort on call

  sub $t0, $a2, $a1 #a2-a1 = numElements in list
  slti $t1, $t0, 2 #if a2-a1 < <2 set a flag
  bnez $t1, quickSortEnd #return to caller if elements less than 2, ie sorted already

  #if we have a valid list then we can jump to median of three
  #pre call organization; is this necesarry because our function is meant to
  #overwrite these value entirely

  jal medianOfThree

  sll $s0, $a1, 2 #multiply a1 by 4 to get offset to load value there
  add $t0, $a0, $s0 #we are now finding the address of x[first]
  lw $a3, 0($t0) #loading value from x[first] to $a3 which is the pivot and upcoming argument

  #pre partion call organization
  sw $a0, 8($sp)
  sw $a1, 12($sp)
  sw $a2, 16($sp)
  sw $a3, 20($sp)
  #preparing input arguments to partition
  #a0 is still a0 from last argument
  addi $a1, $a1, 1 #partion element 2 is first + 1
  #a2 is not touched
  #a3 is set above and ready to go

  #partition
	jal partition

  #return from call organization
  lw $a0, 8($sp)
  lw $a1, 12($sp)
  lw $a2, 16($sp)
  lw $a3, 20($sp)

  addi $s0, $v0, -1 #index = partition return value -1

  sw $a2, 16($sp) #save last because we need to call swap with index as a2
  addi $a2, $s0, 0 #load index into swap's 3rd parameter

  jal swap

  #post call organization
  lw $a2 , 16($sp)

	#recursion conditions until finished

  #left partition

  #precall organization
  #a0 is still a0
  #a1 is still a1
  sw $a0, 8($sp)
  sw $a1, 12($sp)
  sw $a2, 16($sp)
  addi $a2, $s0, -1 #making quicksort param2 = index-1
	jal quickSort

  #post call organization
  lw $a0, 8($sp)
  lw $a1, 12($sp)
  lw $a2, 16($sp)

  #right partition
  #a0 is still a0
  #a2 is still a2
  sw $a0, 8($sp)
  sw $a1, 12($sp)
  sw $a2, 16($sp)
  addi $a1, $s0, 1 #making quicksort param1 = index+1

  jal quickSort

  lw $a0, 8($sp)
  lw $a1, 12($sp)
  lw $a2, 16($sp)

 # calle exit organization
  # return to caller
  quickSortEnd:
    lw $ra, 0($sp)
    lw $fp, 4($sp)
    addi $sp, $sp, 40
    addi $fp, $fp, 40

    jr $ra

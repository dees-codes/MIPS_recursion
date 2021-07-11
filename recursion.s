	# Deepson Shrestha
	# Project 2 - CS 330

	# MIPS implementation of recursive arithmetic operation

	# Data segment contents
	.data
prompt1:	.asciiz "Enter non negative base and exponent: \n"
prompt2:	.asciiz "Error: 0 ^ 0. \n"
prompt3:	.asciiz " ^ "
prompt4:	.asciiz " = "


	
	# Make sure the rest of the word size variables start on a byte
	# address that is a multiple of 4
	.align 2

	.text
	# b is associated with $s0
	# e is associated with $s1

main:
	# move original return address to the system into $s7
	move $s7, $ra

	# Prompt for entering base and exponent
	la $a0, prompt1
	li $v0, 4
	syscall

	# Read base into $s0
	li $v0, 5
	syscall
	move $s0, $v0

	# Read exponent into $s1
	li $v0, 5
	syscall
	move $s1, $v0

if:
	# "b==0" : branch on b!=0
	bne $s0, $zero, if_exit
	# "e==0" : braonch on e!=0
	bne $s1, $zero, if_exit
	# if (b==0 && e==0), print the error prompt
	la $a0, prompt2
	li $v0, 4
	syscall

	# jump to Exit
	j Exit

Exit:
	# copying return address to system to $ra
	move $ra, $s7
	# Exiting the program
	j $ra	

if_exit:
	# print base from $s0
	move $a0, $s0
	li $v0, 1
	syscall

	# print " ^ "
	la $a0, prompt3
	li $v0, 4
	syscall

	# print exponent from $s1
	move $a0, $s1
	li $v0, 1
	syscall

	# print " = "
	la $a0, prompt4
	li $v0, 4
	syscall

	#call raise(b,e)
	move $a0, $s0		#$a0 = $s0
	move $a1, $s1		#$a1 = $s1
	jal raise		#j to raise and
				#$ra = addrss of next instruction

	#print contents of $v0 (final result of program)
	move $a0, $v0
	li $v0, 1
	syscall
	j Exit

multa:
	# store data in stack
	addi $sp, $sp, -12	#adjust stack for 3 items
	sw $a0, 8($sp)		#save the argument a 
	sw $a1, 4($sp)		#save the argument b
	sw $ra, 0($sp)		#save the return address

	# "a==b" : branch on a!=b
	bne $a0, $zero, if3_exit
	# if (a==b), return 0
	li $v0, 0
	j mult_return		#j to mult_return

if3_exit:
	# if (a!=b)
	addi $a0, $a0, -1	#$a0 = $a0 - 1
	jal multa		#j to multa and save return address
	add $v0, $a1, $v0	#return the (returned value + $a1)

mult_return:
	lw $ra, 0($sp)		#restore return address
	lw $a1, 4($sp)		#restore the argument b
	lw $a0, 8($sp)		#restore the argument a
	add $sp, $sp, 12	#adjust sp to pop 3 items
	jr $ra	

raise:
	addi $sp $sp,-12	#adjust stack for 3 items
	sw $a0, 8($sp)		#save the argument a
	sw $a1, 4($sp)		#save the argument b
	sw $ra, 0($sp)		#save the return address
	
	# "b==0": branch on b!=0
	bne $a1, $zero, if2
	# if (b==0), return 1
	li $v0, 1
	# jump to raise_return and save the return address
	j raise_return

if2:
	andi $t0, $a1, 1	#$t0 = $a1 & 0x1
	# if $t0 != 1, branch to if2_exit
	beq $t0, 0, if2_exit
	# if $t0 = 0x1
	#call mult (a, raise (a, b-1))
	#calculate raise(a, b-1)first
	addi $a1, $a1, -1	#$a1 = $a1 - 1
	jal raise		#jump to raise and save return address
	move $a1, $v0		#$a1 = $v0
	jal multa		#jump to multa and save return address
	j raise_return		#jump to raise_return

if2_exit:
	srl $a1, $a1, 1		# $a1 = $a1/2
	jal raise		# call raise($a0, $a1)
	move $t1, $v0		# $t1 = $v0
	move $a0, $t1		# $a0 = temp
	move $a1, $t1		# $a1 = temp
	jal multa		# call mult($a0, $a1) and save return address
	j raise_return		# jump to raise return
	
raise_return:
	lw $a0, 8($sp)		# restore the argument a
	lw $a1, 4($sp)		# restore the arugment b
	lw $ra, 0($sp)		# restore the return address
	addi $sp, $sp, 12	# adjust stack pointer to pop 3 items
	j $ra			# jump to $ra = return address in main




	
	
	
	
	


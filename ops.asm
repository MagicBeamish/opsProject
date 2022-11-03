#Graham "Boomer" Myers, CSC 2025 1N1
#Data declarations
.data
	#print out a prompt to the console asking the user to enter numbers
	header:	.asciiz "Enter 3 numbers to the program\n"

	#Ask for a single number
	prompt: .asciiz "Enter a number and hit enter\n"
	
	#use message as argument for printing to console
	message: .asciiz "\nYour numbers are "

	#variable for space inbetween output numbers
	space: .asciiz " "

	#Variable to explain what the result of addition has been
	additionMessage: .asciiz "\nThe sum of your numbers is "

	#Variable to explain what the result of multiplication has been
	productMessage: .asciiz "\nThe product of your numbers is "

	#Variable to explain what the average of input numbers is
	averageMessage: .asciiz "\nThe average of your numbers is "

	#variable to explain which number is the largest
	largestMessage: .asciiz "\nThe largest number is "

	#variable to explain which number is the smallest
	smallestMessage: .asciiz "\nThe smallest number is "

#Program code
.text

main: 

	#Print header argument to console
	li $v0, 4 #Load Immediate: pseudoinstruction. Load register $v0 with the value 4 which invokes the syscall instruction number 4
	la $a0, header #Load Address: pseudoinstruction. Load $a0 with the address of the header message.
	syscall #Trigger a system call exception, and cause the kernel to take control to handle the system call

	#Print the prompt argument to the console
	li $v0, 4 
	la $a0, prompt
	syscall

	#Take in the number from console and store it to $v0 
	li $v0, 5
	syscall

	#Store the result in $s1 with pseudo instruction
	move $s1, $v0

	#Ask for second number
	li $v0, 4
	la $a0, prompt
	syscall

	#Take in the second number from console and store it in $v0
	li $v0, 5
	syscall

	#Store the result in $s2 with pseudo instruction
	move $s2, $v0

	#Ask for third number
	li $v0, 4
	la $a0, prompt
	syscall

	#Take in the third number from console
	li $v0, 5
	syscall

	#Store the result in $s3 with pseudo instruction
	move $s3, $v0

	#Display message to console
	li $v0, 4
	la $a0, message
	syscall

	#Print out first number to console
	li $v0, 1
	move $a0, $s1
	syscall

	#Put a space between first and second number in console for readability
	li $v0, 4
	la $a0, space
	syscall

	#Print out second number to console
	li $v0, 1
	move $a0, $s2
	syscall

	#Put a space between second and third number in console for readability
	li $v0, 4
	la $a0, space
	syscall

	#Print out third number to console
	li $v0, 1
	move $a0, $s3
	syscall

	#Put a space. If the space isn't present then the program will continue
	#to print the third number to the console several times
	li $v0, 4
	la $a0, space
	syscall

	#Calculate the sum of the 3 input numbers
	add $t0, $s1, $s2 #Add the first two number entries
	add $t0, $t0, $s3 #Add the sum of the first two number entries to the third number entry
	addi $s4, $t0, 0 #save the sum of the 3 numbers to $s4
	syscall

	#Print out the addition message to the console
	li $v0, 4 
	la $a0, additionMessage
	syscall

	#Print out the result of the addition calculation
	li $v0, 1
	move $a0, $s4
	syscall

	#Print out a space to prevent repeatedly printing to the console
	li $v0, 4
	la $a0, space
	syscall

	#Calculate the product of the 3 input numbers using a pseudo-command mul
	#The mul $t1, $s1, $s2 pseudoinstruction corresponds to 
	#mult $s1, $s2
	#mflo $t1
	mul $t1, $s1, $s2 
	mul $t1, $t1, $s3
	addi $s5, $t1, 0 #save the product of 3 numbers to $s5
	syscall

	#Print out the product message to the console
	li $v0, 4 
	la $a0, productMessage
	syscall

	#Print out the result of the multiplication calculation
	li $v0, 1
	move $a0, $s5
	syscall

	#Print out a space to prevent repeatedly printing to the console
	li $v0, 4
	la $a0, space
	syscall

	#Calculate the average of the 3 input numbers
	#The div pseudoinstruction in this program has a few steps underneath to check whether or not
	#the program divides by zero, and then to divide, round down, and then
	#add that result to the register.
	#bne $t3, $s0, 0x00000001
	#break
	#div $t0, $t2
	#mflo $t3
	addi $t2, $s0, 3
	div $t3, $t0, $t2
	addi $s6, $t3, 0 #save the average of 3 numbers to $s6
	syscall

	#Print out the average message variable to the console
	li $v0, 4 
	la $a0, averageMessage
	syscall

	#Print out the result of the averaging calculation to the console
	li $v0, 1
	move $a0, $s6
	syscall

	#Print a space to the console to prevent repeated entries
	li $v0, 4
	la $a0, space
	syscall

	#Use a path to find which of the numbers is the smallest

	#Test if $s1 is smaller than $s2, if $s2 is smaller than $s1, or if $s3 is smaller than $s1
	#Branch less than is a pseudocode which is similar to 
	#slt $t0, $s1, $s2, 
	#bne $t0, $s0, goToLabel
	blt $s1, $s2, tests1ands3 #If $s1 is smaller than $s2, move to the flag tests1and3
	blt $s2, $s1, tests2ands3 #If $s2 is smaller than $s1, move to the flag tests2and3
	blt $s3, $s1, tests3ands2 #If $s3 is smaller than $s1, move to the flag tests1and3

	#This set of pseudoinstructions tells QTSPIM that it is the end of the main program.
	#The reason for this is that the rest of the program will be executed throug a series of labels
	#which are not included in the main program.
	li $v0, 10
	syscall

#This flag is the result of a true value after testing whether $s1 is smaller than $s2
tests1ands3: 
	blt $s1, $s3, s1issmallest #$s1 is smaller than $s2 and $s3, which means that it is the smallest
	syscall

#This flag is the result of a true value after testing whether $s2 is smaller than $s1
tests2ands3:
	blt $s2, $s3, s2issmallest #$s2 is smaller than $s1 and $s3, which means that it is the smallest
	syscall

#This flag is the result of a true value after testing whether $s1 is smaller than $s2
tests3ands2:
	blt $s3, $s2, s3issmallest #$s3 is smaller than $s1 and $s2, which means that it is the smallest
	syscall

#$s1 holds the smallest value
s1issmallest:
	li $v0, 4
	la $a0, smallestMessage #Load the address of the smallestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s1 #Print $s1 to the console
	syscall
	#After returning that $s1 has the smallest value, check whether $s3 or $s2 has the larger value
	blt $s2, $s3, s3islargest #$s3 is largest
	blt $s3, $s2, s2islargest #$s2 is the largest
	syscall

#$s2 holds the smallest value
s2issmallest:
	li $v0, 4
	la $a0, smallestMessage #Load the address of the smallestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s2 #Print $s2 to the console
	syscall
	#After returning that $s2 has the smallest value, check whether $s1 or $s3 has the larger value
	blt $s1, $s3, s3islargest #If $s1 is smaller than $s3, $s3 is the largest. Go to the flag s3islargest.
	blt $s3, $s1, s1islargest #If $s3 is smaller than $s1, $s1 is the largest. Go to the flag s1islargest.
	syscall

#$s3 holds the smallest value
s3issmallest:
	li $v0, 4
	la $a0, smallestMessage #Load the address of the smallestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s3 #Print $s3 to the console
	syscall
	#After returning that $s3 has the smallest value, check whether $s2 or $s1 has the larger value
	blt $s2, $s1, s1islargest #If $s2 is smaller than $s1, $s1 is the largest. Go to the flag s1islargest.
	blt $s1, $s2, s2islargest #If $s1 is smaller than $s2, $s2 is the largest. Go to the flag s2islargest.
	syscall

#Flag result if $s1 contains the largest of the entered values
s1islargest:
	li $v0, 4
	la $a0, largestMessage #Load the address of the largestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s1 #Print $s1 to the console
	syscall
	#Put a space in console for readability
	li $v0, 4
	la $a0, space
	li $v0, 10
	syscall

	#tell the system this is the end of the main function: terminate
	li $v0, 10
	syscall

#Flag result if $s2 contains the largest of the entered values
s2islargest:
	li $v0, 4
	la $a0, largestMessage #Load the address of the largestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s2 #Print $s2 to the console
	syscall
	#Put a space in console for readability
	li $v0, 4
	la $a0, space
	li $v0, 10
	syscall

	#tell the system this is the end of the main function: terminate
	li $v0, 10
	syscall

#Flag result if $s3 contains the largest of the entered values
s3islargest:
	li $v0, 4
	la $a0, largestMessage #Load the address of the largestMessage value and return it
	syscall
	li $v0, 1
	move $a0, $s3 #Print $s3 to the console
	syscall
	#Put a space in console for readability
	li $v0, 4
	la $a0, space
	li $v0, 10
	syscall

	#tell the system this is the end of the main function: terminate
	li $v0, 10
	syscall

.end main
.data
	enterStringPrompt: .asciiz "Enter your string to convert in base 10: " 
	extraspace: .asciiz " "
	intPrompt: .asciiz "\nThe base 10 value is " 
	buffer:   .space 300 #Length that I sent to max is 300 chars
	enterIntPrompt: .asciiz "Enter your int that is between 2-16: "
	emptyStringVar: .space 10 #Reserve 10 spaces for safety
	empSt: .asciiz ""
	debug: .asciiz "Debug Statement"
	nullValue : .asciiz "\n"
	errIntPrompt: .asciiz "Please input a base that is 2-16 inclusive,you entered: "
	negativeSign:.asciiz "-"
	errStringPrompt: .asciiz "Illegal string inputted, please enter a legal string and try again"
	errStringEmptyPrompt: .asciiz "This field cannot be left blank, please rerun the program and try again"
	errWrongBase: .asciiz "You have entered a base that is impossible to convert with this value, please enter a legal base and try again"
	newLine: .asciiz "\n"
	rerunProgramPrompt: .asciiz "\nRerun the calculator? (press (y) for yes, or any other key for no) " 
	
.text
interfaceUser: 
							#Reset values for a rerun
	addi $s0, $0, 0
	addi $s1, $0, 0
	addi $s2, $0, 0
	addi $s3, $0, 0
	addi $s4, $0, 0
	addi $s5, $0, 0
	addi $s6, $0, 0
	addi $s7, $0, 0


	addi $s2 $s2,0 					#init the count for the digitString
	li $v0, 4 					#Call this to start printing a string
	la $a0, enterStringPrompt 			#Load address into prompt
	syscall
	
	 li $v0,8 					#Read the String 
         la $a0, buffer 				#load byte space into address
         li $a1, 300 					#Allot the byte space for string
         move $s0,$a0 					#Save string to s0
         add $s3, $0, $s0 				#Copy the user's string that we will manipulate later in the formula
         syscall
         
         li $v0, 4 					#Call this to start printing a string 
         la $a0, enterIntPrompt 			#Load address into prompt
         syscall
         
         li $v0, 5 					#Read the int the user put
         syscall
         move $s1, $v0 					#Save the value to another var
         
         
        
         
	

#(s0 = String),(s1 = int)(s2 = countForDigitString)
baseCasesForStrings1:

	lbu $t0, ($s0) 					#Look a char asacii value to t0
	la $t1, nullValue
	lbu $t2, ($t1)
	la $t4, negativeSign 
	lbu $t3, ($t4) 
	beq $t2, $t0, emptyStringBC1  			#If the string is empty, beq
	beq $t0, $t3, twoComplement 			#If the string has a negative, do two's complement
	j baseCasesForStrings2 				#Then we can assume we have a hopefully legal string!
	
	
baseCasesForStrings2: 
	lbu $s6, ($s0)
	
	beq $s6, 10, baseCasesForInts 			#If we reach the end of the string, then go to the int base cases
	beq $s5, -7777, skip 				#This is a flag that checks if there is a negative sign in the string, if there is skip the base cases and move on to next char
	
	blt $s6, 65, zeroNineCasee 			#If we are a number go to the number base case
	bgt $s6, 58, letterCasee  			#If we are a letter go to the letter base case
	
	
	zeroNineCasee:
		bgt $s6, 58, errorStringValue 		#This case takes care of the unwanted ascaii symbols in the middle of the numbers and letters
		blt $s6, 48, errorStringValue
		j continue
	
	letterCasee:
		blt $s6, 65, errorStringValue 		#This case takes care of the unwanted ascaii symbols in the middle of the numbers and letters
		bgt $s6, 70, errorStringValue 
		j continue
	
	continue:
		addi $s2, $s2, 1 			#increment the countForDigitStringCount
	
	skip:
		addi $s0, $s0, 1 			#Go to the next string char
		addi $s5, $0, 0 			#Reset the s5 so it does now checks to see if the errorStringValue occurs
		j baseCasesForStrings2 			#Keep jumping until no char left


	j baseCasesForInts 				#Should never hit this


errorStringValue:
	addi $s7, $0, 0 				#Zero return value 
	li $v0, 4					#Call a service number of 4 to print the string
	la $a0, errStringPrompt 			#Load address of prompt
	syscall
	j fin





emptyStringBC1:
	addi $s7, $0, 0 				#Zero return value 
	li $v0, 4					#Call a service number of 4 to print the string
	la $a0, errStringEmptyPrompt			#Load address of prompt
	syscall
	j fin 
	



baseCasesForInts:
	blt $s1, 2, errorIntValue 
	bgt $s1, 16, errorIntValue			#If the int is real then do the count digitSring then bracefor impact then formula
	j presetVar


#($s5 = global flag for seeing if its a negative)
twoComplement:
	add $s5, $0, -7777 				#A flag to add a negative
	j baseCasesForStrings2

errorIntValue:
	addi $s7, $0, 0 				#Zero return value 
	li $v0, 4					#Call a service number of 4 to print the string
	la $a0, errIntPrompt 				#Load address of prompt
	syscall						#What I was doing was printing what the users input was might del thiss
	li $v0, 1
	move $a0, $s1
	syscall
	j fin



presetVar:
	addi $s6, $0, 0 				#Reset $s6 for reuse
	j stringToInt 					#Go back to stringToInt for the meantime 


errWrongBasevalue:
	addi $s7, $0, 0 				#Zero return value 
	li $v0, 4
	la $a0, errWrongBase
	syscall
	j fin 


#(s0 = String/digitString, or $s3(use this), s1 = int/base) (s2 = countForDigitString) ($s4 = N)
stringToInt:
	add $s4, $0, $s2 				#Saves $t0 as the length of the digitString (N) or index
	add $t4, $0, $s2 				#Saves $t0 as the length of the digitString (N) or index
	addi $s2, $0, 0
	
	while:
		add $t5, $0, $s4 			#Copy and paste to $t5
		lbu $s6, 0($s3) 			#Get the char in the string 
		beq $s6, 45, addtheNegative 		#Add the negative sign before the int prints
		beq $s4, 0, fin
		
		jal convertDigit
		
		move $t6, $v0 				#Take the return value from convertDigit and save it to $s7
		add $s7, $s7, $t6 			#Add to the return var running total
		addi $s3, $s3, 1 			#Look at the next char
		subi $s4, $s4, 1 			#Decrement the index
		j while
		
	addtheNegative:
		add $s5, $0, -7777 			#A flag to activate the prompt with the negative symbol
		addi $s3, $s3, 1 			#Look at the next char
		j while
		



#(s6 = currentChar,t0 = base)
convertDigit:
	subi $t5, $t5, 1 				#Index/length
	add $t0, $0, $s1
	bgt $s6, 64, AFcase  
	
	
	zeroNineCase:
		subi $s2, $s6, 48 			#This now equals the int
		bgt $s2, $s1, errWrongBasevalue  	#Is the current char > users base
		blt $s2, 0, errWrongBasevalue		#Is the current char < 0
		
		j convertLoop
		  
	
	AFcase:
		subi $s2, $s6, 65
		addi $s2, $s2, 10 			#This should now equal the int
		bgt $s2, $s1, errWrongBasevalue 	#Check if the string can even be converted to the base asked 
		j convertLoop

	
	convertLoop:
		beq $t5, 1, cyberPunkContinue 		#Might have to make this -1
		beq $t5, 0, cx11			#Check if we are in 0 index like 2^0 we can 
		mul $t0,$t0,$s1 			#userBase^index 
		sub $t5, $t5, 1				#Subtract the index
		j convertLoop	
			
			cyberPunkContinue:	
				mul $t3 ,$s2, $t0 	#Mult base by int
				move $v0, $t3 		#Add the converted value to $v0
				jr $ra			


cx11:
	move $v0, $s2 					#Add the converted value to $v0
	jr $ra

fin:
							#Add last print statement
							#Print the prompt
	beq $s5, -7777, secdPrompt
							#If it reaches this point then we know it is a positive value
	li $v0, 4					#Call a service number of 4 to print the string
	la $a0, intPrompt 				#Load address of prompt
	syscall
	
	j printInt
	
	
secdPrompt:
	li $v0, 4 					#Call a service number of 4 to print the string 
	la $a0, intPrompt
	syscall
	mul $s7, $s7, -1				#Turn the positive number into a negative to account for the negative the user inputted
	j printInt

	
printInt:
	li $v0, 1 					#Print the int
	move $a0, $s7 					#Return statement for int
	syscall
	
	li $v0, 4
	la $a0, rerunProgramPrompt
	syscall
	j maybeReRun
	
	
maybeReRun: 
	 li $v0,8 					#Read the String 
         la $a0, buffer 				#load byte space into address
         li $a1, 300 					#Allot the byte space for string
         move $s0,$a0 					#Save string to s0
         syscall
	 lbu $t0, 0($s0) 				#Get the char in the string 
	 beq $t0, 121, interfaceUser
	
end:
	#Ends the Program
	li $v0, 10 					#Calls the program to stop with a code of 10
	syscall

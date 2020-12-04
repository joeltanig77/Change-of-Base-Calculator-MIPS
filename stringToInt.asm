#Joel Tanig
#Debug tool 
	#li $v0, 4	#Call a service number of 4 to print the string
	#la $a0, debug 	#Load address of prompt
	#syscall
	#j fin 
	

.data
	enterStringPrompt: .asciiz "Enter your string: " 
	extraspace: .asciiz " "
	intPrompt: .asciiz "\nInt value is "
	intNegativePrompt: .asciiz "\nInt value is -" 
	buffer:   .space 300 #Length that I sent to max is 300 chars
	enterIntPrompt: .asciiz "Enter your int that is between 2-16: "
	emptyStringVar: .space 10 #Reserve 10 spaces for safety
	empSt: .asciiz ""
	debug: .asciiz "Debug Statement"
	nullValue : .asciiz "\n"
	errIntPrompt: .asciiz "Please input a number that is 2-16 inclusive,you entered: "
	negativeSign:.asciiz "-"
	errStringPrompt: .asciiz "Illegal string inputted, please enter a legal string and try again"
	errStringEmptyPrompt: .asciiz "Really bro, an empty string, I see how it is, please enter a legal string and try again"
	errWrongBase: .asciiz "You have entered a base that is impossible to convert with this string, please enter a new base and try again"
	
	
.text


#Do, if its a negative string like (-test) do two numbers 

interfaceUser: 
	addi $s2 $s2,0 #init the count for the digitString
	li $v0, 4 #Call this to start printing a string
	la $a0, enterStringPrompt #Load address into prompt
	syscall
	
	li $v0,8 #Read the String 
         la $a0, buffer #load byte space into address
         li $a1, 300 #allot the byte space for string
         move $s0,$a0 #save string to s0
         add $s3, $0, $s0 #Copy the user's string that we will manipulate later in the formula
         syscall
         
         li $v0, 4 #Call this to start printing a string 
         la $a0, enterIntPrompt #Load address into prompt
         syscall
         
         li $v0, 5 #Read the int the user put
         syscall
         move $s1, $v0 #Save the value to another var
         
         
        
         
	

#(s0 = String),(s1 = int)(s2 = countForDigitString)
#I need to loop in each char and check if its passes the ascaii tests and if it has
# a null turm, string
baseCasesForStrings1: #TODO

	lbu $t0, ($s0) #Look a char asacii value to t0
	la $t1, nullValue
	lbu $t2, ($t1)
	la $t4, negativeSign 
	lbu $t3, ($t4) 
	
	
	#The beqs!
	beq $t2, $t0, emptyStringBC1 #If the string is empty, beq
	beq $t0, $t3, twoComplement #If the string has a negative, do two's complement
		
	
	
	j baseCasesForStrings2 #Then we can assume we have a hopefully legal string!
	


#($t0 /$s6 = this is the char that we are at)
baseCasesForStrings2: #Something is going on here!!!!
	lbu $s6, ($s0)
	#DEBUG STATEMENT
	#li $v0, 1	#Call a service number of 1 to print the int
	#move $a0, $s6 	#Load address of prompt
	#syscall
	
	beq $s6, 10, baseCasesForInts #If we reach the end of the string, then go to the int base cases
	beq $s5, -7777, skip #Start here Trying to fix this which is trying to skip the negative value at first glance you got this!
	bgt $s6, 70, errorStringValue
	
	blt $s6, 48, errorStringValue 
	
	

	addi $s2, $s2, 1 #increment the countForDigitStringCount
	
	
	
	#1). Need to cheSck the inbetween values of the ascaii table of symbols (between numbers and letters) ########################## NEXT
	
	
	skip:
		addi $s0, $s0, 1 #Go to the next string char
		addi $s5, $0, 0 #Reset the s5 so it does now checks to see if the errorStringValue occurs
		j baseCasesForStrings2 #Keep jumping until no char left


	j baseCasesForInts #Should never hit this


errorStringValue:
	addi $s7, $0, 0 #Zero return value 

	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, errStringPrompt 	#Load address of prompt
	syscall

	j fin





emptyStringBC1:
	addi $s7, $0, 0 #Zero return value 
	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, errStringEmptyPrompt	#Load address of prompt
	syscall
	j fin 
	



baseCasesForInts:
	blt $s1, 2, errorIntValue 
	bgt $s1, 16, errorIntValue
	###If the int is real then do the count digitSring then bracefor impact then formula
	j presetVar



twoComplement: # TODO ($s5 = global flag for seeing if its a negative)
	add $s5, $0, -7777 #A flag to add a negative
	
	
	j baseCasesForStrings2

errorIntValue:
	addi $s7, $0, 0 #Zero return value 

	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, errIntPrompt 	#Load address of prompt
	syscall
	# What I was doing was printing what the users input was might del thiss
	li $v0, 1
	move $a0, $s1
	syscall
	j fin



presetVar:
	addi $s6, $0, 0 #Reset $s6 for reuse
	j stringToInt
	


#(s0 = String/digitString, or $s3(use this), s1 = int/base) (s2 = countForDigitString) ($s4 = N)
stringToInt: # TODO
	

	add $s4, $0, $s2 #Saves $t0 as the length of the digitString (N) or index
	
	#Debug Statement, Turn this back on when you get here!!
	li $v0, 1 #Print the int
	move $a0, $s4 #Return statement for int
	syscall
	
	
	addi $s0, $0, 0 #digit = 0
	addi $t2, $0, 0 #result = 0
	addi $t3, $0, 1 #positionValue
	
	while:
		lbu $s6, 0($s3) #Get the char in the string 
		beq $s6, 45, addtheNegative #Add the negative sign before the int prints
		beq $s6, 10, fin #If the string is empty, beq to the formula ############### Might have to change this
		
		jal convertDigit
		
		move $s7, $v0 #Take the return value from convertDigit and save it to $s7
		
		addi $s3, $s3, 1 #Look at the next char
		
		j while
	
	
	addtheNegative:
		add $s5, $0, -7777 #A flag to activate the prompt with the negative symbol
		addi $s3, $s3, 1 #Look at the next char
		j while
		



#(s6 = currentChar, s1 = int/base) (s2 = countForDigitString) ($s4 = N or index) 
convertDigit:
	bgt $s6, 57, AFcase  
	add $t0, $0, $s1 #Copy and paste the users base (#t0 = user's base)
	addi $s1, $0, 0 #Reuse the s value for our int
	
	zeroNineCase:
		subi $s1, $s6, 48 #This now equals the int
		j convertLoop
		  
	
	AFcase:
		subi $s1, $s6, 65
		addi $s1, $s1, 10 #This should now equal the int
		j convertLoop

	
	convertLoop:
		mult $t0, $s4 #userBase^index
		mflo $t1
		mult $t1, $s1
		mflo $t2
		subi $s4, $s4, 1 #increment the index to subtract 1 
		
		move $v0, $t2 #Add the converted value to $v0		
		
jr $ra







fin2: #Debug case PLEASE DONT ENTER STOP
		#Ends the Program
	li $v0, 10 #Calls the program to stop with a code of 10
	syscall


fin:
	#Add last print statement
	#Print the prompt
	beq $s5, -7777, secdPrompt
	
	#If it reaches this point then we know it is a positive value
	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, intPrompt 	#Load address of prompt
	syscall
	
	j printInt
	
	
secdPrompt:
	li $v0, 4 #Call a service number of 4 to print the string 
	la $a0, intNegativePrompt
	syscall
	j printInt

	

printInt:
	li $v0, 1 #Print the int
	move $a0, $s7 #Return statement for int
	syscall
	
	
	
end:
	#Ends the Program
	li $v0, 10 #Calls the program to stop with a code of 10
	syscall
	

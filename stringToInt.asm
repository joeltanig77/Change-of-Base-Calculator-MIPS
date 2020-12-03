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
	
	
	
	
	A: .asciiz "A"
	B: .asciiz "B"
	C: .asciiz "C"
	D: .asciiz "D"
	E: .asciiz "E"
	F: .asciiz "F"
	
	
	
	
.text


#Do, if its a negative string like (-test) do two numbers 

interfaceUser: 
	addi $s3, $s3, 0 #Assign t1 as 0 as a check for the stringCount 
	addi $s2 $s2,0 #init the count for the digitString
	li $v0, 4 #Call this to start printing a string
	la $a0, enterStringPrompt #Load address into prompt
	syscall
	
	li $v0,8 #Read the String 
         la $a0, buffer #load byte space into address
         li $a1, 300 #allot the byte space for string
         move $s0,$a0 #save string to s0
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
	beq $t0, $t4, twoComplement #If the string has a negative, do two's complement
		
	
	
	j baseCasesForStrings2 #Then we can assume we have a hopefully legal string!
	


#($t0 = this is the char that we are at)
baseCasesForStrings2: #Something is going on here!!!!
	lbu $t0, 0($s0)
	beq $s5, -7777, skip ########################################### Start here Trying to fix this which is trying to skip the negative value at first glance you got this!
	bgt $t0, 71, errorStringValue
	blt $t0, 47, errorStringValue 
	#Need to check NEGATIVE SYMBOL STILL
	
	skip:
		addi $s0, $s0, 1 #Go to the next string char
		addi $s5, $s5, 0 #Reset the s5 so it does now checks to see if the errorStringValue occurs


	j baseCasesForInts #If it reaches this case, then we know it is a legal String 


errorStringValue:
	addi $s7, $0, 0 #Zero return value 

	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, errStringPrompt 	#Load address of prompt
	syscall
	# What I was doing was printing what the users input was might del thiss
	li $v0, 1
	move $a0, $s1
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
	j countDigitString



twoComplement: # TODO ($s5 = global flag for seeing if its a negative)
	add $s5, $0, -7777 #a flag to add a negative
	
	
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


countDigitString:
	lbu $t0, 0($s0)
	beq $t0, $s3, stringToInt #If the string is empty, beq to the formula ($s3 = 0)
	addi $s0, $s0, 1 #Go to the next char 
	beq $s0, 45, countDigitString #If you encounter a negative symbol, skip it
	addi $s2, $s2, 1 #increment the countForDigitStringCount
	j countDigitString
	
	


#(s0 = String/digitString, s1 = int/base) (s2 = countForDigitString) (s3 = 0 for a global check) ($s4 = N)
stringToInt: # TODO
	
	li $v0, 1 #Print the int
	move $a0, $s2 #Return statement for int
	syscall
	
	add $s4, $0, $s2 # Saves $t0 as the length of the digitString (N)
	addi $s0, $0, 0 #digit = 0
	addi $t2, $0, 0 #result = 0
	addi $t3, $0, 1 #positionValue
	
	while:
		blt $s0, $s4, fin #(while digit < N)
		lbu $s6, 0($s0) #Get the char in the string 
		beq $s6, 45, addtheNegative
		beq $s6, $s3, stringToInt #If the string is empty, beq to the formula ($s3 = 0)
		########################## Stopped here
		
		jal convertDigit
	
	addtheNegative:
		

		



#(s0 = String/digitString, s1 = int/base) (s2 = countForDigitString) (s3 = 0 for a global check) ($s4 = N) (s6 = currentDigit)
convertDigit:
	






fin2: #Debug case PLEASE DONT ENTER STOP
		#Ends the Program
	li $v0, 10 #Calls the program to stop with a code of 10
	syscall


fin:
	#Add last print statement
	#Print the prompt
	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, intPrompt 	#Load address of prompt
	syscall
	
	li $v0, 1 #Print the int
	move $a0, $s7 #Return statement for int
	syscall
	
	
	
	
	#Ends the Program
	li $v0, 10 #Calls the program to stop with a code of 10
	syscall
	

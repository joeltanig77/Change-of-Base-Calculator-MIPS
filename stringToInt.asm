#Joel Tanig

.data
	enterStringPrompt: .asciiz "Enter your string: " 
	extraspace: .asciiz " "
	intPrompt: .asciiz "Int value is "
	buffer:   .space 300 #Length that I sent to max is 300 chars
	enterIntPrompt: .asciiz "Enter your int that is between 2-16: "
	emptyStringVar: .space 10 #Reserve 10 spaces for safety
	empSt: .asciiz ""
	debug: .asciiz "Debug Statement"
	
.text

interfaceUser:
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
         
         
        
         
	

#(s0 = String),(s1 = int)
#I need to loop in each char and check if its passes the ascaii tests and if it has
# a null turm, string
baseCasesForStrings:
	
	lbu $t0, ($s0) #Look a char asacii value to t0
	bgt $t0, 49, stringBC2 #We have a string! LETS GOOOOOOOOO 3:15 AM
	beq $t0, $0, emptyStringBC1 #If the string is empty, beq
	
	
	
	j fin2
	
	

emptyStringBC1:
	addi $s7, $0, 0 #Zero return value 
	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, debug 	#Load address of prompt
	syscall
	
	j fin 
	
	
	
	
stringBC2:
	addi $s7, $0, 1 #REMOVE LATER: This checks if we have a string/ascaii val
	
	j fin



baseCasesForInts:
	
	

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
	

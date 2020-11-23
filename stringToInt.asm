#Joel Tanig

.data
	enterStringPrompt: .asciiz "Enter your string: " 
	extraspace: .asciiz " "
	intPrompt: .asciiz "Int value is"
	buffer:   .space 300 #Length that I sent to max is 300 chars
	enterIntPrompt: .asciiz "Enter your int that is between 2-16: "
	emptyStringVar: .space 10 #Reserve 10 spaces for safety
	empSt: .asciiz ""
	
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
         la $t0, empSt #REMOVE LATER, this is how to assign a string to a var
         
         
	

#(s0 = String),(s1 = int)
baseCases:
	la $a0, empSt
	#li $a1, 10 #allot the byte space for string 
	
	beq $s0, $a0, fin 
	

emptyString:





fin:
	#Add last print statement
	#Print the prompt
	li $v0, 4	#Call a service number of 4 to print the string
	la $a0, intPrompt 	#Load address of prompt
	syscall
	
	
	
	
	#Ends the Program
	li $v0, 10 #Calls the program to stop with a code of 10
	syscall
	

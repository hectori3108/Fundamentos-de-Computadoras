.data
cadena: .asciiz "Hola Mundo"
oddChar: .space 100
evenChar: .space 100

.text
la $t0, cadena
la $t1, oddChar
la $t2, evenChar	
li $t3, 0		#Contador de palabras
li $t5, 0		#Numero de caracteres en cadena
CountChars:
	lb $t4, 0($t0)		#Cargar el primer caracter de la cadena
	add $t5, $t5, 1		#Sumar al contador de caracteres
	add $t0, $t0, 1		#Avanzar una posicion en la cadena
	beq $t4, 32, AddWordCount
	beq $t4, $zero, Loop
	j CountChars

Loop:	
	lb $t4, 0($t0)		#Sacar el primer caracter (impar) de la cadena
	sub $t0, $t0, 1
	sb $t4, 0($t1)		#Cargarlo en la cadena de impares
	add $t1, $t1, 1
	beq $t5, $zero, Exit	#Si no quedan mas caracteres acabar
	sub $t5, $t5, 1
	lb $t4, 0($t0)		#Sacar el segundo caracter (par) de la cadena
	sub $t0, $t0, 1
	sb $t4, 0($t2)		#Cargarlo en la cadena de pares
	add $t2, $t2, 1
	beq $t5, $zero, Exit	#Si no quedan mas caracteres acabar
	sub $t5, $t5, 1
	j Loop
	
	
AddWordCount:
	add $t3, $t3, 1		#Sumar uno al contador de letras
	j CountChars
Exit:	
	add $t3, $t3, 1		#sumar uno al contador de palabras, porque para cada espacio hay 2 palabras
	li $v0, 10
	syscall
.data
String:		.space 100
FuncCode:	.space 100
Arg1:		.space 100
Arg2:		.space 100
Output:		.space 100
Hexadecimal:	.space 100
Message1:	.asciiz "\nIntruduzca la instrucción: "
Message2:	.asciiz "\n Salida: "
Igual:		.asciiz "IGUAL"
Mayor:		.asciiz "MAYOR"
Menor:		.asciiz "MENOR"
ErrorMessage:	.asciiz "\n ENTRADA INCORRECTA"

.text

main:
	li	$v0, 4
	la	$a0, Message1
	syscall
	
	la	$a0, String		#Leer entrada de usuario
	li	$a1, 100
	li	$v0, 8
	
	syscall
	
	la	$a0, Output
	la	$a1, FuncCode
	la	$a2, Arg1
	la	$a3, Arg2
	
	jal	getFuncCode	
	
	la	$a0, FuncCode
	la	$a1, Arg1
	la	$a2, Arg2
	
	jal	callInstruction
	
	beqz	$v0, printIntOut
	
printStringOutMain:			#Imprimir una cadena de salida
	li	$v0, 4
	la	$a0, Message2
	syscall
	
	li 	$v0, 4
	la	$a0, Output
	syscall

	j end
	
printIntOut:			#Imprimir un entero de salida


	li	$v0, 4
	la	$a0, Message2
	syscall
	
	move $a0, $v1
	li	$v0, 1
	syscall
	
	j end

end:
	li	$v0, 10
	syscall
	
	
	
	
getFuncCode:			#Obtener el codigo de la funcion
	move 	$t1, $a0	#Copiar la cadena
	move	$t3, $a1
	codeLoop:		#Extraer los 3 primeros caracteres de la cadena
		lb $t2, 0($t1)
		beq $t2, 32, getFuncArgs	#Si se encuentra un espacio acabar el bucle
		sb $t2, 0($t3)
		add $t3, $t3, 1
		add $t1, $t1, 1
		j codeLoop
getFuncArgs:
	move $t0, $a2
	move $t4, $a3
	arg1Loop:			#Sacar el primer argumento de la cadena de entrada
		add $t1, $t1, 1	
		lb $t2, 0($t1)		
		beq $t2, 32, arg2Loop
		beq $t2, $zero, stopArgsLoop
		sb $t2, 0($t0)
		add $t0, $t0, 1
		j arg1Loop
		
	arg2Loop:			#Sacar el segundo argumendo de la cadena de entrada
		add $t1, $t1, 1	
		lb $t2, 0($t1)		
		beq $t2, 32, inputError		#En caso de que haya otra entrada salta un error
		beq $t2, $zero, stopArgsLoop
		beq $t2, 10, stopArgsLoop
		sb $t2, 0($t4)
		add $t4, $t4, 1
		j arg2Loop
	
	stopArgsLoop:			#Acabar el bucle y retornar
		
		jr $ra
	
callInstruction:

		li 	$t1, 0
		li 	$t2, 0		#codigo de operacion (decimal)
		li	$t0, 0		
	addLoop:			#sumar los caracteres para obtener un numero decimal
		lb $t1, 0($a0)
		beq $t1, $zero, compareCode
		add $t2, $t1, $t2
		add $a0, $a0, 1
		j addLoop
		
	compareCode:
		
		beq $t2, 319, funcLen	#Instruccion Len
		beq $t2, 326, funcLwc	#Instruccion Lwc
		beq $t2, 328, funcUpc	#Instruccion Upc
		beq $t2, 312, funcCat	#Instruccion Cat
		beq $t2, 320, funcCmp	#Instruccion Cmp
		beq $t2, 317, funcChr	#Instruccion Chr
		beq $t2, 431, funcRchr	#Instruccion Rchr
		beq $t2, 345, funcStr	#Instruccion Str
		beq $t2, 333, funcRev	#Instruccion Rev
		beq $t2, 327, funcRep	#Instruccion Rep
		j	inputError
		
funcLen:				#Obtener la longitud de la cadena
		lb	$t1, 0($a1)
		beqz	$t1, exitLen
		add	$t0, $t0, 1
		add	$a1, $a1, 1
		j	funcLen
				
	exitLen:
		move	$v0, $zero
		jr	$ra
		
funcLwc:				#Convertir una cadena en todo minusculas
		li 	$t1, 0
	lwcLoop:
		lb 	$t1, 0($a1)
		beqz	$t1, lwcEnd
		add 	$a1, $a1, 1
		bgt	$t1, 90, lwcSkipAdd
		blt	$t1, 65, lwcSkipAdd
		add	$t1, $t1, 32
	lwcSkipAdd:
		sb	$t1, 0($a0)
		add	$a0, $a0, 1
		j lwcLoop
	lwcEnd:
		li	$v0, 1
		jr	$ra
		
funcUpc:				#Convertir una cadena en todo mayusculas
	li 	$t1, 0
	upcLoop:
		lb 	$t1, 0($a1)
		beqz	$t1, upcEnd
		add 	$a1, $a1, 1
		bgt	$t1, 122, upcSkipAdd
		blt	$t1, 97, upcSkipAdd
		add	$t1, $t1, -32
	upcSkipAdd:
		sb	$t1, 0($a0)
		add	$a0, $a0, 1
		j upcLoop
	upcEnd:
		li	$v0, 1
		jr	$ra

funcCat:				#Concatenar 2 cadenas
		li 	$t1, 0
	catArg1Loop:
		lb $t1, 0($a1)
		beqz $t1, catArg2Loop
		sb $t1, 0($a0)
		add $a0, $a0, 1
		add $a1, $a1, 1
		j catArg1Loop
	catArg2Loop:
		lb $t1, 0($a2)
		beqz $t1, catEnd
		sb $t1, 0($a0)
		add $a0, $a0, 1
		add $a2, $a2, 1
		j catArg2Loop
	catEnd:
		li	$v0, 1
		jr	$ra	
	
funcCmp:				#Comparar 2 cadenas
	li $t1, 0
	cmpLoop:
		lb $t1, 0($a1)
		lb $t2, 0($a2)
		beqz $t1, cmpEndString
		beqz $t2, cmpEndString
		bgt $t1, $t2, cmpMayor
		blt $t1, $t2, cmpMenor
		add $a1, $a1, 1
		add $a2, $a2, 1
		j cmpLoop
		
	cmpEndString:
		beq $t1, $t2, cmpIgual
		bgt $t1, $t2, cmpMayor
		blt $t1, $t2, cmpMenor
	cmpMayor:
		la $t3, Mayor
		j cmpEnd
	cmpMenor:
		la $t3, Menor
		j cmpEnd
	cmpIgual:
		la $t3, Igual
		j cmpEnd
	cmpEnd:
		lb $t1, 0($t3)
		beqz $t1, cmpEnd2
		sb $t1, 0($a0)
		add $t3, $t3, 1
		add $a0, $a0, 1
		j cmpEnd
	cmpEnd2:
		li	$v0, 1
		jr	$ra
			

funcChr:
		lb	$t0, 0($a1)
		li	$t1, 1
	ChrLoop:
		lb	$t3, 0($a2)
		beqz	$t3, notFound
		beq	$t3, $t0, found
		addi	$a2, $a2, 1
		addi	$t1, $t1, 1
		j	ChrLoop
	notFound:
		move	$v0, $zero
		li	$v1, 0
		jr	$ra
	found:
		move	$v0, $zero
		move	$v1, $t1
		jr	$ra
		
funcRchr:
		lb	$t0, 0($a1)
		li	$t1, 1
	toEnd:
		lb	$t2, 1($a2)
		beqz 	$t2, rchrLoop
		addi	$a2, $a2, 1
		j	toEnd
	rchrLoop:
		lb	$t3, 0($a2)
		beqz	$t3, notFound
		beq	$t3, $t0, found
		subi	$a2, $a2, 1
		addi	$t1, $t1, 1
		j	rchrLoop
		
funcStr:
		li	$t5, 1
		move	$v0, $zero
inicStr:		
		move	$t1, $a1
		lb	$t3, 0($t1)
	loopStr:
		move	$t0, $t5
		lb	$t4, 0($a2)
		beqz	$t4, notFoundStr
		beq	$t3, $t4, sameStr
		addi	$a2, $a2, 1
		addi	$t5, $t5, 1
		j	loopStr
		
	sameStr:
		addi	$t1, $t1, 1
		addi	$a2, $a2, 1
		addi	$t5, $t5, 1
		lb	$t3, 0($t1)
		lb	$t4, 0($a2)
		beqz	$t3, foundStr
		beq	$t3, $t4, sameStr
		j	inicStr
		
	notFoundStr:
		li	$v1, 0
		jr	$ra
	foundStr:
		move	$v1, $t0
		jr	$ra
		
	
funcRev:
		move	$t0, $a1
	firstLoopRev:
		lb	$t1, 0($t0)
		beqz	$t1, endFirstLoop
			
funcRep:
jr $ra
	
inputError:			#Imprimir error de entrada
	la $a0, ErrorMessage	
	li $v0, 4
	syscall
	
	jr $ra
	
	
	 
	 
	

.data
Cadena1:	.asciiz	"Hola mundo"
Cadena2:	.asciiz "How are you?"
mensajecad:	.asciiz "Cadenas concatenadas e invertidas:\n"
mensajecar:	.asciiz "\n\nN�mero de caracteres de la cadena completa:\n"
Cadenpar:	.space	50
Cadenimpar:	.space	50
.text
main:
	la	$a0, Cadena1		# Inicializamos los par�metro de la funci�n
	la	$a1, Cadena2
	
	jal	funcion			# Llamada a la funci�n
	
	li	$v0, 4			# Impresi�n de mensaje
	la	$a0, mensajecad
	syscall
	
	li	$v0, 4			# Impresi�n de la cadena
	la	$a0, Cadena1
	syscall
	
	li	$v0, 4			# Impresi�n de mensaje
	la	$a0, mensajecar
	syscall
	
	li	$v0, 1			# Impresi�n del n�mero de caracteres
	move	$a0, $v1
	syscall
	
	li	$v0, 10			# Fin de programa
	syscall
	
funcion:
	li	$t0, 0			# Contador de longitud
	la	$t3, 0($a0)		# Desplazamiento
	
bucle:					# Bucle para contar los car�cteres de la primera cadena y ponerme al final
	lb	$t1, 0($t3)		# Donde guardaremos el caracter
	beq	$t1, $zero, concateno
	addi	$t0, $t0, 1
	addi	$t3, $t3, 1
	j	bucle

concateno:				# Bucle para concatenar cadenas
	lb	$t2, 0($a1)
	beq	$t2, $zero, invierto
	sb	$t2, 0($t3)
	addi	$t0, $t0, 1
	addi	$t3, $t3, 1
	addi	$a1, $a1, 1
	j	concateno

#Funci�n para invertir cadenas y soltar el n�mero de caracteres

invierto:				
	sb	$zero, 0($t3)
	li	$t4, 0			# Contador
	la	$t2, 0($a0)
mitad:					# Cuenta los caracteres de la cadena luego lo divide entre dos para saber hasta donde tiene que llegar invirtiendo
	lb	$t1, 0($a0)
	beq	$t1, $zero, inv
	addi	$t4, $t4, 1
	addi	$a0, $a0, 1
	j	mitad
inv:
	div	$t4, $t4, 2
	subi	$a0, $a0, 1
bucleinv:				# Bucle que invierte la cadena y la deposita en la misma direcci�n
	lb	$t1, 0($t2)
	lb	$t3, 0($a0)
	sb	$t1, 0($a0)
	sb	$t3, 0($t2)
	subi	$t4, $t4, 1
	beq	$t4, $zero, fin
	subi	$a0, $a0, 1
	addi	$t2, $t2, 1
	j	bucleinv

fin:
	move	$v1, $t0		# Guardamos el n�mero de caracteres� en el registro de retorno 
	jr	$ra			#Devulvemos el flujo al main
	
	
	

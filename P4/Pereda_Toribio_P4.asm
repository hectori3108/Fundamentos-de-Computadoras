.data
Mensaje1:	.asciiz	"Escriba un número en decimal: \n"
Mensaje2:	.asciiz	"\nSu número en hexadecimal: \n"
numero:		.space 1000
cadfin:		.space 1000

.text
main:
	li	$v0, 4			# mensaje 1
	la	$a0, Mensaje1
	syscall
	
	li	$v0, 5			# lectura de decimal
	syscall
	
	move	$a0, $v0		# inicializamos paramentros
	la	$a1, cadfin
	
	jal	funcion			# llamamos a la funcion
	
	li	$v0, 4			# mensaje 2
	la	$a0, Mensaje2
	syscall
	
	li	$v0, 4			# imprimimos hexadecimal
	move	$a0, $v1
	syscall
	
	li	$v0, 10			# fin del programa
	syscall
	
funcion:
	li	$t0, 0			# almacen de número
	li	$t1, 8			# contador
bucle: 
	beqz 	$t1, exit 		# si se ha terminado 
	andi 	$t0, $a0, 0xf0000000 	# mascara para coger los 4 bits de la izquierda
	srl	$t0, $t0, 28
	sll 	$a0, $a0, 4 		# siguientes 4 bits
	blt 	$t0, 10, suma 		# si es menor que 
	addi 	$t0, $t0, 55 		# si es mayor que 9 se le suma 55 ya que 55 es "A"-10 en ascii y empezamos desde el 10 hasta el 15
	j 	actualizo 
suma: 
	addi 	$t0, $t0, 48 		# sumamos 48 ya que 48 en ascii es "0" 
actualizo: 
	sb 	$t0, 0($a1) 		# guardamos el resultado
	addi 	$a1, $a1, 1 		# avanzamos en el vector de resultado
	addi 	$t1, $t1, -1 		# restamos 1 al contaor
	j	bucle
exit:
	la	$v1, cadfin		# guardamos resultado en registro de salida
	jr	$ra			# devolvemos el flujo

	

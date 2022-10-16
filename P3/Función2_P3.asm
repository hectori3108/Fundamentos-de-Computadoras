.data
Cadena1:	.asciiz	"Hola mundo"
Cadena2:	.asciiz "How are you?"
Cadenpar:	.space	50
Cadenimpar:	.space	50
.text
main:
	la	$a0, Cadena1
	la	$a1, Cadena2
	
	jal	funcion
	
	move	$s1, $v0
	
	li	$v0, 4
	move	$a0, $v1
	syscall
	
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	li	$v0, 10
	syscall
	
funcion:
	li	$t0, 0		#Contador de longitud
	la	$t3, 0($a0)		# Desplazamiento
	la	$t6, 0($a0)
	li	$t4, 0
	li	$t5, 0
bucle:
	lb	$t1, 0($t3)	#Donde guardaremos el caracter
	beq	$t1, $zero, concateno
	addi	$t0, $t0, 1
	addi	$t3, $t3, 1
	j	bucle

concateno:
	lb	$t2, 0($a1)
	beq	$t2, $zero, fin
	sb	$t2, 0($t3)
	addi	$t0, $t0, 1
	addi	$t3, $t3, 1
	addi	$a1, $a1, 1
	j	concateno

fin:
	sb	$zero, 0($t3)
	move	$v0, $t0
	move	$v1, $a0
	jr	$ra
	
	
	

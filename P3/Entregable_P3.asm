.data
Cadena1:	.asciiz	"Hola mundo"
Cadena2:	.asciiz "How ar"
Cadenpar:	.space	50
Cadenimpar:	.space	50
.text
main:
	la	$a0, Cadena1
	la	$a1, Cadena2
	
	jal	funcion
	
	li	$v0, 4
	la	$a0, Cadena1
	syscall
	
	li	$v0, 1
	move	$a0, $v1
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
	beq	$t2, $zero, invierto
	sb	$t2, 0($t3)
	addi	$t0, $t0, 1
	addi	$t3, $t3, 1
	addi	$a1, $a1, 1
	j	concateno

invierto:
	sb	$zero, 0($t3)
	li	$t7, 0			# Contador
	la	$t2, 0($a0)
mitad:
	lb	$t1, 0($a0)
	beq	$t1, $zero, inv
	addi	$t7, $t7, 1
	addi	$a0, $a0, 1
	j	mitad
inv:
	div	$t7, $t7, 2
	subi	$a0, $a0, 1
bucleinv:
	lb	$t1, 0($t2)
	lb	$t3, 0($a0)
	sb	$t1, 0($a0)
	sb	$t3, 0($t2)
	subi	$t7, $t7, 1
	beq	$t7, $zero, fin
	subi	$a0, $a0, 1
	addi	$t2, $t2, 1
	j	bucleinv

fin:
	move	$v1, $t0
	jr	$ra
	
	
	

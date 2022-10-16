.data
cadleida: .asciiz "que l"
.text
main: 

	la	$a0, cadleida
	jal	invierto
	
	li	$v0, 4
	la	$a0, cadleida
	syscall
	
	li	$v0, 10
	syscall
	
invierto:
	li	$t0, 0			# Contador
	la	$t2, 0($a0)
mitad:
	lb	$t1, 0($a0)
	beq	$t1, $zero, inv
	addi	$t0, $t0, 1
	addi	$a0, $a0, 1
	j	mitad
inv:
	div	$t0, $t0, 2
	subi	$a0, $a0, 1
bucle:
	lb	$t1, 0($t2)
	lb	$t3, 0($a0)
	sb	$t1, 0($a0)
	sb	$t3, 0($t2)
	subi	$t0, $t0, 1
	beq	$t0, $zero, fin
	subi	$a0, $a0, 1
	addi	$t2, $t2, 1
	j	bucle

fin:
	jr	$ra
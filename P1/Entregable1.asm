.data
Vector: .space 3200
.text

main:
	la	$s1, Vector
	li	$t0, -5
	sw	$t0, ($s1)
	addi	$t0, $t0, 15
	sw	$t0, 4($s1)
	addi	$t0, $t0, -60
	sw	$t0, 8($s1)
	move 	$a1, $s1
	move	$a2, $s1
	jal	func

func:
	li	$t3, 4
	li	$t1, 3
	l
algoritmo:
	move	$a2, $a1
	subi	$t1, $t1, 1
	mult	$t2, $t1, $t3
	add	$a2, $a2, $t2
	
	
	
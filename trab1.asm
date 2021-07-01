#####################################################
# Arthur Musskopf da Luz & Daniela Pereira Rigoli   #
#####################################################
.data
A: .word -5 -1 5 9 12 15 21 29 31 58 250 325
tam: .word 12
pegaPrim: .asciiz "Digite o valor prim: "
pegaUlt: .asciiz "Digite o valor ult: "
pegaValor: .asciiz "Digite o valor a ser procurado: "
resultado: .asciiz "Indice = "
nao_encontrado: .asciiz "valor não encontrado."

.text
.globl main
main:
     la $s0, A
     la $s1, tam
     lw $s1, 0($s1)
     
      # imprime pegaPrim
      li $v0, 4
      la $a0, pegaPrim
      syscall
      
      # pega prim numero
      li $v0, 5
      syscall
      addu $t0, $v0, $zero

      # imprime pegaUlt
      li $v0, 4
      la $a0, pegaUlt
      syscall
      
      # pega ult numero
      li $v0, 5
      syscall
      addu $t1, $v0, $zero

      # imprime valor
      li $v0, 4
      la $a0, pegaValor
      syscall
      
      # pega valor
      li $v0, 5
      syscall
      addu $t2, $v0, $zero
      
      addiu $v0, $zero, -1

     ###############################
     #addiu $t0, $0, 0    # prim   #
     #addiu $t1, $0, 11   # ult    #
     #addiu $t2, $0, 325  # valor  #
     ###############################

     
     
     addiu $sp, $sp, -4  # abre espaço na pilha
     sw $s0, 0($sp)      # coloca o endereço de A na pilha
     
     addiu $sp, $sp, -4  # abre espaço na pilha
     sw $t0, 0($sp)      # coloca prim na pilha
     
     addiu $sp, $sp, -4  # abre espaço na pilha
     sw $t1, 0($sp)      # coloca ult na pilha
     
     addiu $sp, $sp, -4  # abre espaço na pilha
     sw $t2, 0($sp)      # coloca valor na pilha
     
     jal binSearch
     sw $zero, 0($sp)
     addiu $sp, $sp, 4   # diminui a pilha
     move $s7, $v0

     bgt $zero, $s7, nao_achou

     #imprime "resultado = "
	 li $v0, 4
	 la $a0, resultado
	 syscall
	
	 #imprime o numero
	 li $v0, 1
	 move $a0, $s7
	 syscall
	 j encerra

nao_achou:
     #imprime "nao encontrado "
	 li $v0, 4
	 la $a0, nao_encontrado
	 syscall
	 
encerra:	
	 #terminar
     li $v0, 10
	 syscall
     
binSearch:
     lw $t2, 0($sp)      # pega valor
     sw $zero, 0($sp)
     addiu $sp, $sp, 4   # diminui a pilha
     
     lw $t1, 0($sp)      # pega ult
     sw $zero, 0($sp)
     addiu $sp, $sp, 4   # diminui a pilha
     
     lw $t0, 0($sp)      # pega prim
     sw $zero, 0($sp)
     addiu $sp, $sp, 4   # diminui a pilha
     
     lw $s0, 0($sp)      # pega endereço de A
     sw $zero, 0($sp)
     addiu $sp, $sp, 4   # diminui a pilha
     
     #se ult - prim for menor que 0, então Prim > Ult
     sub $t3, $t1, $t0
     bltz $t3, return
     
     addu $s1, $t0, $t1  # meio = prim+ult
     srl $s1, $s1, 1     # meio = meio/2 (usando shift right logical)
     mul $s2, $s1, 4     # indice * 4 = numero de bits(bytes???) pra andar <----
     addu $s2, $s0, $s2  # endereço de A + numero de  <---
     lw $s2, 0($s2)      # pega o valor que estiver em A[meio]
     
     bne $t2, $s2, else  # Valor == A[meio] entra no 'if'
         move $v0, $s1
         j return
         
else:
     #se Valor < A[meio]
     sub $t3, $t2, $s2
     bgtz $t3, else2
         #empilhar e ir de volta pra lá
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $ra, 0($sp)      # coloca $ra na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $s0, 0($sp)      # coloca endereço de A na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $t0, 0($sp)      # coloca prim na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         addiu $t1, $s1, -1  # ult = meio-1
         sw $t1, 0($sp)      # coloca ult na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $t2, 0($sp)      # coloca valor na pilha
         
         jal binSearch      
         lw $ra, 0($sp)      # nao tenho certeza, mas é pra $ra ser o topo da pilha
         addiu $sp, $sp, 4   # diminui a pilha
         
         j return
         
else2:
         #empilhar e ir de volta pra lá
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $ra, 0($sp)      # coloca $ra na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $s0, 0($sp)      # coloca endereço de A na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         addiu $t0, $s1, +1  # prim = meio+1
         sw $t0, 0($sp)      # coloca prim na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $t1, 0($sp)      # coloca ult na pilha
         
         addiu $sp, $sp, -4  # abre espaço na pilha
         sw $t2, 0($sp)      # coloca valor na pilha
         
         jal binSearch
         lw $ra, 0($sp)
         sw $zero, 0($sp)
         addiu $sp, $sp, 4   # diminui a pilha
         
return: jr $ra
;projeto calculadora
TITLE CALC
.MODEL	SMALL
.DATA
	PL EQU 0AH,0DH ;PULAR LINHA
	MSGINTRO	DB	'			CALCULADORA <OCLM>$'
	OPCAO	DB PL,'	  <Opcoes de Bases>$'                                                                                                                 
	DECIMAL DB PL,'	  1 -> Decimal$'                                                                                                         
	BINARIO DB PL,'	  2 -> Binario$'                                                                                                         
	HEXA 	DB PL,'	  3 -> Hexadecimal$'                                                                                                         
	OPCAO2 	DB PL,'		<Escolha uma operacao>$'
	ANDD	DB	PL,'	0. AND$'
	ORR		DB	PL,'	1. OR$'
	XORR	DB	PL,'	2. XOR$'
	NOTT	DB	PL,'	3. NOT$'
	SOMA	DB	PL,'	4. Soma$'
	SUBT	DB	PL,'	5. Subtracao$'
	MULTI	DB	PL,'	6. Multiplicacao$'
	DIVI	DB	PL,'	7. Divisao$'
	MULTI2	DB	PL,'	8. Multiplicacao (varias vezes, escolhido pelo usuario) por 2$'
	DIVI2	DB	PL,'	9. Divisao por 2 (varias vezes, escolhido pelo usuario)$'
	DECISAO DB PL,'	Opcao: $'
	EntradaDecimal DB PL,'	Entrada em DECIMAL $'                                
	EntradaHexa	   DB PL,'	Entrada em HEXADECIMAL $'
	EntradaBinario DB PL,'	Entrada em BINARIO $'
	Desejavoltar	DB PL,'	Deseja voltar ?(S/N): $'
	VAZIO	DB PL, '$'
	
;--------------------------------------------------------------------------------------;
;VARIAVEIS USADAS NO CODIGO
	N1 	DW 0
	N2 	DW 0
	AUX DW 0
	OP 	DB 0
	OP2 DB 0
	CR	DB 0 
;--------------------------------------------------------------------------------------;	
.CODE

MAIN PROC

	MOV AX, @DATA
	MOV DS, AX
	
INICIO:
	LEA DX, MSGINTRO
	MOV AH, 9
	INT 21H
;--------------------------------------------------------------------------------------;
;MENU PRINCIPAL  - BASES
	CALL MENU1				;print da escolha da base	
	                            
	LEA DX, DECISAO             
	MOV AH, 9                   
	INT 21H                     
	                            
	MOV AH, 1                   
	INT 21H                     
	MOV BL, AL                  
	                            
	MOV OP, BL                  
;--------------------------------------------------------------------------------------;
;MENU SECUNDARIO
	CALL MENU2				;print da escolha da operação
	
	LEA DX, DECISAO
	MOV AH, 9
	INT 21H
	
	MOV AH, 1
	INT 21H
	MOV CL, AL
	
	MOV OP2, CL
;--------------------------------------------------------------------------------------;
;TRATANDO AS OPCOES DO MENU PRINCIPAL (BASE)
	
	CMP OP, '1'		;decimal
	JE D1
	
	CMP OP, '2'		;binario
	JE D2
	
	CMP OP, '3'		;hexadecimal
	JE D3
	
	JMP SAIR
	
;--------------------------------------------------------------------------------------;
;PROCEDIMENTO DE ENTRADA - NUMEROS DECIMAIS
D1:
	CALL ENTDECIMAL
	MOV N2, AX
	
	CMP OP2, '3'
	JE COMPARA
	CALL ENTDECIMAL
	MOV BX, AX
	
	JMP COMPARA
;--------------------------------------------------------------------------------------;
;PROCEDIMENTO DE ENTRADA - NUMEROS BINARIOS
D2:
	CALL ENTBINARIO
	MOV N2, AX
	
	CMP OP2, '3'
	JE COMPARA
	CALL ENTBINARIO
	
	JMP COMPARA	
;--------------------------------------------------------------------------------------;
;PROCEDIMENTO DE ENTRADA - NUMEROS HEXADECIMAL
D3:
	CALL ENTHEXADECIMAL
	MOV N2, AX
	
	CMP OP2, '3'
	JE COMPARA
	CALL ENTHEXADECIMAL
	
	JMP COMPARA
;--------------------------------------------------------------------------------------;	
;ENTRADA PADRONIZADA EM BX
COMPARA:
	ANDM:
		CMP OP2, '0'
		JE ANDMJ
		JMP ORM
		ANDMJ:
			CALL OP_AND
			
	ORM:
		CMP OP2, '1'
		JE ORMJ
		JMP XORM
		ORMJ:
			CALL OP_OR
	
	XORM:
		CMP OP2, '2'
		JE XORMJ
		JMP NOTM
		XORMJ:
			CALL OP_XOR
		
	NOTM:
		CMP OP2, '3'
		JE NOTMJ
		JMP SOMAM
		NOTMJ:
			CALL OP_NOT
			
	SOMAM:
		CMP OP2, '4'
		JE SOMAMJ
		JMP SUBTRACAOM
		SOMAMJ:
			CALL OP_SOMA
	
	SUBTRACAOM:
		CMP OP2, '5'
		JE SUBTRACAOMJ
		JMP MULTIPLICACAOM
		SUBTRACAOMJ:
			CALL OP_SUBTRACAO
	
	MULTIPLICACAOM:
		CMP OP2, '6'
		JE MULTIPLICACAOMJ
		JMP DIVISAOM
		MULTIPLICACAOMJ:
			CALL OP_MULTIPLICACAO
	
	DIVISAOM:
		CMP OP2, '7'
		JE DIVISAOMJ
		JMP MULT2
		DIVISAOMJ:
			CALL OP_DIVISAO
	
	MULT2:
		CMP OP2, '8'
		JE MULT2J
		JMP DIV2
		MULT2J:
			CALL OP_MULT2
	
	DIV2:
		CMP OP2, '9'
		JE DIV2J
		JMP ANDM
		DIV2J:
			CALL OP_DIV2
;--------------------------------------------------------------------------------------;
SAIR:
	LEA DX, Desejavoltar
	MOV AH, 9
	INT 21H
	
	MOV AH, 1
	INT 21H
	
	MOV CR, AL
	
	CMP CR, 'S'
	JE AUXINICIO
	CMP CR, 's'
	JE AUXINICIO
	JMP F

AUXINICIO:
	JMP INICIO
	
F:
	MOV AH, 4CH
	INT 21H
	
MAIN ENDP
;--------------------------------------------------------------------------------------;
;ENTRADA DECIMAL
ENTDECIMAL PROC
	MOV AH, 9H
	LEA DX, EntradaDecimal
	INT 21H
	
	MOV AH, 9H
	LEA DX, VAZIO
	INT 21H
	
	PUSH BX
	PUSH CX
	PUSH DX
	
	XOR BX, BX
	
	XOR CX, CX
	MOV AH, 1H
	INT 21H
	
	CMP AL, '-'
	JE MENOS
	
	CMP AL, '+'
	JE MAIS
	
	JMP NUM
	
MENOS:
	MOV CX, 1

MAIS:
	INT 21H
	
NUM:
	AND AX, 000FH
	PUSH AX
	MOV AX, 10
	
	MUL BX
	POP BX
	ADD BX, AX
	
	MOV AH, 1H
	INT 21H
	
	CMP AL, 0DH
	JNE NUM
	
	MOV AX, BX
	CMP CX, 1
	JNE SAIDA
	
	NEG AX

SAIDA:
	POP DX
	POP CX
	POP BX
	
	RET
ENTDECIMAL ENDP

SAIDECIMAL PROC
;exibe o conteudo de CX como decimal inteiro com sinal
;variaveis de entrada: AX -> valor binario equivalente do número decimal
;variaveis de saida: nehuma (exibição de dígitos direto no monitor de video)

		MOV AH,9H
		LEA DX,VAZIO
		INT 21H
		
		MOV AX,BX
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX 		;salva na pilha os registradores usados
		
		OR 	AX,AX 	;prepara comparação de sinal
		
		JGE PT1 	;if AX >= 0, vai para PT1
		
		PUSH AX 		;como AX < 0, salva o número na pilha
		MOV DL,'-'	;prepara o caracter ' - ' para sair
		MOV AH,2h 	;prepara exibição
		INT 21h 	;exibe ' - '
		
		POP AX 		;recupera o número
		NEG AX 		;troca o sinal de AX (AX = - AX)
		
		;obtendo dígitos decimais e salvando-os temporariamente na pilha
PT1: 	XOR CX,CX 	;inicializa CX como contador de dígitos
		MOV BX,10 	;BX possui o divisor
PT2: 	XOR DX,DX 	;inicializa o byte alto do dividendo em 0; restante é AX
		
		DIV BX 		;após a execução, AX = quociente; DX = resto
		PUSH DX 		;salva o primeiro dígito decimal na pilha (1o. resto)
		
		INC CX 		;contador = contador + 1
		OR 	AX,AX 	;quociente = 0 ? (teste de parada)
		JNE PT2 	;não, continuamos a repetir o laço
		
		;exibindo os dígitos decimais (restos) no monitor, na ordem inversa
		MOV AH,2h 	;sim, termina o processo, prepara exibição dos restos
PT3: 	POP DX 		;recupera dígito da pilha colocando-o em DL (DH = 0)
		ADD DL,30h 	;converte valor binário do dígito para caracter ASCII
		
		INT 21h 	;exibe caracter
		LOOP PT3 	;realiza o loop ate que CX = 0
		
		POP DX 		;restaura o conteúdo dos registros
		POP CX
		POP BX
		POP AX 		;restaura os conteúdos dos registradores
		RET 			;retorna à rotina que chamou
SAIDECIMAL ENDP
;--------------------------------------------------------------------------------------;
;ENTRADA BINARIO
ENTBINARIO PROC
	MOV AH, 9H
	LEA DX, EntradaBinario
	INT 21H
	
	MOV AH,9H
	LEA DX,VAZIO
	INT 21H
	
	PUSH BX
	PUSH CX
	PUSH DX
	
	XOR BX, BX
	
	MOV CX,16 ;inicializa contador de dígitos
	MOV AH,1h ;função DOS para entrada pelo teclado
	XOR BX,BX ;zera BX -> terá o resultado
	INT 21h ;entra, caracter está no AL
;while
TOPO: 
	CMP AL,0Dh ;é CR?
	JE SAIDABINARIO ;se sim, termina o WHILE
	AND AL,0Fh ;se não, elimina 30h do caracter
;(poderia ser SUB AL,30h)
	SHL BX,1 ;abre espaço para o novo dígito
	OR BL,AL ;insere o dígito no LSB de BL
	INT 21h ;entra novo caracter
	LOOP TOPO ;controla o máximo de 16 dígitos
	
SAIDABINARIO:
	POP BX
	SUB CX, 16
	MOV DX, CX
	RET
ENTBINARIO ENDP

SAIBINARIO PROC
	MOV CX,DX ;inicializa contador de bits
	MOV AH,02h ;prepara para exibir no monitor
;for 16 vezes do
PT1B:
	ROL BX,1 ;desloca BX 1 casa à esquerda
;if CF = 1
	JNC PT2B ;salta se CF = 0
;then
	MOV DL, 31h ;como CF = 1
	INT 21h ;exibe na tela "1" = 31h
;else
PT2B: 
	MOV DL, 30h ;como CF = 0
	INT 21h ;exibe na tela "0" = 30h
;end_if
	LOOP PT1B ;repete 16 vezes
;end_for
	POP DX 		;restaura o conteúdo dos registros
	POP CX
	POP BX
	RET 
SAIBINARIO ENDP
;--------------------------------------------------------------------------------------;
;ENTRADA HEXADECIMAL
ENTHEXADECIMAL PROC
	MOV AH, 9H
	LEA DX, EntradaHexa
	INT 21H
	
	MOV AH,9H
	LEA DX,VAZIO
	INT 21H
	
	PUSH BX
	PUSH CX
	PUSH DX
	
ENTHEXADECIMAL ENDP
SAIHEXA PROC


SAIHEXA ENDP
;--------------------------------------------------------------------------------------;
OP_SOMA PROC
	ADD BX,N2
	CALL SAIDAFINAL
	JMP SAIR
OP_SOMA ENDP

OP_SUBTRACAO PROC
	SUB N2,BX
	MOV BX,N2			
	CALL SAIDAFINAL
	JMP SAIR
OP_SUBTRACAO ENDP

OP_MULTIPLICACAO PROC
	MOV AX,N2
	IMUL BX
	MOV BX,AX
	CALL SAIDAFINAL
	JMP SAIR
OP_MULTIPLICACAO ENDP

OP_DIVISAO PROC
	MOV AX,N2
	CWD
	IDIV BX
	MOV BX,AX
	CALL SAIDAFINAL
	JMP SAIR
OP_DIVISAO ENDP

OP_MULT2 PROC
	MOV AX,N2
	COMECA:
		CMP BX,0
		JE CHAMA
		SHL AX,1
		DEC BX
		JMP COMECA
	CHAMA:
		MOV BX,AX
		CALL SAIDAFINAL
		JMP SAIR
OP_MULT2 ENDP


OP_DIV2 PROC
	MOV AX,N2
	COMECAD:
		CMP BX,0
		JE CHAMAD
		SHR AX,1
		DEC BX
		JMP COMECAD
	CHAMAD:
		MOV BX,AX
		CALL SAIDAFINAL
		JMP SAIR
OP_DIV2 ENDP

OP_AND PROC
	AND BX,N2
	CALL SAIDAFINAL
	JMP SAIR
OP_AND ENDP

OP_OR PROC
	OR BX,N2
	CALL SAIDAFINAL
	JMP SAIR
OP_OR ENDP

OP_XOR PROC
	XOR BX,N2
	CALL SAIDAFINAL
	JMP SAIR
OP_XOR ENDP

OP_NOT PROC
	NOT BX
	CALL SAIDAFINAL
	JMP SAIR
OP_NOT ENDP

SAIDAFINAL PROC
	CMP OP,'1'
	JE SD
	JMP B
	SD:
		CALL SAIDECIMAL 
		JMP FIM
	B:
		CMP OP,'2'
		JE SB
		JMP H
	SB:
		CALL SAIBINARIO
		JMP FIM
	H:
		CMP OP,'3'
		JE SH
		JMP FIM
	SH:
		CALL SAIHEXA
		JMP FIM
	FIM:
		RET
SAIDAFINAL ENDP

MENU1 PROC
	LEA DX, OPCAO
	MOV AH, 9
	INT 21H
	
	LEA DX, DECIMAL
	INT 21H
	
	LEA DX, BINARIO
	INT 21H
	
	LEA DX, HEXA
	INT 21H
	
	RET
MENU1 ENDP

MENU2 PROC
	LEA DX, OPCAO2
	MOV AH, 9
	INT 21H

	LEA DX, ANDD
	INT 21H
	
	LEA DX, ORR
	INT 21H
	
	LEA DX, XORR
	INT 21H
	
	LEA DX, NOTT
	INT 21H
	
	LEA DX, SOMA
	INT 21H
	
	LEA DX, SUBT
	INT 21H
	
	LEA DX, MULTI
	INT 21H
	
	LEA DX, DIVI
	INT 21H
	
	LEA DX, MULTI2
	INT 21H
	
	LEA DX, DIVI2
	INT 21H
	
	RET
MENU2 ENDP

END
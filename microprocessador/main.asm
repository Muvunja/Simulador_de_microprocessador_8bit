; --------------------------------------------------
; Simulador de Microprocessador 8-bit em Assembly
; Instruções básicas: LOAD, STORE, ADD, SUB, JMP, NOP
; --------------------------------------------------

; Definição dos opcodes para cada instrução
.equ LOAD = 0x01      ; Carrega valor da memória para um registrador
.equ STORE = 0x02     ; Armazena valor de um registrador na memória
.equ ADD_OPERATION = 0x03       ; Soma valores de dois registradores
.equ SUB_OPERATION = 0x04       ; Subtrai o valor de um registrador de outro
.equ JMP_OPERATION = 0x05       ; Salta para um endereço específico
.equ NOP_OPERATION = 0x00       ; Nenhuma operação

; Definição dos registradores
.def R_TEMP = R16     ; Registrador temporário para operações
.def R0_TEMP = R17         ; Registrador simulado R0
.def R1_TEMP = R18         ; Registrador simulado R1
.def R2_TEMP = R19         ; Registrador simulado R2
.def R3_TEMP = R20         ; Registrador simulado R3
.def R4_TEMP = R21         ; Registrador simulado R4
.def R5_TEMP = R22         ; Registrador simulado R5
.def R6_TEMP = R23         ; Registrador simulado R6
.def R7_TEMP = R24         ; Registrador simulado R7

; Ponteiro de Programa (PC) usando registrador Z
.org 0x0000
main:
    ldi ZL, low(0x0100)     ; Define Z para apontar para o início da memória de instruções
    ldi ZH, high(0x0100)

; Ciclo de execução de instruções
fetch_decode_execute:
    ld R16, Z+              ; Busca a instrução atual (incrementa o Z após leitura)
    cpi R16, LOAD
    breq LOAD_FUNC          ; Vai para LOAD se R16 == LOAD
    cpi R16, STORE
    breq STORE_FUNC         ; Vai para STORE se R16 == STORE
    cpi R16, ADD_OPERATION
    breq ADD_FUNC           ; Vai para ADD se R16 == ADD
    cpi R16, SUB_OPERATION
    breq SUB_FUNC           ; Vai para SUB se R16 == SUB
    cpi R16, JMP_OPERATION
    breq JMP_FUNC           ; Vai para JMP se R16 == JMP
    cpi R16, NOP_OPERATION
    breq NOP_FUNC           ; Vai para NOP se R16 == NOP

    rjmp fetch_decode_execute ; Loop de ciclo de execução

; Funções de Instrução
LOAD_FUNC:
    ld R20, Z+              ; Carrega o registrador de destino (ex.: R0 a R7)
    ld R21, Z+              ; Carrega o endereço de memória
    mov ZL, R21             ; Endereço da memória em Z
    ld R_TEMP, Z            ; Carrega valor da memória para R_TEMP
    mov R20, R_TEMP         ; Copia valor para o registrador destino
    rjmp fetch_decode_execute

STORE_FUNC:
    ld R20, Z+              ; Carrega o registrador fonte
    ld R21, Z+              ; Carrega o endereço de memória
    mov ZL, R21             ; Define o endereço de memória
    mov R_TEMP, R20         ; Copia valor do registrador fonte
    st Z, R_TEMP            ; Armazena o valor na memória
    rjmp fetch_decode_execute

ADD_FUNC:
    ld R20, Z+              ; Carrega o registrador de destino
    ld R21, Z+              ; Carrega o registrador fonte
    add R20, R21            ; Soma os valores
    rjmp fetch_decode_execute

SUB_FUNC:
    ld R20, Z+              ; Carrega o registrador de destino
    ld R21, Z+              ; Carrega o registrador fonte
    sub R20, R21            ; Subtrai os valores
    rjmp fetch_decode_execute

JMP_FUNC:
    ld R22, Z+              ; Carrega endereço de salto (byte baixo)
    ld R23, Z+              ; Carrega endereço de salto (byte alto)
    mov ZL, R22             ; Define byte baixo do endereço em ZL
    mov ZH, R23             ; Define byte alto do endereço em ZH
    rjmp fetch_decode_execute

NOP_FUNC:
    nop                     ; Executa uma operação nula
    rjmp fetch_decode_execute

	; Programa de Exemplo Carregado na Memória

.org 0x0100
    .db LOAD, 0x17, 0x20    ; LOAD R0, Endereço 0x20
    .db ADD_OPERATION, 0x17, 0x18     ; ADD R0, R1
    .db STORE, 0x17, 0x30   ; STORE R0, Endereço 0x30
    .db JMP_OPERATION, 0x01, 0x00     ; Salta para o início do programa




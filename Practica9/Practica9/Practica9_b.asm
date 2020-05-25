/*
 * Practica9_b.asm
 *
 *  Created: 5/21/2020 6:21:06 PM
 *   Author: pjco9
 */ 

.ORG 0x00 ;Vector de int. “RESET”
JMP CONF_SIST ;Manejo de la interrupción “RESET”. Ocupa las direcciones 0x00 y 0x01.

.ORG 0x02 ;Vector de int. “INT0”
JMP MANEJO_INT0

.ORG 0x04
JMP MANEJO_INT1


.ORG 0x100 ;Dirección 100h del programa.
 CONF_SIST: ;Dirección 100h

.DEF SECUENCIA = R17
LDI SECUENCIA, 0x01
//CONF PUERTOS
LDI R18, 0xFf
OUT $0004, R18
LDI r18, 0x00
OUT $000A, R18

//configuracion de interrupciones
LDI r16, 0b0000_1111 ;Dirección 100h.
STS 0x69, r16 ;EICRA = r16, esta instrucción está en la dirección 101h, ya que LDI solo ocupa 16 bits. Se configura EICRA para que la señal de interrupción de INT1 sea en cualquier cambio lógico.
LDI r16, 0b0000_0011;SE HABILITA INT 0
OUT 0x1D, r16 ;EIMSK = r16, habilitando INT0.
SEI ;Habilitamos las interrupciones globales.

JMP START ;Saltamos al inicio de programa.

.ORG 0x500
START:
JMP START

.ORG 0x700
MANEJO_INT0:
OUT $0005, SECUENCIA
LSL SECUENCIA
SBRC SECUENCIA, 4
LDI SECUENCIA, 0x01
RETI

.ORG 0x900

MANEJO_INT1:
OUT $0005, SECUENCIA
LSL SECUENCIA
SBRC SECUENCIA, 4
LDI SECUENCIA, 0x01

    ldi  r21, 33
    ldi  r22, 120
    ldi  r23, 153
L1: dec  r23
    brne L1
    dec  r22
    brne L1
    dec  r21
    brne L1

  IN r24,$0009
  SBRC  r24, 3
  jmp MANEJO_INT1
  RETI





-
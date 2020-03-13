/*
 * practica6_b.asm
 *
 *  Created: 3/11/2020 6:38:52 PM
 *   Author: pjco9
 */ 

 LDI r17, 0xFF
STS $002A,r17//outputs

LDI r26, 0x00//se pone cero en el registro 26
LDI r25, 0x01//se pone un uno en el registro 25

//control del registro CLKPR.
LDI R17, 0X00
STS $0061,R17
LDI R17, 0X80
STS $0061, R17
LDI R17, 0b0000_0100
STS $0061,R17//cambia(reescala)la frecuencia. 100 = 16

start://empieza.
STS $002B,r25//se carga el uno en el puerdo D(salida)
CALL DELAY//se llama al delay
STS $002B, r26//se carga el cero en el puerdo D(salida)
CALL DELAY//se llama al delay
rjmp start//se regresa al inicio.

DELAY://delay de un segundo segun los 0.5 hz
 ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    lpm
    nop
	ret//regresa al lugar donde fue llamado.
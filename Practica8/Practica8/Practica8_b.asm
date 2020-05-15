/*
 * Practica8_b.asm
 *
 *  Created: 5/12/2020 9:56:54 PM
 *   Author: pjco9
 *
 *	Objetivo: 
 b)Diseñe un circuito que permita a 8 push-buttons estar conectados 
 a una única entrada del  ADC.Desarrolle  un programa  el  cual 
 reconocerá  cuál  de  los  8  push-button  está presionado y mostrará 
 el número correspondiente en un display de 7 segmentos.(20% -Obligatorio)

 */ 

 .def control = r16//palabra de control

LDI r17,0xFF // se carga el registro 18 con 1´s
STS $002A, r17 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

// ----------------------- ADC ---------------------//
LDI control, 0x00
sts $0064,control
LDI control, 0x20
STS $007C, control
LDI control, 0x87
STS $007A, control
LDI control, 0xC7 // para realizar la conversion se pone la siguiente palabra de control 1100 0111 y hacer la conversion
// -------------------END ADC -----------------------//
STS $002B, r17

START:
 STS $007A, control
 //control de sobre lectura para el adc
 rompeADC:
 LDS r31, $007A
 SBRS r31, 6
 jmp MUESTRA
 jmp rompeADC

 MUESTRA:
 LDS r17,$0079//ADCH va al registro r17

//comparaciones, dependiendo del valor del registro 
//se salta a las diferentes etiquetas
CPI r17, 0x00
BREQ UNO
CPI r17, 0x01
BREQ UNO
CPI r17, 0x02
BREQ UNO 
CPI R17, 0X80
BREQ DOS
CPI R17, 0XAA
BREQ TRES
CPI r17, 0xBF
BREQ CUATRO
CPI R17, 0XCC
BREQ CINCO
CPI r17, 0xD5
BREQ SEIS
CPI r17, 0xDB
BREQ SIETE
CPI R17, 0XDF
BREQ OCHO
JMP START//si n o cumple ninguno va al start

/* etiquetas para formar los numeros que saldran en el display*/
UNO:
LDI R24, 0x06
STS $002B, r24
JMP DELAY2
DOS:
LDI R24, 0x5b
STS $002B, r24
JMP DELAY2
TRES:
LDI R24, 0x4F
STS $002B, r24
JMP DELAY2
CUATRO:
LDI R24, 0x66
STS $002B, r24
JMP DELAY2
CINCO:
LDI R24, 0x6D
STS $002B, r24
JMP DELAY2
SEIS:
LDI R24, 0x7D
STS $002B, r24
JMP DELAY2
SIETE:
LDI R24, 0x07
STS $002B, r24
JMP DELAY2
OCHO:
LDI R24, 0x7F
STS $002B, r24
JMP DELAY2

delay2:
    ldi  r18, 2
    ldi  r19, 160
    ldi  r20, 147
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    nop
    jmp start























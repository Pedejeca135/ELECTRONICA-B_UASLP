/*
 * Practica8_c.asm
 *
 *  Created: 5/12/2020 9:57:24 PM
 *   Author: pjco9
 Objetivo:

c)Desarrolle un programa el cual simulará una barra de audio,en 14puntas de prueba,teniendo 
como entrada el potenciómetro como divisor de voltaje.Si la entrada del ADC no  tiene  
diferencia  de  potencial  con  respecto  a  el  voltaje  en  el  pin  AREF,  todas  
las puntas de prueba estarán prendidas.Si no tiene diferencia de potencial con respectoa 
GND del ATmega328P, todas las puntas estarán apagadas.(30% -Opcional)

 */ 
.def control = r16//palabra de control del ADC.
.def volumenBajo = r24//para el registro de volumken bajo correscondoiente al puerto d
.def volumenAlto = r25//para el registro de volumen alto correspondiente al puerto b

LDI volumenBajo, 0x00;; empieza en cero
LDI volumenAlto,0x00;,volumen inicializa en cero

LDI r17,0xFF // se carga el registro 18 con 1´s
STS $002A, r17 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs
STS $0024,r17


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
pepe:
LDS r31, $007A
SBRS r31, 6
jmp MUESTRA
jmp pepe
MUESTRA:
LDS r17,$0079//ADCL
/* comparacion del valor del registro alto del adc¨*
/*si es mayor o igual salta a las etiquetas de volumen*/
CPI r17,0xEA
BRSH V14
CPI r17,0xD8
BRSH V13
CPI r17,0xC6
BRSH V12
CPI r17,0xB4
BRSH V11
CPI r17,0xA2
BRSH V10
CPI r17,0x90
BRSH V9
CPI r17,0x7E
BRSH V8
CPI r17,0x6C
BRSH V7
CPI r17,0x5A
BRSH V6
CPI r17,0x48
BRSH V5
CPI r17,0x36
BRSH V4
CPI r17,0x24
BRSH V3
CPI r17,0x12
BRSH V2
CPI r17,0x04
BRSH V1
CPI r17,0x00
BRSH V0
JMP START//si no se cumple ninguno se pasa el inicio

//las etiquetas para el valor de los registros de los volumenes*/
V14:
LDI volumenBajo,0xFF
LDI volumenAlto,0x3F
JMP ASIGNA

V13:
LDI volumenBajo,0xFF
LDI volumenAlto,0x1F
JMP ASIGNA

V12:
LDI volumenBajo,0xFF
LDI volumenAlto,0x0F
JMP ASIGNA

V11:
LDI volumenBajo,0xFF
LDI volumenAlto,0x07
JMP ASIGNA

V10:
LDI volumenBajo,0xFF
LDI volumenAlto,0x03
JMP ASIGNA

V9:
LDI volumenBajo,0xFF
LDI volumenAlto,0x01
JMP ASIGNA

V8:
LDI volumenBajo,0xFF
LDI volumenAlto,0x00
JMP ASIGNA

V7:
LDI volumenBajo,0x7F
LDI volumenAlto,0x00
JMP ASIGNA

V6:
LDI volumenBajo,0x3F
LDI volumenAlto,0x00
JMP ASIGNA

V5:
LDI volumenBajo,0x1F
LDI volumenAlto,0x00
JMP ASIGNA

V4:
LDI volumenBajo,0x0F
LDI volumenAlto,0x00
JMP ASIGNA

V3:
LDI volumenBajo,0x07
LDI volumenAlto,0x00
JMP ASIGNA

V2:
LDI volumenBajo,0x03
LDI volumenAlto,0x00
JMP ASIGNA

V1:
LDI volumenBajo,0x01
LDI volumenAlto,0x00
JMP ASIGNA

V0:
LDI volumenBajo,0x00
LDI volumenAlto,0x00
JMP ASIGNA

//asignacion de los valores de volumenes
ASIGNA:
STS $002B, volumenBajo
STS $0025 , volumenAlto
JMP DELAY2

DELAY2:
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
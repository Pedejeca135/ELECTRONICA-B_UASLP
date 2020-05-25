/*
 * Practica10_a.asm
 *
 *  Created: 5/25/2020 6:26:27 AM
 *   Author: pjco9
 */ 
 .org 0x00 
jmp conf_sist
 .org 0x001E //direccion de TIMER0_COMPB 
jmp MANEJO_TIMER0_B  
 .org 0x100
 conf_sist:
 // definicion de registros 
.def conf = r16 
.def led = r17 
ldi led, 0x00 
//configuracion del puerto b y d 
LDI conf, 0xFF 
sts $0024, conf
 LDI conf, 0x00 
STS $002A, conf 
 // configuracion de interrupcion interna 
LDI conf, 0x04 
STS $006E, conf// configuracion del registro de Mascara de interrupcion  de TC0 
LDI conf, 0x00 
sts $0046, conf // configuracion de contador TC0 
LDI conf, 0x03
sts $0048, conf // configuracion del registro de comparacion B de TC0 
SEI 
LDI conf, 0x07 
sts $0045, conf// Configuracion de TC0 Control Register B  
jmp start
.org 0x500 
start: 
jmp start
.org 0x700
MANEJO_TIMER0_B:
com led
sts $0025,led
LDI conf, 0x00 
sts $0046, conf // configuracion de contador TC0 
RETI
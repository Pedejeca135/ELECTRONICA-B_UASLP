;
; Practica10.asm
;
; Created: 5/23/2020 11:52:47 AM
; Author : pjco9

.org 0x00 //definicion de la interrupcion inicial.
jmp conf_sist//el jump inicial.
 
.org 0x1E //direccion de TIMER0_COMPB 
jmp MANEJO_TIMER0_B//


 .org 0x100
 conf_sist:
 // definicion de registros 
.def conf = r16 
.def led = r17 
ldi led, 0x02 
//configuracion del puerto b y d 
LDI conf, 0xFF //salidas.
STS $0024, conf
LDI conf, 0x00 //entradas.
STS $002A, conf 
// configuracion de interrupcion interna 
LDI conf, 0x04 
STS $006E, conf// configuracion del registro de Mascara de interrupcion  de TC0 REgistro TIMSK0

LDI conf, 0x00 
sts $0046, conf // configuracion de contador TC0 

LDI conf, 0x05
sts $0048, conf // configuracion del registro de comparacion B de TC0 

SEI 

LDI conf, 0x06 
sts $0045, conf// Configuracion de TC0 Control Register B  
jmp start

.org 0x500 
start: 
jmp start
 
.org 0x700
MANEJO_TIMER0_B:
SBRC led, 0 
rjmp ma 
SBRS led, 0
LSR led 
rjmp me 
ma: 
LSL led
me: 
OUT $0005, led 
RETI

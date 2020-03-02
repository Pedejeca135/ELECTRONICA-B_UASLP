/*
 * zer0.asm
 *
 *  Created: 2/28/2020 5:41:20 PM
 *   Author: pjco9
 */ 

 ;
; Timer0_electroB.asm
;
; Created: 28/2/2020 17:09:06
; Author : Pablo
;


; Replace with your application code
;
; Actividad_interrupcion_Timer0.asm
;
; Created: 2/28/2020 5:08:26 PM
; Author : pjco9
;

;Declaraciones

.def temp = r16
.def overflows = r17

.org 0x0000
rjmp Reset

.org 0x0020 
rjmp overflow_handler

Reset:
ldi temp, 0b00000101
out TCCR0B, temp

ldi temp, 0b00000001
sts TIMSK0,temp

sei

clr temp
out TCNT0, temp

sbi DDRB,5

blink:
sbi PORTB, 5
rcall delay 
cbi PORTB,5
rcall delay
rjmp blink

delay:
clr overflows
sec_count:
cpi overflows,30
brne sec_count
ret

overflow_handler:
inc overflows
cpi overflows, 61
brne PC+2
clr overflows
reti
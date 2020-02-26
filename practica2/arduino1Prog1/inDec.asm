/*
 * inDec.asm
 *
 *  Created: 2/21/2020 11:58:34 AM
 *   Author: pjco9
 */ 
 
; Replace with your application code
LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r20, 0x00
start:
 LDS r19,$0026
 ANDI r19, 0b0000_0011
 CPI r19, 0x02
 BREQ incremento
 CPI r19, 0x01
 BREQ decremento
 JMP start

 rompe:
   LDS r19,$0026
   CPI r19,0x00
   BREQ start 
   JMP rompe

 incremento:
   CPI r20,0xFF
   BREQ positivo
   INC r20
   STS $002B,r20
   JMP rompe

 positivo:
   LDI r20,0x00
   STS $002B,r20
   JMP start

 decremento:
   CPI r20,0x00
   BREQ complemento
   DEC r20
   STS $002B,r20
   JMP rompe
   
 complemento:
  LDI r20,0xFF
  STS $002B,r20
  JMP start


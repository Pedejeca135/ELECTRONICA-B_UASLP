/*
 * aux_b.asm
 *
 *  Created: 5/13/2020 2:09:31 PM
 *   Author: pjco9
 */ 
 .def control = r16

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
LDS r17, $0023
SBRC r17,0 // indica si en el bit 3 del r19 esta en alto (push)
JMP conversion
jmp start

 conversion:
 call delay
 STS $007A, control
 pepe:
  LDS r31, $007A
  SBRS r31, 6
  jmp MUESTRA
  jmp pepe
 MUESTRA:
 LDS r17,$0079//ADCL
 STS $002B, r17

JMP delay2

delay:
    ldi  r18, 2
    ldi  r19, 160
    ldi  r20, 147
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
ret

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
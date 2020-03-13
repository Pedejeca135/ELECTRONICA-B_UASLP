/*
 * practica6_c.asm
 *
 *  Created: 3/11/2020 6:51:40 PM
 *   Author: pjco9
 */ 

 LDI r17, 0x00
STS $0027, r17
LDI r17, 0xFF
STS $002A, r17
start:

 LDI r25,0b0111_0011
 STS $002B,r25
 call checa
 call delay_1segundo
 call checa
 LDI r25,0x7B
 STS $002B,r25
 call checa
 call delay_1segundo   
 call checa
 LDI r25,0x5E
 STS $002B,r25
 call checa
 call delay_1segundo  
 call checa
 LDI r25,0x70
 STS $002B,r25
 call checa
 call delay_1segundo  
 call checa
 LDI r25,0x5C
 STS $002B,r25
 call checa
 call delay_1segundo
 jmp start
 delay_1segundo: 
    ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    lpm
    nop
	ret

	checa:
	LDS r17, $0026
	SBRC r17,0
    JMP delay			
    ret



// logic
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

	rompe: 
	LDS r17, $0026
	SBRS r17, 0
	JMP delay2
	jmp rompe
	
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
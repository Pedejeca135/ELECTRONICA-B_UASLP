/*
 * Practica11_BRAu.asm
 *
 *  Created: 6/1/2020 10:16:17 AM
 *   Author: pjco9
 */ 

.def config = r16
.def puertoB = r17
.def puertoC = r18
.def puertoD = r19
.org 0x00
jmp reset
.org 0x0024
jmp USART_RX
.org 0x100
reset:
	//USART/
	ldi config,0b1001_0000
	sts UCSR0B,config
	ldi config,0b00_00_0110
	sts UCSR0C,config
	/*Baudios*/
	ldi config,0b0110_0111
	sts 0xC4,config
	ldi config,0b00000000
	sts 0xC5,config
	/* I/O Ports*/
	ldi config, 0xFF
	out ddrb, config
	out ddrc, config
	mov puertoD,config
    sei 
	jmp main
	
.org 0x500
main:
    jmp main
	
	
delay:
	ldi  r21, 41
	ldi  r22, 150
	ldi  r23, 128
L1:
	dec  r23
	brne L1
	dec  r22
	brne L1
	dec  r21
	brne L1
	ret

.org 0x700
USART_RX:
	lds puertoD,0xC6
    cpi puertoD,0b0011_0000//0
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x3F
		
    cpi puertoD,0b0011_0001//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x86
		
    cpi puertoD,0b0011_0010//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x5B
		
		
    cpi puertoD,0b0011_0011//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xCF


    cpi puertoD,0b0011_0100//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x66


    cpi puertoD,0b0011_0101//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xED


    cpi puertoD,0b0011_0110//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x7D


    cpi puertoD,0b0011_0111//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x87


    cpi puertoD,0b0011_1000//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x7F


    cpi puertoD,0b0011_1001//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xE7


    cpi puertoD,0b0100_0001//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x77


    cpi puertoD,0b0100_0010//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xFC


    cpi puertoD,0b0100_0011//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x39


    cpi puertoD,0b0100_0100//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xDE


    cpi puertoD,0b0100_0101//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0x79


    cpi puertoD,0b0100_0110//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD, 0xF1


	mov puertoB,puertoD
	andi puertoB,0x0F
	mov puertoC,puertoD
	ror puertoC
	ror puertoC
	ror puertoC
	ror puertoC
	andi puertoC,0x0F
	out portb,puertoB
	out portc,puertoC
	call delay
	call delay
	call delay
	reti
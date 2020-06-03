;
; Laboratorio-Practica11.asm
;
; Created: 30/05/2020 12:15:27 p. m.
; Author : Braulio García
;

.def config = r16
.def puertoB = r17
.def puertoC = r18
.def puertoD = r19
.def aux = r20
.org 0x00
jmp reset

.org 0x100
reset:
   //USART/
    ldi config,0b0000_1000
    sts UCSR0B,config
    ldi config,0b00_00_0110
    sts UCSR0C,config
    /*Baudios*/
    ldi config,0b0110_0111
    sts 0xC4,config
    ldi config,0b0000_0000
    sts 0xC5,config
    /* I/O Ports*/
    ldi config, 0xFF
    out ddrd, config
    out ddrb, config
    ldi config, 0x00
    out ddrc, config
    mov puertoD,config
    sei 
    jmp main

main:
    ldi puertoB,0x01
    out portb,puertoB
    in puertoC,pinc
    andi puertoC,0x0F
    cpi puertoC,0x00
    brne rebote

    rol puertoB
    out portb,puertoB
    in puertoC,pinc
    andi puertoC,0x0F
    cpi puertoC,0x00
    brne rebote

    rol puertoB
    out portb,puertoB
    in puertoC,pinc
    andi puertoC,0x0F
    cpi puertoC,0x00
    brne rebote

    rol puertoB
    out portb,puertoB
    in puertoC,pinc
    andi puertoC,0x0F
    cpi puertoC,0x00
    brne rebote

    jmp main
    
    rebote:
    rol puertoC
    rol puertoC
    rol puertoC
    rol puertoC
    or puertoC,puertoB
    mov aux,puertoC
    call delay
    espera:
        in puertoC, pinc
        andi puertoC,0x0F
        cpi puertoC, 0x00
            brne espera
    jmp transmite

    
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

transmite:
	cpi aux, 0b0001_0100//0
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x30

    cpi aux, 0b1000_1000//1
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x31

    cpi aux, 0b1000_0100//2
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x32

    cpi aux, 0b1000_0010//3
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x33

    cpi aux, 0b0100_1000//4
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x34

    cpi aux, 0b0100_0100//5
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x35

    cpi aux, 0b0100_0010//6
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x36

    cpi aux, 0b0010_1000//7
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x37

    cpi aux, 0b0010_0100//8
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x38

    cpi aux, 0b0010_0010//9
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x39

    cpi aux, 0b1000_0001//A
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x41

    cpi aux, 0b0100_0001//B
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x42

    cpi aux, 0b0010_0001//C
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x43

    cpi aux, 0b0001_0001//D
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x44

    cpi aux, 0b0001_1000//E
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x45

    cpi aux, 0b0001_0010//F
    lds config, 0x5F
    sbic 16,1
        ldi puertoD,0x46

	ldi config,0x00
    sts UCSR0A,config
	sts UDR0,puertoD

	transmision:
		lds config,UCSR0A
		sbrs config,6
			jmp transmision
	jmp main
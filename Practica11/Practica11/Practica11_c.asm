/*
 * Practica11_c.asm
 *
 *  Created: 5/29/2020 7:13:28 PM
 *   Author: pjco9
		Objetivo:
		c) Utilice el ADC del ATmega328P para obtener alguna medición de una fuente variable.
		Convertir y enviar el valor por la USART para mostrarlo en la pantalla de la PC.
		(30% - Opcional)
		
 */ 


 .org 0x00
jmp conf_sist


.org 0x002A //direccion del vector de interrupcion del ADC.
jmp ADC_INTERRUPT

.org 0x100 
 conf_sist:
.def control = r19
// ----------------------- ADC ---------------------// 
LDI control, 0x00 
sts $0064,control // registro PRR se pone todo en 0 para controlar la energia que se consume
LDI control, 0x20
 STS $007C, control// Se ajusta con 0010_0000  para configurar que se usa AREF, ajusta el resultado a la izquierda, y // seleccionamos el canal A0 de lectura 

LDI control, 0x8F // 88 = 1000_1111 se busca que ADIE(bit 3 este en alto para habilitar interrupciones.)
STS $007A, control
 LDI control, 0xCF // para realizar la conversion se pone la siguiente palabra de control 1100 1111 y hacer la conversion
 // -------------------END ADC -----------------------//
  // ------------------------------Configuracion de USART-------------------------------------//
 ldi control, 0x08 // UCSR0B habilitacion de transmisor
 STS $00C1, control
 ldi control, 0x06 // UCSR0C configuracion de USART para 8 bits y modo de operaciones sin paridad
 STS $00C2, control
 ldi control, 0x67 // UBRR0L baudaje de 9600 
 STS $00C4, control 
 LDI control, 0x00 // UBRR0H baudaje de 9600 
 STS $00C5, control 

 // definicion de registros 
.def conf = r16 

//configuracion del puerto b, d y c
//LDI conf, 0xFF //salidas.
//STS $002A, conf//puerdo d salidas
LDI conf, 0x00 //entradas.
STS $0024, conf //puerto b entradas
STS $0027  , conf//puerto c entradas
SEI
jmp start 
.org 0x500
START:
    LDS r20, $0023
    SBRC r20, 0
    jmp convierte
    JMP START

convierte:
STS $007A, control
co:
LDS r31 , $007A
SBRS r31, 6
jmp start
jmp co


.org 0x700
ADC_INTERRUPT: //etiqueta para la interrupcion del ADC.
LDS r31, $0079
 
CPI r31,0b1100_1101
BRGE V5
CPI r31,0b1001_1001
BRGE V4
CPI r31,0b0110_0110
BRGE V3
CPI r31,0b0011_0011
BRGE V2
CPI r31, 0x00
breq v0
jmp v1

v5:
LDI r31, 0x35
jmp muestra
v4:
LDI r31, 0x34
jmp muestra
v3:
LDI r31, 0x33
jmp muestra
v2:
LDI r31, 0x32
jmp muestra
V1:
LDI r31, 0x31
jmp muestra
V0:
LDI r31, 0x30
jmp muestra

muestra:
lds r30, $00C0
sbrs r30, 5
rjmp muestra
sts $00C6, r31
CALL DELAY_500
RETI

Delay_500:
    ldi  r27, 41
    ldi  r28, 150
    ldi  r29, 128
L3: dec  r29
    brne L3
    dec  r28
    brne L3
    dec  r27
    brne L3
	RET
/*
 * Practica10_a.asm
 *
 *  Created: 5/25/2020 5:47:44 AM
 *   Author: pjco9
 c) objetivo:Combine los programas de los incisos a) y b) de manera que cada vez que el contador
genere su interrupción, se inicie una conversión en el ADC. Cada vez que el ADC
termine la conversión y genere su interrupción interna, se mostrará el resultado en 8
puntas de prueba y se reiniciará el contador. El contador obtendrá su señal de un reloj
externo de 1hz.
(30% - Opcional)
 */ 

.org 0x00 
jmp conf_sist
 
 .org 0x001E //direccion de TIMER0_COMPB 
jmp MANEJO_TIMER0_B  

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

 // definicion de registros 
.def conf = r16 
.def led = r17 
ldi led, 0x00 

//configuracion del puerto b y d 
LDI conf, 0xFF 
sts $0024, conf//port b salidas
//sts $0027, conf//portc salidas
LDI conf, 0x30
STS $0027, conf//solo los bits mas significativos
LDI conf, 0x00 
STS $002A, conf //portd salidas


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
SEI
STS $007A, control
co:
LDS r31 , $007A
SBRS r31, 6
jmp start
jmp co



.org 0x900
ADC_INTERRUPT: //etiqueta para la interrupcion del ADC.
LDS r31, $0079

MOV r30,r31
LSR r30
LSR r30
ANDI r30, 0b0011_0000
LSR r31
LSR r31
ANDI r31, 0b0011_1111

STS $0025 , r31//sacar el valor de la lectura realizada con el ADC a las salidas del puerto B.
STS $0028, r30//sacar el valor de la lectura realizada con el ADC a las salidas del puerto C.

LDI conf, 0x00 
sts $0046, conf // configuracion de contador TC0
RETI
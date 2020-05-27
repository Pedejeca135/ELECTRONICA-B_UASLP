/*
 * Practica10_b.asm
 *
 *  Created: 5/25/2020 6:26:54 AM
 *   Author: pjco9

 b) Objetivo: Desarrolle un programa el cual configurará el ADC del ATmega328P para utilizar
interrupciones internas. Un push-button (eliminar rebotes por software) mandará una
señal para indicar el inicio de conversión. Una vez terminada la conversión, se generará
una interrupción interna y su subrutina de manejo mostrará el resultado por 8 puntas de
prueba.
(20% - Obligatorio)
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
 // definicion de registros 
.def conf = r16 
//configuracion del puerto b, d y c
LDI conf, 0xFF //salidas.
STS $002A, conf//puerdo d salidas
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
STS $002B , r31//sacar el valor de la lectura realizada con el ADC a las salidas del puerto D.
RETI
 /*
 * practica8_a.asm
 *
 *  Created: 5/12/2020 3:16:30 PM
 *   Author: pjco9

  Objetivo:

a)Modifique el programa de la práctica 4, inciso a), de manera que el dato que se toma y almacena  en  
RAM  es  proveniente  del  ADC  del  ATmega328P.  El push-button  para ingresar datos será reemplazado 
por la señal proveniente del circuito del fototransistor, y el push-button de salida eliminará sus 
rebotes por software. Utilice solamente los 8 bits más significativos del ADC. Una vez que se almacenó 
en lamemoria RAM, con el botón de salida se mostrarán los8 bits más significativosen 8 puntas de prueba.
(20% -Obligatorio).

 */ 
.def control = r16

// -------- PILA -------- //
//LDI r17, 0x00 // se carga el registro 17 con 0´s
//STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs   Data direction register 

STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r26, 0x55 // es la parte de la direccion en bajo para x 
LDI r27, 0x01 // parte de la direccion en alto para x

LDI r28, 0x55 // es la parte de la direccion en bajo para y
LDI r29, 0x01 //parte de la direccion en alto para y
LDI r22, 0xFF// para prender todos los leds
// ------ END PILA --------//


// ----------------------- ADC ---------------------//
LDI control, 0x20
STS $007C, control
LDI control, 0x87
STS $007A, control
LDI control, 0xC7 // para realizar la conversion se pone la siguiente palabra de control 1100 0111 y hacer la conversion
// -------------------END ADC -----------------------//
LDI r17, 0x01
LDI r18, 0x01
start:
LDI r21,0x00 // bandera de control de de pila vacia
LDS r19, $0023 // lee las signals del puerto b
// -------------- PILA VACIA -----------------//
CP r27, r29 // comparacion si x y Y apuntan a la misma direccion en alto 
BREQ comp // salto si son iguales
JMP Operacion_pila // salto
comp:
 CP r26,r28 // comparacion si x y Y apuntan a la misma direccion en bajo
 BREQ prende_leds // salto si son iguales
 JMP Operacion_pila // salto

 prende_leds:
  STS $002B, r22 // datos de salida a puerto D 
  LDI r21,0xFF // registro para saber si esta vacia la pila
// ------------- END PILA VACIA ---------------//

 Operacion_pila:
 SBRC r19,1 // indica si en el bit 2 del r19 esta en alto (pop)
 JMP poping // salta 
 SBRC r19,0 // indica si en el bit 3 del r19 esta en alto (push)
 JMP pushing // salta
 JMP start // salto a inicio

 poping:
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 
 LD r17,-X // pone el valor de la direccion x en r17 y baja el valor de la direccion en x 
 STS $002B,r17 // muestra en puerto D el valor obtenido del pop
 JMP rompe // salto a etiqueta

 pushing:
  //ADD r17,r18
  STS $007A,control;
  LDS r17,$0079//ADCH
  ST X+,r17 // hace un push a la pila 
  JMP rompe // salto a etiqueta

  rompe: 
   LDS r19, $0023 // obtiene los valores de entrada en el puerto B
   ANDI r19, 0b0000_0011 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ delay //delay // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar
 
 delay:
    ldi  r30, 17
    ldi  r31, 60
    ldi  r20, 204
L1: dec  r20
    brne L1
    dec  r31
    brne L1
    dec  r30
    brne L1
jmp start

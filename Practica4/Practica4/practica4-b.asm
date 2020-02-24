/*
 * practica4_b.asm
 *
 *  Created: 2/24/2020 12:58:10 PM
 *   Author: pjco9
 *
 *	objetivo:
 *	Implemente un programa el cual tenga la misma funcionalidad que el programa del
 *	inciso a), pero en vez de utilizar la RAM, utilice la EEPROM del dispositivo. La
 *  información guardada debe de estar disponible después de apagar y volver a prender el
 *	dispositivo
 */ 
LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs   Data direction register 

STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r28, 0x00 // registro high de y en 0 
LDI r29, 0x00 // registro low de y en 0

LDI r17, 0x01
STS $003F, r17 // para lectura de EEPROM

LD r26, Y+ // cargar en el registro bajo de x, lo que hay en la direccion de y
LD r27, Y+ // cargar en el registro alto de x, lo que hay en la direccion de y

LDI r22, 0xFF// para prender todos los leds cuando pila esta vacia

start:
LDI r21,0x00 // bandera de control de de pila vacia
LDS r17, $0026 // lectura de los 6 bits mas significativos
LDS r18, $0023 // lectura de los 2 bits menos significativos
LDS r19, $0023 // lectura de push buttons

SBRC r19,4
JMP reset

LSL r17 // desplazamiento a la izquierda del registro 17
LSL r17 // segundo desplazamiento a la izquierda del registro 17
ANDI r18, 0b0000_0011 // enmascaramiento para los bits menos significativos 
ADD r17,r18 // suma de los 8 bits de entrada
// ---------------------------------------------------------------------
//----------------------------------------------------------------------

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

 Operacion_pila:
 SBRC r19,2 // indica si en el bit 2 del r19 esta en alto (pop)
 JMP poping // salta 
 SBRC r19,3 // indica si en el bit 3 del r19 esta en alto (push)
 JMP pushing // salta
 JMP start // salto a inicio

 // ------------------------------------------------------------------
 // ------------------------------------------------------------------
 // ------------------------------------------------------------------

 poping:
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 

 LD r17,-X // pone el valor de la direccion x en r17 y baja el valor de la direccion en x 
 
 
 STS $002B,r17 // muestra en puerto D el valor obtenido del pop
 
 
 JMP rompe // salto a etiqueta

 pushing:
   STS EEARH, r27 // actualiza la direccion de la EEPROM en alto con x
   STS EEARL, r26 // actualiza la direccion de la EEPROM en bajo con x
   LDI r24, 0x26 // pone palabra de control para escritura en un registro

   STS EEDR,r17 // pone el dato en el registro de datos de la EEPROM
   STS EECR,r24 // Escribe lo que hay en EEDR en la direccion de memoria que tiene EEARH y EEARL

   
   

   JMP rompe // salto a etiqueta

  rompe: 
   LDS r19, $0023 // obtiene los valores de entrada en el puerto B
   ANDI r19, 0b0000_1100 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ start // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar
 
 reset:
   LDI r25, 0x00 // pone en 0's r25
   LDI r24, 0x26 // pone palabra de control para escritura en un registro
   LDI r18, 0x01 // pone un 1 en r18


   STS EEARH, r25 
   STS EEARL, r25
   STS EEDR, r25
   STS $003F, r24

   STS EEARH, r25
   STS EEARL, r18
   STS $0040, r25
   STS $003F, r24


   LDI r30, 0x00
   LDI r31, 0x00
   LD r26, Z+ // cargar en el registro bajo de x, lo que hay en la direccion de y
   LD r27, Z+ // cargar en el registro alto de x, lo que hay en la direccion de y

   JMP start

/*
 * practica4_a.asm
 *
 *  Created: 2/24/2020 12:57:43 PM
 *   Author: pjco9

  Objetivo:
	Implemente un programa en el cual se ingresará un dato de 8 bits por medio de un
	dipswitch y un push-button. En cuanto se presione el push-button, este dato se
	almacenará en la memoria RAM por medio de una pila, empezando por la dirección
	0x155 (hexadecimal). Con otro push-button, se tomará y eliminará el último elemento
	en ingresar a la pila (Eliminar los rebotes de los push-button por hardware). Este
	elemento eliminado se mostrará en las puntas de prueba hasta que se vuelva a presionar
	el push-button de salida. Si no hay elementos en la pila cuando se presione el botón de
	salida, todas las puntas de prueba se prenderán hasta que se muestre otro dato
	ingresado. (Los valores dentro del programa se manejarán en hexadecimal).
 */ 

LDI r17, 0x00 // se carga el registro 17 con 0´s
STS $0027,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto c para configurarlos como inputs   Data direction register 

STS $0024,r17 // se asigna el valor del registro a una direccion de memoria del registro del puerto b para configurarlos como inputs

LDI r18,0xFF // se carga el registro 18 con 1´s
STS $002A, r18 // se asigna el valor del registro 18 al puerto D para configurarlos como outputs

LDI r26, 0x55 // es la parte de la direccion en bajo para x 
LDI r27, 0x01 // parte de la direccion en alto para x

LDI r28, 0x55 // es la parte de la direccion en bajo para y
LDI r29, 0x01 //parte de la direccion en alto para y

LDI r22, 0xFF// para prender todos los leds

start:

LDI r21,0x00 // bandera de control de de pila vacia

LDS r17, $0023 // lectura de los 6 bits mas significativos
LDS r18, $0026 // lectura de los 2 bits menos significativos
LDS r19, $0026 // lectura de push buttons

LSL r17 // desplazamiento a la izquierda del registro 17
LSL r17 // segundo desplazamiento a la izquierda del registro 17
ANDI r18, 0b0000_0011 // enmascaramiento para los bits menos significativos 
ADD r17,r18 // suma de los 8 bits de entrada


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

 poping:
 CPI r21,0xFF // comparacion de bandera para aver si la pila esta vacia
 BREQ start // Si sí, salta a inicio 
 LD r17,-X // pone el valor de la direccion x en r17 y baja el valor de la direccion en x 
 STS $002B,r17 // muestra en puerto D el valor obtenido del pop
 JMP rompe // salto a etiqueta

 pushing:
  ST X+,r17 // hace un push a la pila
  JMP rompe // salto a etiqueta

  rompe: 
   LDS r19, $0026 // obtiene los valores de entrada en el puerto C
   ANDI r19, 0b0000_1100 // enmascara para solamente ver los bits de push y pop
   CPI r19, 0x00 // Compara si ya se dejaron de aplanar
   BREQ start // Si sí, salta al inicio  
   JMP rompe // si no vuelve a llamarse para esperar a que se dejen de apretar
 
